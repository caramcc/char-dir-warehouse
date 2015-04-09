class ReapingChecksController < ApplicationController


  def create
    @logged_in_user = User.find_by_id(session[:user_id])
    unless @logged_in_user.reaping_checks?
      render :status => :unauthorized
    end

    rc = ReapingCheck.new(reaping_check_params)

    if rc.games.nil?
      rc.games = ReapingCheck.last.games + 1
    end

    rc.opens_on ||= Time.now
    rc.closes_on ||= 30.days.from_now

    if rc.can_open_new? && rc.save
      redirect_to "/checks/reaping/#{rc.games}"
    else
      redirect_to '/checks/reaping'
    end
  end

  def index
    @checks = ReapingCheck.all
    @checks.each do |check|
      check.characters
    end
  end

  def show

  end

  def add_characters
    @logged_in_user = User.find_by_id(session[:user_id])
    @check = ReapingCheck.find_by_games(params[:games])
    @user = User.find_by_id(params[:user_id])
    unless @logged_in_user.can_edit?(@user)
      render :status => :unauthorized
    end
    @characters = @user.characters

    # render json: @characters

  end

  def show_by_games
    @check = ReapingCheck.find_by_games(params[:games])
  end

  def update

  end

  def close

  end

  private
  def reaping_check_params
    params.require(:reaping_checks).permit(:opens_on, :closes_on, :games)
  end

end
