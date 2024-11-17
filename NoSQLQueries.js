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
