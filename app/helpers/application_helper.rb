module ApplicationHelper
  def money_string(amount)
    sprintf("%1.2f EUR", amount).gsub(".", ",")
  end
end
