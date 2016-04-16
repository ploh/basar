# This controls an individual user's administration of his own account
class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:email, :password, :password_confirmation, :old_seller_code, :first_name, :last_name, :seller_model]
  end

  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << [:email, :password, :password_confirmation, :current_password, :old_seller_code, :seller_model]
  end

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete :current_password
      resource.update_without_password(params)
    else
      super
    end
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
