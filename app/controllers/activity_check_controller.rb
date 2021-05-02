class ActivityCheckController < ApplicationController

  def create
    unless current_user.reaping_checks?
      render :status => :unauthorized
    end

    check_params = activity_check_params
    check_params[:opens_on] = Date.strptime(check_params[:opens_on], '%m/%d/%Y %I:%M %p')
    check_params[:closes_on] = Date.strptime(check_params[:closes_on], '%m/%d/%Y %I:%M %p')

    ac = ActivityCheck.new(check_params)

    ac.games ||= ActivityCheck.last.games + 1

    unless ac.opens_on.nil?
      ac.opens_on.to_time
    else
      ac.opens_on = Time.now
    end

    unless ac.closes_on.nil?
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
    ac = ActivityCheck.last
    ac ||= ActivityCheck.new
    rc = ReapingCheck.last
    rc ||= ReapingCheck.new

    @checks = {
        activity: ac,
        reaping: rc
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
    
    unless current_user.can_edit?(user)
      render :status => :unauthorized
    end

    if params[:chk]
      removed = []
      user.characters.each do |chr|
        unless params[:chk].include?(chr) && chr.activity_checks.exists?(@check.id)
          removed.push chr
        end
      end

      removed.each do |del|
        del.activity_checks.delete(@check)
        del.save
      end

      params[:chk].each do |id|
        char = Character.find_by_id(id)

        unless char.activity_checks.exists?(@check.id)
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
    @characters = @check.characters.preload(:user)
    active_user_ids = @characters.pluck('distinct user_id')
    @users = User.find(active_user_ids)
    prev_check_id = @check.id > 1 ? @check.id - 1 : 1

    previous_check_user_ids = ActiveRecord::Base.connection.execute("SELECT distinct user_id FROM characters
          INNER JOIN activity_checks_characters ON characters.id = activity_checks_characters.character_id
          WHERE activity_checks_characters.activity_check_id = #{prev_check_id}").map {|r| r['user_id'].to_i}

    @lapsed_users = User.find(previous_check_user_ids - active_user_ids)
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
