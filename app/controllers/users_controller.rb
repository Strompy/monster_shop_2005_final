class UsersController < ApplicationController
  def new
     @user_input ||= Hash.new("")
  end

  def create
    user = User.create(user_params)
    if user.save
      flash[:success] = "Welcome to the black market #{user.name}"
      session[:user_id] = user.id
      redirect_to "/profile"
    else
      @user_input = user_params
      flash[:error] = user.errors.full_messages
      render :new
    end
  end

  def show
    if session[:user_id].nil?
      render file: "/public/404"
    else
      @user = User.find(session[:user_id])
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def edit_password
    @user = User.find(session[:user_id])
  end

  def update
    user = User.find(session[:user_id])
    user.update(user_params)
    flash[:success] = "Your data has been updated!"
    redirect_to "/profile"
  end

  def update_password
    user = User.find(session[:user_id])
    user.update(user_params)
    flash[:success] = "Your password has been updated!"
    redirect_to "/profile"
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

  def change_password(password)

  end
end
