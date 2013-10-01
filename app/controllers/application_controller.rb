class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def index
    redirect_to transactions_path
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      Rails.env != "developmen" ||  username == "ichthys" && password == "testpasswort"
    end
  end
end
