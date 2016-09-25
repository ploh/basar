# This controls the admin interface to edit all users
class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    @users = User.list
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # POST /users
  def create
    @user = User.new(user_params)
    @user.password = generated_password = Devise.friendly_token
    p @user

    if @user.save
      redirect_to users_url, notice: 'User was successfully created.'
    else
      render :new
    end
    p @user
  end


  # PATCH/PUT /users/1
  def update
    @user.skip_confirmation!
    @user.skip_reconfirmation!

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
    params.require(:user).permit(:email, :role, :first_name, :last_name, :old_initials, :old_number, :remark, :wish_a, :wish_b, :wish_c, :weighting, :cake, :help)
  end
end
