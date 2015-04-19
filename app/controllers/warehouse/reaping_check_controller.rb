module Warehouse
  class ReapingCheckController < ApplicationController


    def create
      unless current_user.reaping_checks?
        render :status => :unauthorized
      end

      check_params = reaping_check_params
      check_params[:opens_on] = Date.strptime(check_params[:opens_on], '%m/%d/%Y %I:%M %p')
      check_params[:closes_on] = Date.strptime(check_params[:closes_on], '%m/%d/%Y %I:%M %p')

      rc = ReapingCheck.new(check_params)

      rc.games ||= ReapingCheck.last.games + 1

      if rc.opens_on.nil?
        rc.opens_on.to_time
      else
        rc.opens_on = Time.now
      end

      if rc.closes_on.nil?
        rc.closes_on.to_time
      else
        rc.closes_on = 30.days.from_now
      end

      if rc.can_open_new? && rc.save
        redirect_to "/checks/reaping/#{rc.games}"
      else
        redirect_to '/checks/reaping'
      end
    end

    def index
      @checks = ReapingCheck.order(:games => :desc)
    end

    def show

    end

    def add_characters
      @check = ReapingCheck.find_by_games(params[:games])
      @user = User.find_by_id(params[:user_id])
      unless current_user.can_edit?(@user)
        render :status => :unauthorized
      end
      @characters = @user.characters
    end

    def add
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
      tessera = Tessera.where(reaping_check_id: @check.id)
      @tessera = {}
      tessera.each do |t|
        @tessera[t.character_id] = t.attributes
      end
      puts @tessera
    end

    def update

    end

    def close

    end

    def all_tessera
      if current_user.can_approve?
        @check = ReapingCheck.find_by_games(params[:games])
        tessera = Tessera.where(reaping_check_id: @check.id)
        @tessera = {}
        tessera.each do |t|
          @tessera[t.character_id] = t.attributes
        end
      else
        render status: :unauthorized
      end
    end

    def update_all_tessera
      if current_user.can_approve?
        params[:tessera].each do |id|
          tess = Tessera.find_by_id(id)
          tess.approved = true
          tess.save
        end
        redirect_to "/checks/reaping/#{params[:games]}/tessera"
      else
        render status: :unauthorized
      end
    end

    private
    def reaping_check_params
      params.require(:reaping_check).permit(:opens_on, :closes_on, :games)
    end

  end
end