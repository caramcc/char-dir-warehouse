class SessionsController < ApplicationController

  def new
    if session[:user_id]
      puts session[:user_id]
      redirect_to '/'
    end
  end

  def create
    user = User.find_by_email_or_username(params[:email_or_username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end