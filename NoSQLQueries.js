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
                category: {  $in: ["ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION"] },
                flags: {$regex: /[QW]/}
            }
        }
        {
        $group: {
            _id: "$category",
            Colloquial: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /Q/ } }, 1, 0] } },
            Offensive: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /W/ } }, 1, 0] } },
            Both: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /(?=.*Q)(?=.*W)/ } }, 1, 0] } },
            Other: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /(?=.*Q)(?=.*W)/ } }, 0, 1] } },
            }
        }
])
