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

// Text mining analysis
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
