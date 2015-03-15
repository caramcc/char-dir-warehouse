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
    @char = Character.find_by_id(params[:id])
    if User.find_by_id(session[:user_id]).can_edit?(@char)
      @user = User.find_by_id(@char.user_id)
    else
      render file: 'public/403.html', status: :forbidden
    end


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
    old_char = Character.find_by_id(params[:character][:id])

    params[:character].each do |key, value|
      if old_char.respond_to?(key)
        old_char[key] = value
      end
    end
    old_char.save
    redirect_to "/character/show/#{old_char.id}"
  end

  def destroy

  end

  def approve_all_pending
    if User.find_by_id(session[:user_id]).can_approve?
      chars = Character.where('char_approved = false')
      @pending = {}
      chars.each do |char|
        user = User.find_by_id(char.user_id).display_name
        if @pending[user].nil?
          @pending[user] = [char]
        else
          @pending[user].push(char)
        end
      end
    else
      render :file => 'public/403.html', status: :forbidden
    end

  end

  def approve
    if User.find_by_id(session[:user_id]).can_approve?
      @approved = {}
      puts params
      params[:chr].each do |id|
        char = Character.find_by_id(id)

        char.approve

        user = User.find_by_id(char.user_id)

        if @approved[user.display_name].nil?
          @approved[user.display_name] = [char]
        else
          @approved[user.display_name].push(char)
        end
      end
    else
      render :file => 'public/403.html', status: :unauthorized
    end
  end

  private
  def character_params
    params.require(:character).permit(:first_name, :last_name, :bio_thread, :age, :home_area, :gender,
                                                :fc_first, :fc_last)
  end

end
