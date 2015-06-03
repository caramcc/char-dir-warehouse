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

    def update

    end

    def destroy

    end


    private
    def games_params
      params.require(:games).permit(:number)
    end

  end
end
