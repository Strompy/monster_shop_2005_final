class UsersController < ApplicationController
  def new
     @user ||= Hash.new("")
  end

  def create
    user = User.create(user_params)
    if user.save
      flash[:success] = "Welcome to the black market #{user.name}"
      session[:user_id] = user.id
      redirect_to "/profile"
    else
      @user = user_params
      flash[:error] = user.errors.full_messages
      render :new
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
