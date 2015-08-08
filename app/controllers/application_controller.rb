class ApplicationController < ActionController::Base
  include Warehouse
  include Hero

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_games
    # TODO this will be a problem
    @current_games ||= Hero::Games.where(active: true).last
  end
  helper_method :current_games

  def games_is_active
    @games_is_active = Hero::Games.last.active
    @games_is_active ||= false
  end


  def authorize
    redirect_to '/login' unless current_user
  end

  def index
    @current_user = current_user
    @current_games = current_games
  end

end
