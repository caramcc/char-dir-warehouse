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
    Character.order(:fc_last, :fc_first).each do |char|
      char.fc_last.nil? ? char.fc_last = '' : fc_last = char.fc_last

      char_data = {
          fc_first: char.fc_first,
          fc_last: char.fc_last.upcase,
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

  def fc_list
    @fcs = {}
    @no_fcs = []
    Character.order(:fc_last, :fc_first).each do |char|

      if char.fc_approved
        char.fc_last.blank? ? fc_last = ' ' : fc_last = char.fc_last.upcase
        char_data = {
            fc_first: char.fc_first,
            fc_last: fc_last,
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

        if fc_last.blank? && char.fc_first.blank?
          @no_fcs.push char_data
        else

          if @fcs.include? fc_last[0]
            @fcs[fc_last[0]].push char_data
          else
            @fcs[fc_last[0]] = [char_data]
          end

        end
      end

    end
  end


  def show_one

    @char = Character.joins(:user).find_by(id: params[:id])
    user_display_name = User.find_by_id(@char.user_id).display_name
    @latest_checks = {}
    rc = ReapingCheck.last
    ac = ActivityCheck.last
    rc ||= ReapingCheck.new
    ac ||= ActivityCheck.new

    if rc.is_active?
      @latest_checks[:reaping] = {
          active: true,
          char_in: @char.reaping_checks.exists?(rc),
          games: rc.games
      }
    else
      @latest_checks[:reaping] = {
          active: false
      }
    end

    if ac.is_active?
      @latest_checks[:activity] = {
          active: true,
          char_in: @char.activity_checks.exists?(ac),
          games: ac.games
      }
    else
      @latest_checks[:activity] = {
          active: false
      }
    end

    @latest_checks[:udn] = user_display_name

  end

  def new
    unless session[:user_id]
      redirect_to '/login'
    end
  end

  def edit
    @char = Character.find_by_id(params[:id])
    if current_user.can_edit?(@char)
      @user = User.find_by_id(@char.user_id)
    else
      render file: 'public/403.html', status: :forbidden
    end

  end

  def create
    character = Character.new(character_params)

    character.user_id = session[:user_id]
    character.char_approved = false

    if character.fc_first.blank? && character.fc_last.blank?
      character.fc_approved = true
    else
      character.fc_approved = false
    end


    if character.save
      redirect_to "/character/#{character.id}"
    else
      redirect_to '/signup'
    end
  end

  def update
    old_char = Character.find_by_id(params[:character][:id])
    fc_changed = old_char.fc_first != params[:character][:fc_first] || old_char.fc_last != params[:character][:fc_last]

    if old_char.in_reaping? && params[:character][:gender] == 'Other'
      old_char.remove_from_reaping
    end

    approve = old_char.update_tessera(params[:character][:tessera])
    if approve
      old_char.approve_tessera(params[:character][:tessera_approved])
    end

    params[:character].delete :tessera
    params[:character].delete :tessera_approved

    params[:character].each do |key, value|
      if old_char.respond_to?(key)
        unless value.blank?
          old_char[key] = value
        end
      end
    end

    if fc_changed
      old_char.fc_approved = false
      old_char.fc_first = params[:character][:fc_first]
      old_char.fc_first ||= ''
      old_char.fc_last = params[:character][:fc_last]
      old_char.fc_last ||= ''
    end

    if old_char.fc_first.blank? && old_char.fc_last.blank?
      old_char.fc_approved = true
    end

    old_char.save
    redirect_to "/character/#{old_char.id}"
  end


  def approve_all_pending
    if current_user.can_approve?
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
    if current_user.can_approve?
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
    if current_user.can_approve?
      @processed = {
          :approved => {}
      }

      unless params[:approved].nil?
        params[:approved].each do |id|
          char = Character.find_by_id(id)

          char.approve

          user = User.find_by_id(char.user_id)

          if @processed[:approved][user.display_name].nil?
            @processed[:approved][user.display_name] = [char]
          else
            @processed[:approved][user.display_name].push(char)
          end
        end
      end

      currently_flagged = Character.where(char_flagged: true)

      currently_flagged.each do |cf|
        unless params[:flagged].include? cf.id
          cf.remove_flag
        end
      end

      unless params[:flagged].nil?
        params[:flagged].each do |id|

          char = Character.find_by_id(id)
          if char.char_flagged
            char.update_flag(char.char_flag)
            next
          end

          char.add_flag(params[:flag][id])
        end
      end

    else
      render :file => 'public/403.html', status: :unauthorized
    end
  end

  def approve_fcs
    if current_user.can_approve?
      @approved = {}

      unless params[:fcs].nil?
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
      end

      currently_flagged = Character.where(fc_flagged: true)

      currently_flagged.each do |cf|
        unless params[:flagged].include? cf.id
          cf.remove_flag(true)
        end
      end

      unless params[:flagged].nil?
        params[:flagged].each do |id|

          char = Character.find_by_id(id)
          if char.fc_flagged
            char.update_flag(char.fc_flag, true)
            next
          end

          char.add_flag(params[:flag][id], true)
        end
      end

    else
      render :file => 'public/403.html', status: :unauthorized
    end
  end

  def delete
    @char = Character.find_by_id(params[:id])
    unless current_user.can_edit?(@char)
      render file: 'public/403.html', status: :forbidden
    end
  end

  def destroy
    @char = Character.find_by_id(params[:id])
    user = @char.user_id
    if current_user.can_edit?(@char) && params[:confirmation] == @char.first_name
      @char.destroy!
      redirect_to "/user/#{user}"
    else
      render file: 'public/403.html', status: :forbidden
    end
  end


  def user_tessera
    @chars = Character.find_by_user_id(params[:id])
  end


  private
  def character_params
    params.require(:character).permit(:first_name, :last_name, :bio_thread, :age, :home_area, :special, :gender,
                                                :fc_first, :fc_last)
  end

end
