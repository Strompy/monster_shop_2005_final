class UsersController < ApplicationController
  def new
    require "pry"; binding.pry
  end

  def create
    user = User.create(user_params)
    if user.save
      flash[:success] = "Welcome to the black market #{user.name}"
      session[:user_id] = user.id
      redirect_to "/profile"
    else
      flash[:error] = user.errors.full_messages
      redirect_to "/register"
    end
  end

  def show
    # if !session[:user_id].nil?
      @user = User.find(session[:user_id])
    # end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
