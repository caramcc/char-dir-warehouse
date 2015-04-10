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
    @checks = ReapingCheck.order(:games => :desc)
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
  end

  def add
    @logged_in_user = User.find_by_id(session[:user_id])
    @check = ReapingCheck.find_by_games(params[:games])
    user = User.find_by_id(params[:user_id])
    if params[:chk]
      if params[:chk].length <= user.reaping_tickets

        removed = []
        user.characters.each do |chr|
          unless params[:chk].include?(chr) && chr.reaping_checks.exists?(@check)
            removed.push chr
          end
        end

        removed.each do |del|
          del.reaping_checks.delete(@check)
          del.save
        end

        params[:chk].each do |id|
          char = Character.find_by_id(id)

          unless char.reaping_checks.exists?(@check)
            char.reaping_checks << @check
          end
          char.save
        end

        redirect_to "/checks/reaping/#{@check.games}"
      else
        render :file => 'public/403.html', status: :unauthorized
      end
    else
      user.characters.each do |chr|
        chr.reaping_checks.delete(@check)
        chr.save
      end
        redirect_to "/checks/reaping/#{@check.games}"
    end
  end

  def show_by_games
    @check = ReapingCheck.find_by_games(params[:games])
    # render json: @check.characters
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