module ApplicationHelper
  def money_string(amount)
    sprintf("%1.2f EUR", amount).gsub(".", ",")
  end

  def t_main key, *args
     I18n.t "#{params[:controller].gsub('/', '.')}.#{params[:action]}.#{key}", *args
  end
end
