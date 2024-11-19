use GrouAssignment
//Data Cleaning
db.customer_support.updateMany(
    {},
    [
        { $set: { category: { $replaceAll: { input: "$category", find: " ", replacement: "" } } } }
    ]
)

db.customer_support.deleteMany({
    category: { $not: { $regex: /^[A-Z]+$/ } }
})

//Q1 
db.customer_support.aggregate([
    {
        $match:{
            category:{$regex:/^[A-Z]+$/}
        }
    },
    {
        $group:{
            _id:"$category"
        }
    }, 
    {
        $count: "NumberofCategories"
    }
    ])

//Q2     
db.customer_support.aggregate([
    {
        $match: { flags: { $exists: true, $ne: null } }
    },
    {
        $group: {
            _id: "$category",
            Colloquial: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /Q/ } }, 1, 0] } },
            Offensive: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /W/ } }, 1, 0] } },
            Others: { $sum: { $cond: [{ $and: [ { $not: [{ $regexMatch: { input: "$flags", regex: /Q/ } }] }, { $not: [{ $regexMatch: { input: "$flags", regex: /W/ } }] } ] }, 1, 0] } }
        }
    },
    {
        $project: { _id: 0, category: "$_id", Colloquial: 1, Offensive: 1, Others: 1 }
    }
]);

//Q3
db.flight_delay.aggregate([
    { $match: { Cancelled: 1 } },
    { $group: { _id: "$Airline", CancelledCount: { $sum: 1 } } },
    { $unionWith: { 
        coll: "flight_delay", 
        pipeline: [
            { $match: { $or: [{ ArrDelay: { $gt: 0 } }, { DepDelay: { $gt: 0 } }] } },
            { $group: { _id: "$Airline", DelayCount: { $sum: 1 } } }
        ]
    }}
]);

//Q4
db.flight_delay.aggregate([
    { $match: { $or: [{ ArrDelay: { $gt: 0 } }, { DepDelay: { $gt: 0 } }] } },
    { 
        $addFields: { 
            Year: { $year: { $dateFromString: { dateString: "$Date", format: "%d-%m-%Y" } } },
            Month: { $month: { $dateFromString: { dateString: "$Date", format: "%d-%m-%Y" } } },
            Route: { $concat: ["$Origin", " - ", "$Dest"] }
        }
    },
    { 
        $group: { 
            _id: { Year: "$Year", Month: "$Month", Origin: "$Origin", Route: "$Route" },
            DelayCount: { $sum: 1 }
        }
    },
    { 
        $group: { 
            _id: { Year: "$_id.Year", Month: "$_id.Month" },
            MaxDelayCount: { $max: "$DelayCount" },
            Routes: { $push: { Route: "$_id.Route", DelayCount: "$DelayCount" } }
        }
    },
    { $unwind: "$Routes" },
    { $match: { $expr: { $eq: ["$Routes.DelayCount", "$MaxDelayCount"] } } },
]);

//Q5
db.sia_stock.aggregate([
    {
        // Match documents where the year of StockDate is 2023
        $match: {
            $expr: {
                $eq: [
                    { $year: { $dateFromString: { dateString: "$StockDate", format: "%m/%d/%Y" } } },
                    2023
                ]
            }
        }
    },
    {
        // Add Year and Quarter fields by parsing the StockDate field
        $addFields: {
            Year: { $year: { $dateFromString: { dateString: "$StockDate", format: "%m/%d/%Y" } } },
            Quarter: {
                $switch: {
                    branches: [
                        { case: { $lte: [{ $month: { $dateFromString: { dateString: "$StockDate", format: "%m/%d/%Y" } } }, 3] }, then: 1 },
                        { case: { $lte: [{ $month: { $dateFromString: { dateString: "$StockDate", format: "%m/%d/%Y" } } }, 6] }, then: 2 },
                        { case: { $lte: [{ $month: { $dateFromString: { dateString: "$StockDate", format: "%m/%d/%Y" } } }, 9] }, then: 3 }
                    ],
                    default: 4
                }
            }
        }
    },
    {
        // Group by Year and Quarter and calculate Avg(Price), MAX(High), and MIN(Low)
        $group: {
            _id: { Year: "$Year", Quarter: "$Quarter" },
            AvgPrice: { $avg: "$Price" },
            MaxHigh: { $max: "$High" },
            MinLow: { $min: "$Low" }
        }},
]);

//Q10 Can be changes to customer_support, switching "Reviews" to "instruction" and removing Name
db.airlines_reviews.aggregate([
    {
        $match: { Recommended: "no" }
    },
    {
        $project: {
            Name: 1,
            Reviews: 1,
            Category: {
                $switch: {
                    branches: [
                        { 
                            case: { $regexMatch: { input: "$reviews", regex: /safety/i } }, 
                            then: "Safety-related" 
                        },
                        { 
                            case: { $regexMatch: { input: "$reviews", regex: /turbulence/i } }, 
                            then: "Turbulence-related" 
                        },
                        { 
                            case: { $regexMatch: { input: "$reviews", regex: /injury/i } }, 
                            then: "Injury-related" 
                        }
                    ],
                    default: "Others"
                }
            }
        }
    }
]);
