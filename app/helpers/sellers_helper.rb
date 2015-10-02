module SellersHelper
  def revenues_csv sellers
    CSV.generate(col_sep: ";") do |csv|
      sellers.each do |seller|
        if seller.total_revenue > 0
          csv << [ seller.code,
                   seller.name,
                   money_string(seller.total_revenue),
                   "#{seller.computed_rate_in_percent}%",
                   money_string(seller.total_payout) ]
        end
      end
    end
  end

  def inconsistency_class seller, only_if_relevant
    ( !only_if_relevant || seller.total_revenue > 0 ) &&
    ( ( seller.computed_rate > seller.rate && 'less_activities' ) ||
      ( seller.computed_rate < seller.rate && 'more_activities' ) )
  end
end
