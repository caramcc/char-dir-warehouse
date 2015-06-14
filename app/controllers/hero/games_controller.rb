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
      @games = Games.find_by_number(params[:games])
    end

    def add_gm
      unless current_user.open_games?
        render :status => :unauthorized
      end
      @staff = User.where.not(:group => 'MEMBER')
      @games = Games.find_by_number(params[:games])
    end

    def add_mutt
      games = Games.find_by_number(params[:games])
      unless current_user.is_gm_for?(games.number)
        render :status => :unauthorized
      end

    end

    def create_mutt

    end

    def update_gm
      games = Games.find_by_number(params[:games])

      user = User.find_by_id(params[:gm_id])

      user.games_id = games.id

      games.gamemakers <<  user

      user.save
      games.save

      redirect_to "/hero/games/#{games.number}"
    end


    def add_tribute
      @games = Games.find_by_number(params[:games])
      @reapable = Warehouse::Character.reapable
      @tributes = Warehouse::Character.tributes(@games.number)
    end

    def update_tributes
      games = Games.where(active: true).last

      tributes = params[:char_ids]
      tributes ||= []
      prev = params[:previous]
      prev ||= []
      removed = prev.reject {|x| tributes.include? x}

      removed.each do |char_id|
        extrib_char = Warehouse::Character.find_by_id(char_id)

        extrib_char.update(is_tribute: false, games_number: nil)
        extrib = Tribute.find_by_character_id(char_id)

        games.tributes.delete extrib
        extrib.destroy
        extrib_char.save!
      end

      tributes.each do |char_id|
        t_char = Warehouse::Character.find_by_id(char_id)
        unless t_char.is_tribute && t_char.games_number == games.number
          t_char.is_tribute = true
          t_char.games_number = games.number

          tribute = Tribute.new_tribute_from_character(t_char)

          games.tributes << tribute
          tribute.games_id = games.id

          tribute.save
          t_char.save
        end
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
