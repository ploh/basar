# Find duplicate transactions - probably erroneously entered twice
Transaction.all.group_by {|t| t.items.map {|i| [i.price.to_f, i.seller_id]}.sort}.reject {|i,t| t.size == 1}.each {|i,ts| ts.each {|t| p t}; puts}; 0

# List sellers by decreasing revenue
puts Seller.all.sort_by {|s| -s.total_revenue}.first(50).map {|s| sprintf "%6s  %6.2f  %s", s.code, s.total_revenue, s.name}.join("\n"); 0

# Delete all transactions and sellers - good after loading a backup in the application phase
Transaction.all.each {|t| t.destroy}
Seller.all.each {|s| s.destroy}
