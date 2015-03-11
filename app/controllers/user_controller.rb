class UserController < ApplicationController

  def index
    render :json => User.all
  end

  def show(user_id)
    render :json => User.find_by_id(user_id)
  end

  def new
  end

  def edit
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      puts user
      redirect_to '/users#show'
    else
      redirect_to '/signup'
    end
  end

  def update
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :password_confirmation)
  end

end
