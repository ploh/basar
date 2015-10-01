module SellersHelper
  def revenues_csv sellers
    CSV.generate(col_sep: ";") do |csv|
      sellers.each do |seller|
        csv << [ seller.code, seller.total_payout ] if seller.total_payout > 0
      end
    end
  end
end
