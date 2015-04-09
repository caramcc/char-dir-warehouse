class ReapingChecksController < ApplicationController


  def create
    @logged_in_user = User.find_by_id(session[:user_id])
    unless @logged_in_user.reaping_checks?
      render :status => :unauthorized
    end

    rc = ReapingCheck.new(reaping_check_params)

    if rc.can_open_new? && rc.save
      redirect_to "/checks/reaping/#{rc.games}"
    else
      render :status => :unauthorized
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
