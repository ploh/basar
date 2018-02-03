module SellersHelper
  def revenues_csv sellers
    CSV.generate(col_sep: ";") do |csv|
      sellers.each do |seller|
        if seller.total_revenue > 0
          csv << [ seller.code,
                   seller.name,
                   money_string(seller.total_revenue),
                   "#{seller.final_rate_in_percent}%",
                   money_string(seller.total_payout) ]
        end
      end
    end
  end

  def list_csv sellers
    CSV.generate(col_sep: ";") do |csv|
      sellers.each do |seller|
        csv << [ seller.code,
                 seller.name,
                 seller.model ]
      end
    end
  end

  def inconsistency_class seller
    if seller.computed_rate > seller.rate
      'less_activities'
    elsif seller.computed_rate < seller.rate
      'more_activities'
    end
  end

  def nothing_sold_class seller
    if seller.total_revenue == 0
      'nothing_sold'
    end
  end

  def models_with_descriptions models = Seller.models.keys
    models.map do |model|
      model_id = Seller.models[model]
      [Seller.model_descriptions[model], model_id]
    end.to_h
  end
end
