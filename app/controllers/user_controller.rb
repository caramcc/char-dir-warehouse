class UserController < ApplicationController

  def index
    render :json => User.all
  end

  def show
    user = User.find_by_id(params[:id])
    render :json => user
  end

  def show_characters
    user = User.find_by_id(params[:id])
    render :json => user.characters
  end

  def new
    if session[:user_id]
      puts session[:user_id]
      redirect_to '/'
    end
  end

  def edit
    user = User.find_by_id(params[:id])
    if user.can_edit?
      # TODO: edit controller
      true
    else
      render :status => :unauthorized
    end
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
