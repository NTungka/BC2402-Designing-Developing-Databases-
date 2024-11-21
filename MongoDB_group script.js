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
            _id:"$category",
            count: {$count: {}
        }
    }])


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
            Both: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /(?=.*Q)(?=.*W)/ } }, 1, 0] } },
            Others: { $sum: { $cond: [{ $and: [ { $not: [{ $regexMatch: { input: "$flags", regex: /Q/ } }] }, { $not: [{ $regexMatch: { input: "$flags", regex: /W/ } }] } ] }, 1, 0] } }
        }
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

//Q6

db.customer_booking.aggregate([
  {
    $group: {
      _id: { sales_channel: "$sales_channel", route: "$route" },
      avg_stay_flight_ratio: { $divide:[$avg:{"$length_of_stay"}, $avg:{"$flight_duration"}] } },
      avg_baggage_flight_ratio: { $divide:[$avg:{"$wants_extra_baggage"}, $avg:{"$flight_duration"}] } },
      avg_seat_flight_ratio: { $divide:[$avg:{"$wants_preferred_seat"}, $avg:{"$flight_duration"}] } },
      avg_meals_flight_ratio: { $divide:[$avg:{"$wants_in_flight_meals"}, $avg: {"$flight_duration"}] } }
    }
  }
]);


//Q7 
db.airlines_reviews.aggregate([
    {
        $addFields: {
            Period: {
                $cond: [
                    { 
                        $and: [
                            { $gte: [{ $month: { $dateFromString: { dateString: "$ReviewDate", format: "%d/%m/%Y" } } }, 6] },
                            { $lte: [{ $month: { $dateFromString: { dateString: "$ReviewDate", format: "%d/%m/%Y" } } }, 9] }]},
                    "Seasonal",
                    "Non-Seasonal" ]}}},
    {
        $group: {
            _id: { Airline: "$Airline", Class: "$Class", Period: "$Period" },
            Avg_SeatComfort: { $avg: "$SeatComfort" },
            Avg_FoodnBeverages: { $avg: "$FoodnBeverages" },
            Avg_InflightEntertainment: { $avg: "$InflightEntertainment" },
            Avg_ValueForMoney: { $avg: "$ValueForMoney" },
            Avg_OverallRating: { $avg: "$OverallRating" }}},
    {
        $project: {
            _id: 0,
            Airline: "$_id.Airline",
            Class: "$_id.Class",
            Period: "$_id.Period",
            Avg_SeatComfort: 1,
            Avg_FoodnBeverages: 1,
            Avg_InflightEntertainment: 1,
            Avg_ValueForMoney: 1,
            Avg_OverallRating: 1
        }},
    {
        $sort: { Airline: 1, Class: 1, Period: 1 }}
]);

use "airline"

// Q8
db.airlines_reviews.aggregate([
    {
        $match: {
            Verified: "TRUE",
            Recommended: "no"
        }
    },
    {
        $group: { 
            _id: {Airline: "$Airline"},
            AvgSeatComfort: {$avg: "$SeatComfort"},
            AvgStaffService: {$avg: "$StaffService"},
            AvgFoodnBeverages: {$avg: "$FoodnBeverages"},
            AvgInflightEntertainment: {$avg: "$InflightEntertainment"},
            AvgValueForMoney: {$avg: "$ValueForMoney"},
        }
    }
])

db.airlines_reviews.aggregate([
    {
        $match: {
            Verified: "TRUE",
            Recommended: "no"
        }
    },
    {
        $group: { 
            _id: {Airline: "$Airline", TypeOfTraveller: "$TypeofTraveller"},
            AvgSeatComfort: {$avg: "$SeatComfort"},
            AvgStaffService: {$avg: "$StaffService"},
            AvgFoodnBeverages: {$avg: "$FoodnBeverages"},
            AvgInflightEntertainment: {$avg: "$InflightEntertainment"},
            AvgValueForMoney: {$avg: "$ValueForMoney"},
        }
    }
])


db.airlines_reviews.aggregate([
  {
    $match: {
      Verified: "TRUE",
      Recommended: "no"
    }
  },
  {
    $group: {
      _id: "$Airline",
      allReviews: {
        $push: "$Reviews"
      }
    }
  },
  {
    $project: {
      _id: 0,
      Airline: "$_id",
      ConcatenatedReviews: {
        $reduce: {
          input: "$allReviews",
          initialValue: "",
          in: { $concat: ["$$value", " ", "$$this"] }
        }
      }
    }
  }
])

