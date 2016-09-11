# This controls the admin interface to edit all users
class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    @users = User.list
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if current_user.admin?
      @user.skip_confirmation!
      @user.skip_reconfirmation!
    end
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
      params.require(:user).permit(:email, :role, :first_name, :last_name)
    end
end
