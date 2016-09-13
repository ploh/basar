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

  def models_with_descriptions
    descriptions =
      { 'A' => [20, "keine Mithilfe"],
        'C' => [10, "4 Std. Aufbauhilfe ODER 2 Std. Aufbauhilfe und ein Kuchen"],
        'D' => [10, "ca. 3 Std. Abbauhilfe"] }

    result = {}
    result[nil] = ""
    Seller.models.each do |model, model_id|
      description = descriptions[model]
      if description
        rate_percentage, help_text = description
        text = "#{model}, #{rate_percentage}% Kommission, #{help_text}"
        result[text] = model_id
      end
    end
    result
  end
end
