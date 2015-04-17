class ApiController < ApplicationController

  before_filter :authorize, :except => [:search_suggest, :all_active_characters]

  def character_get_all
    render json: Character.all, status: 200
  end

  def character_get_by_id
    render json: Character.find_by_id(params[:id]), status: 200
  end

  def all_active_characters
    active_chars = Character.all.select { |char| char.is_active? && char.char_approved }
    # acceptable params: district, special
    unless params[:area].blank?
      areas = params[:area].split(',')
      active_chars.select! { |char| areas.include? char.home_area }
    end

    unless params[:special].blank?
      specials = params[:special].split(',').map { |s| s.capitalize }
      active_chars.select! { |char| specials.include? char.special }
    end

    render json: active_chars, status: 200
  end

  def character_find
    params[:ao] == 'or' ? ao = 'or' : ao = 'and'
    #TODO: Move this to config file?
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
          query = "#{accepted_params[key][:field]} #{accepted_params[key][:operator]} '#{params[key]}'"
        else
          query = "#{query} #{ao} #{accepted_params[key][:field]} #{accepted_params[key][:operator]} '#{params[key]}'"
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

  def user_get_all
    excluded_fields = [:password_digest]
    # uncomment
    # excluded_fields = [:password_digest, :email_token, password_reset_token, password_reset_token_expiry]

    unless current_user.group == 'ADMIN'
      excluded_fields.push :email
    end


    render json: User.all, except: excluded_fields, status: 200
  end

  def user_get_by_id

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

  def user_find
    # acceptable params:
    # joined_before
    # joined_after
    # chars_gt - not supported
    # chars_lt - not supported
    # group
    # ao => 'and/or' (default and)
    params[:ao] == 'or' ? ao = 'or' : ao = 'and'
    # TODO: move to config?
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
          query = "#{accepted_params[key][:field]} #{accepted_params[key][:operator]} '#{params[key]}'"
        else
          query = "#{query} #{ao} #{accepted_params[key][:field]} #{accepted_params[key][:operator]} '#{params[key]}'"
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

    excluded_fields = [:password_digest]
    # uncomment
    # excluded_fields = [:password_digest, :email_token, password_reset_token, password_reset_token_expiry]

    unless current_user.group == 'ADMIN'
      excluded_fields.push :email
    end


    render json: user, except: excluded_fields, status: 200
  end

  def generic_find_by_name

    name = params[:name]
    if name.split(' ').length == 2
      query = Character.where("first_name LIKE '%#{name.split(' ')[0]}%' AND last_name LIKE '%#{name.split(' ')[2]}%'")
    else
      query = Character.where("first_name LIKE '%#{name}%' OR last_name LIKE '%#{name}%'")
    end

    user_query = User.where("username LIKE '%#{name}%' OR display_name LIKE '%#{name}%'")

    user_results = []
    # TODO get user characters?
    user_query.each do |res|
      result = res.attributes
      result.delete 'password_digest'
      result.delete 'email'
      user_results.push result
    end

    results = {
        :characters => query.to_a,
        :users => user_results
    }


    render json: results, status: 200
  end

  def logs
    if current_user.group == 'ADMIN'
      log = ''
      File.open(Rails.root.join("log/#{Rails.env}.log"), 'r').each_line { |line| log << line; log << "<br>\n"; }
      render text: log
    else
      render status: :unauthorized
    end
  end

  def search_suggest
    data = [] # array of hash, keys = name, type
    Character.all.each do |char|
      h = { name: "#{char.first_name} #{char.last_name}", type: "Character - #{Character.pretty_area(char.home_area)} #{char.gender} #{char.special}"}
      data.push h
    end

    User.all.each do |user|
      h = { name: user.username, type: 'User'}
      h2 = { name: user.display_name, type: 'User'}
      data.push h
      data.push h2
    end

    render json: data, status: 200
  end

  def tessera
    render json: Tessera.all, status: 200
  end

end
