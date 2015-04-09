class CharacterController < ApplicationController

  before_filter :authorize

  def index

  end

  def show
    @display_names = {}
    @chars = Character.order(:home_area)
    @chars.each do |char|
      if @display_names[char.user_id].nil?
        @display_names[char.user_id] = User.find_by_id(char.user_id).display_name
      end
    end
  end

  def fcs
    @fcs = {}
    @no_fcs = []
    Character.order(:fc_last).each do |char|

      char_data = {
          fc_first: char.fc_first,
          fc_last: char.fc_last,
          first_name: char.first_name,
          last_name: char.last_name,
          gender: char.gender,
          id: char.id,
          user_id: char.user_id,
          user_username: User.find_by_id(char.user_id).username
      }

      if char.gender.blank?
        char_data[:gender] = '????'
      end

      if char.fc_last.blank? && char.fc_first.blank?
       @no_fcs.push char_data
      else
        if char.fc_last.blank?
          char_data[:fc_last] = ' '
        end

        if @fcs.include? char.fc_last[0]
          @fcs[char.fc_last[0]].push char_data
        else
          @fcs[char.fc_last[0]] = [char_data]
        end

      end
    end
  end

  def show_one

    @char = Character.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id])

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
      redirect_to "/character/#{character.id}"
    else
      redirect_to '/signup'
    end
  end

  def update
    old_char = Character.find_by_id(params[:character][:id])
    fc_changed = old_char.fc_first != params[:character][:fc_first] || old_char.fc_last != params[:character][:fc_last]

    params[:character].each do |key, value|
      if old_char.respond_to?(key)
        old_char[key] = value
      end
    end

    if fc_changed
      old_char.fc_approved = false
    end

    old_char.save
    redirect_to "/character/#{old_char.id}"
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

  def approve_all_fcs
    if User.find_by_id(session[:user_id]).can_approve?
      chars = Character.where(fc_approved: false)
      # @pending = [{
      #                 character: character,
      #                 user: user,
      #                 fc_unique: oneof 'yes', 'no', 'su' ( 'no but same user',
      #
      #             }]
      @pending = []

      chars.each do |char|
        user = User.find_by_id(char.user_id)

        duplicates = Character.where(fc_first: char.fc_first, fc_last: char.fc_last)

        fc_unique = 'no'
        if duplicates.count > 1
          duplicates.each do |dupe|

            if dupe.nil? || dupe.blank?
              fc_unique = 'yes'
            elsif dupe.user_id == char.user_id || !dupe.fc_approved
              fc_unique = 'su'
            else
              fc_unique = 'no'
            end
          end
        else
          fc_unique = 'yes'
        end

        @pending.push({ character: char, user: user, fc_unique: fc_unique })

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

  def approve_fcs
    if User.find_by_id(session[:user_id]).can_approve?
      @approved = {}
      puts params
      params[:fcs].each do |id|
        char = Character.find_by_id(id)

        char.approve_fc

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

  # API methods

  def get_all
    render json: Character.all, status: 200
  end

  def get_by_id
    render json: Character.find_by_id(params[:id]), status: 200
  end

  def find
    params[:ao] == 'or' ? ao = 'or' : ao = 'and'
    accepted_params = {
        'created_before' => {
            operator: '>',
            field: 'created_at'
        },
        'created_after' => {
            operator: '<',
            field: 'created_at'
        },
        'last_edit_before' => {
            operator: '>',
            field: 'updated_at'
        },
        'last_edit_after' => {
            operator: '<',
            field: 'updated_at'
        },
        'first' => {
            operator: 'LIKE',
            field: 'first_name'
        },
        'last' => {
            operator: 'LIKE',
            field: 'last_name'
        },
        'area' => {
            operator: 'LIKE',
            field: 'home_area'
        },
        'fc_first' => {
            operator: 'LIKE',
            field: 'fc_first'
        },
        'fc_last' => {
            operator: 'LIKE',
            field: 'fc_last'
        },
        'approved' => {
            operator: '=',
            field: 'char_approved'
        },
        'fc_approved' => {
            operator: '=',
            field: 'fc_approved'
        },
        'gender' => {
            operator: 'LIKE',
            field: 'gender'
        },
        'age_lt' => {
            operator: '<',
            field: 'age'
        },
        'age_gt' => {
            operator: '>',
            field: 'age'
        },
        'age_lte' => {
            operator: '<=',
            field: 'age'
        },
        'age_gte' => {
            operator: '>=',
            field: 'age'
        },
        'age' => {
            operator: '=',
            field: 'age'
        },
        'special' => {
            operator: 'LIKE',
            field: 'special'
        },
        'special_not' => {
            operator: 'NOT LIKE',
            field: 'special'
        },
        'user' => {
            operator: '=',
            field: 'user_id'
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
    chr = Character.where(query)
    # user = User.where("group" => params[:group].upcase, "created_at.to_i BEFORE" => params[:joined_since])

    render json: chr, status: 200
  end

  private
  def character_params
    params.require(:character).permit(:first_name, :last_name, :bio_thread, :age, :home_area, :gender,
                                                :fc_first, :fc_last)
  end

end
