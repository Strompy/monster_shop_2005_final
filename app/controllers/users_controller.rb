class UsersController < ApplicationController
  def new

  end

  def create
    user = User.create(user_params)
    flash[:success] = "Welcome to the black market #{user.name}"
    session[:user_id] = user.id
    redirect_to "/profile"
  end

  def show
    @user = User.find(session[:user_id])
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
