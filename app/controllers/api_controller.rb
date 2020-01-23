class ApiController < ApplicationController

  before_filter :authorize, :except => [:search_suggest, :all_active_characters, :slack_attack]

  def character_get_all
    render json: Character.all, status: 200
  end

  def character_get_by_id
    render json: Character.find_by_id(params[:id]), status: 200
  end

  def all_active_characters
    headers['Last-Modified'] = Time.now.httpdate
    active_chars = Character.all.select { |char| char.is_active? && char.char_approved }
    # acceptable params: district, special
    unless params[:area].blank?
      areas = params[:area].split(',')
      active_chars.select! { |char| areas.include? char.home_area.downcase }
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

  def reaping_list
    output = ''
    rc = ReapingCheck.last
    possibles = rc.characters.preload(:user)
    tessera_set = Tessera.where("reaping_check_id = #{rc.id} AND approved = true")
    possibles.each do |possible|
      tessera = tessera_set.find {|tess| tess[:character_id] == possible.id}
      if tessera
        t = tessera.number
      else
        t = 0
      end
      writer_name = possible.user.reaping_display_name
      # output << "D#{possible.home_area}#{possible.gender[0].downcase}\t#{possible.first_name} #{possible.last_name}\t[#{writer_name}]\t#{possible.age}\t#{t}<br>"
      output << "D#{possible.home_area}#{possible.gender[0].downcase},#{possible.first_name} #{possible.last_name},[#{writer_name}],#{possible.age},#{t}<br>"
    end
    render text: output
  end


  def quell70_reaping_list
    rc = ReapingCheck.last
    all_eligible = rc.characters
    rc_id = rc.id
    all_eligible_with_odds = []
    formatted_tributes = ''
    all_eligible.each do |p|
      tessera = Tessera.where("character_id = #{p.id} AND reaping_check_id = #{rc_id} AND approved = true")
      if tessera.last
        t = tessera.last.number
      else
        t = 0
      end
      u = User.find_by_id(p.user_id)
      u.username.downcase == u.display_name.downcase ? un = u.display_name : un = "#{u.username} '#{u.display_name}'"

      char = {
          :name => "#{p.first_name} #{p.last_name}",
          :owner => un,
          :odds => t + p.age - 10,
          :age => p.age,
          :tessera => t,
          :district => p.home_area,
          :gender => p.gender[0].downcase
      }

      all_eligible_with_odds.fill(char, all_eligible_with_odds.size, char[:odds])
    end


    tributes = all_eligible_with_odds.sample(24)
    tributes.uniq!

    hax = 0
    while tributes.size < 24 && hax < 10
      tributes.push all_eligible_with_odds.sample(1)
      tributes.uniq!
      hax += 1
    end

    if params[:debug]
      render json: all_eligible_with_odds
    else
      tributes.each do |tribute|
        print tribute
        formatted_tributes += "D#{tribute[:district]} #{tribute[:gender]} #{tribute[:name]} [#{tribute[:owner]}] - #{tribute[:age]}<br>"
        # puts "D #{tribute['district']}" #" #{tribute[:gender]} #{tribute[:name]} [#{tribute[:owner]}] - #{tribute[:age]}<br>"
      end
      render text: formatted_tributes
    end

  end

  def reaping
    output = ""
    rc = ReapingCheck.last
    possibles = rc.characters.preload(:user)
    tessera_set = Tessera.where("reaping_check_id = #{rc.id} AND approved = true")
    by_district_gender = {}
    possibles.each do |possible|
      tessera = tessera_set.find {|tess| tess[:character_id] == possible.id}
      if tessera
        t = tessera.number
      else
        t = 0
      end
      odds = t + possible.age - 10

      dg_id = possible.home_area + possible.gender[0]
      by_district_gender[dg_id] ||= []
      by_district_gender[dg_id].fill(possible, by_district_gender[dg_id].length, odds)
    end

    by_district_gender.sort_by{|k,_| [k.to_i, k]}.each do |dg_id, tributes|
      tribute = tributes.sample(1).first
      writer_name = tribute.user.reaping_display_name
      output << "<b>#{dg_id}</b> - #{tribute.first_name} #{tribute.last_name} [#{writer_name}]<br>"
    end

    render text: output
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


  def attacks
    attacks = []
    Attack.all.each do |attack|
      attacks.push attack.weaponize
    end
    render json: attacks, status:200
  end


  def attack
    render json: Attack.find_by_attack_code(params[:code]).weaponize, status:200
  end

end
