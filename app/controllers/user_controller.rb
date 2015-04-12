class UserController < ApplicationController

  def index
    @users = []
    User.order(:username).each do |user|
      unless user.nil?
        @users.push user
      end
    end
    # render :json => User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    @viewing = User.find_by_id(session[:user_id])
    @viewing ||= User.new

    @latest_checks = {}
    rc = ReapingCheck.last
    ac = ActivityCheck.last
    if rc.nil?
      @latest_checks[:reaping] = {
          active: false
      }
    else
      if rc.is_active?
        @latest_checks[:reaping] = {
            active: true,
            games: rc.games
        }
      else
        @latest_checks[:reaping] = {
            active: false
        }
      end
    end

    if ac.nil?
      @latest_checks[:activity] = {
          active: false
      }
    else
      if ac.is_active?
        @latest_checks[:activity] = {
            active: true,
            games: ac.games
        }
      else
        @latest_checks[:activity] = {
            active: false
        }
      end
    end

  end

  def show_characters
    user = User.find_by_id(params[:id])
    render :json => user.characters
  end

  def characters
    @user = User.find_by_id(params[:id])
    # @user.characters.each do |char|
    #   puts char.char_approved
    #   puts char.first_name
    # end
  end

  def new
    if session[:user_id]
      puts session[:user_id]
      redirect_to '/'
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    unless current_user.can_edit?(@user)
      render :status => :unauthorized
    end
  end

  def create
    user = User.new(user_params)

    user.group = 'MEMBER'

    if user.save
      session[:user_id] = user.id
      redirect_to '/users#show'
    else
      redirect_to '/signup'
    end
  end

  def update
    old_user = User.find_by_id(params[:user][:id])

    params[:user].each do |key, value|
      if old_user.respond_to?(key)
        old_user[key] = value
      end
    end

    old_user.save

    redirect_to "/user/#{old_user.id}"
  end

  def destroy
  end

  # API Routes



  private
  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :password_confirmation)
  end

end
