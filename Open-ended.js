use "airline"

// Q8
db.airlineReviews.aggregate([
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

db.airlineReviews.aggregate([
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


db.airlineReviews.aggregate([
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

db.airlineReviews.aggregate([
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
db.airlineReviews.aggregate([
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
db.airlineReviews.aggregate([
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
db.airlineReviews.aggregate([
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
