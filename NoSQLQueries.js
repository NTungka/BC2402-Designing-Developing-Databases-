// Q1
db.customerSupport.aggregate(
    [
        { 
            $match: { 
                category: { 
                    $in: ["ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION"] 
                } 
            } 
        },
        {
            $group: {
                _id: {category: "$category"}, 
                count: { $count: { } }
            }
        }
    }
])

// Q2
db.customerSupport.aggregate(
    [
        { 
            $match: { 
                category: {  $in: ["ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION"] }
            }
        },
        {
        $group: {
            _id: "$category",
            Colloquial: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /Q/ } }, 1, 0] } },
            Offensive: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /W/ } }, 1, 0] } },
            Both: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /(?=.*Q)(?=.*W)/ } }, 1, 0] } },
            Other: { $sum: { $cond: [{ $and: [ { $not: [{ $regexMatch: { input: "$flags", regex: /Q/ } }] }, { $not: [{ $regexMatch: { input: "$flags", regex: /W/ } }] } ] }, 1, 0] } }
            }
        }
])

// Q3
db.flightDelay.aggregate(
    [
        {
            $match: {Cancelled: 1, ArrDelay : {$gt : 0}, DepDelay : {$gt : 0}} 
        },
        {
            $group: { _id: {airline: "$Airline"}}
        }
])

// Q4
db.flightDelay.aggregate([
    {
        $match: {$or: [{ArrDelay : {$gt: 0}}, {DepDelay : {$gt: 0}}]}
    },
    {
        $project: {
            Year: { $year: { $dateFromString: { dateString: "$Date", format: "%d-%m-%Y" } } },
            Month: { $month: { $dateFromString: { dateString: "$Date", format: "%d-%m-%Y" } } },
            Route: {$concat: ["$Origin", "-", "$Dest"]}
        }
    },
    {
    $group: {
        _id : {Month: "$Month", Route: "$Route"},
        DelayCount: { $sum: 1 }
        }
    },
    {
    $group: {
        _id : {Month: "$_id.Month"},
        MaxDelayCount: { $max: "$DelayCount" },
        Routes : {$push: {Route: "$_id.Route", DelayCount: "$DelayCount"}}
        }
    },
    { $unwind: "$Routes" },
    { $match: { $expr: { $eq: ["$Routes.DelayCount", "$MaxDelayCount"] } } }
])
