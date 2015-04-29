class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_action :get_or_create_client_key


  private

  def get_or_create_client_key
    @client_key = cookies.permanent.signed[:client_key]
    unless @client_key
      @client_key = cookies.permanent.signed[:client_key] = Digest::SHA1.hexdigest([request.remote_ip, request.user_agent, rand].to_s)[0..3]
    end
  end
end
