module Hero
  class GamesController < ApplicationController

    def create

      unless current_user.open_games?
        render :status => :unauthorized
      end

      games = Games.new(games_params)

      Games.all.each do |g|
        g.active = false
        g.save!
      end

      games.active = true
      games.number ||= Games.last.number + 1

      if games.save
        redirect_to "/hero/games/#{games.number}"
      else
        redirect_to '/hero/games'
      end


    end

    def new
      unless current_user.open_games?
        render :status => :unauthorized
      end
    end

    def info
      @games = Games.find_by_number(params[:number])

    end

    def add_gm
      unless current_user.open_games?
        render :status => :unauthorized
      end
      @staff = User.where.not(:group => 'MEMBER')
      @games = Games.where(active: true).last
    end

    def update_gm
      games = Games.find_by_id(params[:id])

      user = User.find_by_id(params[:gm_id])

      user.games_id = games.id

      games.gamemakers <<  user

      user.save
      games.save

      redirect_to "/hero/games/#{games.number}"
    end


    def add_tribute
      @games = Games.where(active: true).last
      @reapable = Warehouse::Character.reapable
      @tributes = Warehouse::Character.tributes(@games.number)
    end

    def update_tribute
      games = Games.where(active: true).last

      tributes = params[:char_ids]
      removed = params[:previous].reject {|x| tributes.include? x}

      removed.each do |char_id|
        extrib = Warehouse::Character.find_by_id(char_id)

        extrib.update(is_tribute: false, games_number: nil)

        games.tributes.delete extrib
        extrib.save!
      end

      tributes.each do |char_id|
        tribute = Warehouse::Character.find_by_id(char_id)
        tribute.is_tribute = true
        tribute.games_number = games.number
        games.tributes << tribute

        tribute.save
      end

      games.save

      redirect_to "/hero/games/#{games.number}"
    end

    def destroy

    end


    private
    def games_params
      params.require(:games).permit(:number)
    end

  end
end
