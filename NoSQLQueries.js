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
                flags: {$regex: "[Q|W]"}
            } 
        },
        {
        $group: {
            _id: "$category",
            Colloquial: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /Q/ } }, 1, 0] } },
            Offensive: { $sum: { $cond: [{ $regexMatch: { input: "$flags", regex: /W/ } }, 1, 0] } } 
            }
        }
])
