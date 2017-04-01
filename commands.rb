Transaction.all.group_by {|t| t.items.map {|i| [i.price.to_f, i.seller_id]}.sort}.reject {|i,t| t.size == 1}.each {|i,ts| ts.each {|t| p t}; puts}; 0
