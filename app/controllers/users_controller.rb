# This controls the admin interface to edit all users
class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    @users = User.order("seller_number, created_at")
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    @user.skip_confirmation!
    if @user.update(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :role, :first_name, :last_name, :seller_model, :seller_number, :initials)
    end
end
