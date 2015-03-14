class CharacterController < ApplicationController

  before_filter :authorize

  def index

  end

  def show

    @char = Character.find_by_id(params[:id])
    #
    # unless @char.char_approved
    #
    # end
    #
    # render :json => @char
  end

  def new
    unless session[:user_id]
      redirect_to '/login'
    end
  end

  def edit

  end

  def create
    character = Character.new(character_params)

    character.user_id = session[:user_id]
    character.char_approved, character.fc_approved = false, false

    if character.save
      redirect_to "/character/show/#{character.id}"
    else
      redirect_to '/signup'
    end
  end

  def update

  end

  def destroy

  end

  def approve

  end

  private
  def character_params
    params.require(:character).permit(:first_name, :last_name, :bio_thread, :age, :home_area, :gender,
                                                :fc_first, :fc_last)
  end

end
