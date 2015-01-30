class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def index
    redirect_to transactions_path
  end

  protected

  # def authenticate
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == "ichthys" && password == "testpasswort"
  #   end if Rails.env == "production"
  # end
end