db.airlines_reviews.aggregate([
  {
    $match: {
      Verified: "TRUE",
      Recommended: "no"
    }
  },
  {
    $group: {
      _id: "$TypeofTraveller",
      allReviews: {
        $push: "$Reviews"
      }
    }
  },
  {
    $project: {
      _id: 0,
      TypeofTraveller: "$_id",
      ConcatenatedReviews: {
        $reduce: {
          input: "$allReviews",
          initialValue: "",
          in: { $concat: ["$$value", " ", "$$this"] }
        }
      }
    }
  }
])

// Q9

// Pre-Covid
db.airlines_reviews.aggregate([
    {
        $match: {Airline: 'Singapore Airlines'}
    },
    {
    $project: {
        date: {
            $split: ["$MonthFlown", "-"],
            },
        review: "$Reviews"
        }
    },
    {
    $addFields: {
        month: {$switch: {
              branches: [
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jan"] }, then: 1 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Feb"] }, then: 2 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Mar"] }, then: 3 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Apr"] }, then: 4 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "May"] }, then: 5 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jun"] }, then: 6 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jul"] }, then: 7 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Aug"] }, then: 8 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Sep"] }, then: 9 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Oct"] }, then: 10 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Nov"] }, then: 11 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Dec"] }, then: 12 }
              ],
              default: null
            }},
            year: { $toInt: { $arrayElemAt: ["$date", 1] } }
        }
    },
    {
        $match: { month : { $lte: 3 }, year : { $lt : 20 } }
    },
    {
        $group: {
            _id: null,
            allReviews: {
                $push: "$review"
              }
        }
    },
    {
        $project: {
            concatenatedReviews: { $reduce: { 
                input: "$allReviews", 
                initialValue: "", 
                in: { $concat: ["$$value", " ", "$$this"] } 
            }}
        }
    }
])

// During COVID
db.airlines_reviews.aggregate([
    {
        $match: {Airline: 'Singapore Airlines'}
    },
    {
    $project: {
        date: {
            $split: ["$MonthFlown", "-"],
            },
        review: "$Reviews"
        }
    },
    {
    $addFields: {
        month: {$switch: {
              branches: [
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jan"] }, then: 1 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Feb"] }, then: 2 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Mar"] }, then: 3 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Apr"] }, then: 4 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "May"] }, then: 5 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jun"] }, then: 6 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jul"] }, then: 7 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Aug"] }, then: 8 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Sep"] }, then: 9 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Oct"] }, then: 10 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Nov"] }, then: 11 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Dec"] }, then: 12 }
              ],
              default: null
            }},
            year: { $toInt: { $arrayElemAt: ["$date", 1] } }
        }
    },
    {
        $match: { month : { $lt: 5 , $gte: 3}, year : { $gte : 20 , $lt: 23} }
    },
    {
        $group: {
            _id: null,
            allReviews: {
                $push: "$review"
              }
        }
    },
    {
        $project: {
            concatenatedReviews: { $reduce: { 
                input: "$allReviews", 
                initialValue: "", 
                in: { $concat: ["$$value", " ", "$$this"] } 
            }}
        }
    }
])

// Post COVID
db.airlines_reviews.aggregate([
    {
        $match: {Airline: 'Singapore Airlines'}
    },
    {
    $project: {
        date: {
            $split: ["$MonthFlown", "-"],
            },
        review: "$Reviews"
        }
    },
    {
    $addFields: {
        month: {$switch: {
              branches: [
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jan"] }, then: 1 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Feb"] }, then: 2 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Mar"] }, then: 3 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Apr"] }, then: 4 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "May"] }, then: 5 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jun"] }, then: 6 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Jul"] }, then: 7 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Aug"] }, then: 8 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Sep"] }, then: 9 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Oct"] }, then: 10 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Nov"] }, then: 11 },
                { case: { $eq: [{$arrayElemAt: ["$date", 0]}, "Dec"] }, then: 12 }
              ],
              default: null
            }},
            year: { $toInt: { $arrayElemAt: ["$date", 1] } }
        }
    },
    {
        $match: { month : { $gte: 5 }, year : { $gte : 23 } }
    },
    {
        $group: {
            _id: null,
            allReviews: {
                $push: "$review"
              }
        }
    },
    {
        $project: {
            concatenatedReviews: { $reduce: { 
                input: "$allReviews", 
                initialValue: "", 
                in: { $concat: ["$$value", " ", "$$this"] } 
            }}
        }
    }
])


//Q10 Can be changed to customer_support, switching "Reviews" to "instruction" and removing Name
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
