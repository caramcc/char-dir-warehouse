class UserController < ApplicationController

  def index
    @users = []
    User.order(:username).each do |user|
      unless user.nil?
        @users.push user
      end
    end
    # render :json => User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    @viewing = User.find_by_id(session[:user_id])
    # render :json => user
  end

  def show_characters
    user = User.find_by_id(params[:id])
    render :json => user.characters
  end

  def characters
    @user = User.find_by_id(params[:id])
    # @user.characters.each do |char|
    #   puts char.char_approved
    #   puts char.first_name
    # end
  end

  def new
    if session[:user_id]
      puts session[:user_id]
      redirect_to '/'
    end
  end

  def edit
    @logged_in_user = User.find_by_id(session[:user_id])
    @user = User.find_by_id(params[:id])
    unless @logged_in_user.can_edit?(@user)
      render :status => :unauthorized
    end
  end

  def create
    user = User.new(user_params)

    user.group = 'MEMBER'

    if user.save
      session[:user_id] = user.id
      redirect_to '/users#show'
    else
      redirect_to '/signup'
    end
  end

  def update
    old_user = User.find_by_id(params[:user][:id])

    params[:user].each do |key, value|
      if old_user.respond_to?(key)
        old_user[key] = value
      end
    end

    old_user.save

    redirect_to "/user/#{old_user.id}"
  end

  def destroy
  end

  # API Routes

  def get_all
    render json: User.all, status: 200
  end

  def get_by_id

    user = User.find_by_id(params[:id])
    user ||= User.find_by_username(params[:id])
    user ||= User.find_by_display_name(params[:id])

    if user.nil?
      render json: '{}', status: 204
    end

    chars = []
      user.characters.each do |ch|
        chars.push ch.attributes
      end
    user = user.attributes
    user['characters'] = chars
    user.delete('password_digest')

    render json: user, status: 200
  end

  def find
    # acceptable params:
    # joined_before
    # joined_after
    # chars_gt - not supported
    # chars_lt - not supported
    # group
    # ao => 'and/or' (default and)
    params[:ao] == 'or' ? ao = 'or' : ao = 'and'
    accepted_params = {
        'joined_before' => {
            operator: '>',
            field: 'created_at'
        },
        'joined_after' => {
            operator: '<',
            field: 'created_at'
        },
        # 'chars_gt' => {
        #     operator: '>',
        #     field: 'characters.length'
        # },
        # 'chars_lt' => {
        #     operator: '<',
        #     field: ''
        # },
        'group' => {
            operator: 'LIKE',
            field: 'group'
        }
    }

    query = ''
    params.each do |key, value|
      if accepted_params.has_key?(key)
        if query == ''
          query = "`#{accepted_params[key][:field]}` #{accepted_params[key][:operator]} '#{params[key]}'"
        else
          query = "#{query} #{ao} `#{accepted_params[key][:field]}` #{accepted_params[key][:operator]} '#{params[key]}'"
        end
        puts "added to query: #{query}"
      else
        puts accepted_params.has_key?(key)
        puts key
        puts value
      end
    end

    puts query
    user = User.where(query)
    # user = User.where("group" => params[:group].upcase, "created_at.to_i BEFORE" => params[:joined_since])

    render json: user, status: 200

  end


  private
  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :password_confirmation)
  end

end
