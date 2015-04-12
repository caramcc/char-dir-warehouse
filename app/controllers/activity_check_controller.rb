class ActivityCheckController < ApplicationController

  def create
    unless current_user.reaping_checks?
      render :status => :unauthorized
    end

    ac = ActivityCheck.new(activity_check_params)

    ac.games ||= ActivityCheck.last.games + 1

    if ac.opens_on.nil?
      ac.opens_on.to_time
    else
      ac.opens_on = Time.now
    end

    if ac.closes_on.nil?
      ac.closes_on.to_time
    else
      ac.closes_on = 30.days.from_now
    end

    if ac.can_open_new? && ac.save
      redirect_to "/checks/activity/#{ac.games}"
    else
      redirect_to '/checks/activity'
    end
  end

  def index
    @checks = ActivityCheck.order(:games => :desc)
  end

  def checks
    @checks = {
        activity: ActivityCheck.last,
        reaping: ReapingCheck.last
    }
  end

  def show

  end

  def add_characters
    @check = ActivityCheck.find_by_games(params[:games])
    @user = User.find_by_id(params[:user_id])
    unless current_user.can_edit?(@user)
      render :status => :unauthorized
    end
    @characters = @user.characters
  end

  def add
    @check = ActivityCheck.find_by_games(params[:games])
    user = User.find_by_id(params[:user_id])
    if params[:chk]
      removed = []
      user.characters.each do |chr|
        unless params[:chk].include?(chr) && chr.activity_checks.exists?(@check)
          removed.push chr
        end
      end

      removed.each do |del|
        del.activity_checks.delete(@check)
        del.save
      end

      params[:chk].each do |id|
        char = Character.find_by_id(id)

        unless char.activity_checks.exists?(@check)
          char.activity_checks << @check
        end
        char.save
      end

    else
      user.characters.each do |chr|
        chr.activity_checks.delete(@check)
        chr.save
      end
    end
    redirect_to "/checks/activity/#{@check.games}"
  end

  def show_by_games
    @check = ActivityCheck.find_by_games(params[:games])
    # render json: @check.characters
  end

  def update
  end

  def close
  end

  private
  def activity_check_params
    params.require(:activity_check).permit(:opens_on, :closes_on, :games)
  end
end
