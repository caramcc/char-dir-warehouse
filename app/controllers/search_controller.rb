class SearchController < ApplicationController

  VALID_FILTERS = [
      {
          field: 'district',
          column: 'home_area',
          members: ('1'..'13').to_a.push('capitol').push('wanderer')
      },
      {
          field: 'gender',
          column: 'gender',
          members: ['male', 'female', 'other']
      },
      {
          field: 'special',
          column: 'special',
          members: ['avox', 'gamemaker', 'victor', 'peacekeeper']
      },
      {
          field: 'age',
          column: 'age',
          members: ('1'..'120').to_a
      },
      {
          field: 'older-than',
          column: 'age',
          members: nil,
          type: :gt
      },
      {
          field: 'younger-than',
          column: 'age',
          members: nil,
          type: :lt
      }
  ]

  TYPE_MAPPINGS = {
      lt: '<',
      gt: '>',
      equal: 'LIKE'
  }

  def search
    query = params[:query]
    if query
      query_params = query.split(' ')
      filters = query_params.select { |param| param.include?(':')}
      query_params.reject! {|param| puts param; param.include?(':'); }

      query_builder = ''

      unless filters.length == 0
        filters.each do |filter|

          validated = validate_search(filter)

          if validated
            query_builder << validated
          end
        end
      end

      if query_params.length == 2
        puts "fn ln, filters: #{filters}"
        character_query = Character.where("first_name ILIKE '%#{query.split(' ')[0]}%' AND last_name ILIKE '%#{query.split(' ')[2]}%' #{query_builder}")
      elsif query_params.length == 1
        puts "q-split: #{query_params.split(' ')}"
        puts "singlet, filters: #{filters}"
        character_query = Character.where("first_name ILIKE '%#{query}%' OR last_name ILIKE '%#{query}%' #{query_builder}")
      else
        puts "nil, filters: #{filters}"
        character_query = Character.where("#{query_builder[3..-1]}")
      end

      user_query = User.where("username LIKE '%#{query}%' OR display_name LIKE '%#{query}%' ")

      @results = {
          :characters => character_query.to_a,
          :users => user_query.to_a
      }
    else
      @results = {
          :characters =>[],
          :users => []
      }
    end
  end


  private
    def validate_search(filter)
      search_pair = filter.split(':')

      if search_pair.length != 2
        return false
      end

      filter_field, filter_term = *search_pair

      valid = false
      type = :equal
      column = filter_field

      VALID_FILTERS.each do |vf|
        if filter_field == vf[:field].downcase && (vf[:members].nil? || vf[:members].include?(filter_term.downcase))
          valid = true
          column = vf[:column]
          if vf[:members].nil?
            type = vf[:type]
          end
        end
      end

      unless valid
        return false
      end

      case type
        when :gt

          query = "AND #{column} > '#{filter_term.to_i}' "
        when :lt
          query = "AND #{column} < '#{filter_term.to_i}' "

        else
          if filter_field == 'age'
            query = "AND #{column} = '#{filter_term.to_i}' "
          else
            query = "AND #{column} LIKE LOWER('#{filter_term}') "
          end
      end

      query

    end

end
