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
          members: ['avox', 'gamemaker', 'victor', 'peacekeeper', 'tribute']
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

          negate = (filter[0] == '!')
          puts negate

          validated = validate_search(filter, negate)

          if validated
            query_builder << validated
          end
        end
      end

      if query_params.length == 2
        character_query = Character.where("first_name ILIKE '%#{query_params[0]}%' AND last_name ILIKE '%#{query_params[1]}%' #{query_builder}")
      elsif query_params.length == 1
        character_query = Character.where("first_name ILIKE '%#{query}%' OR last_name ILIKE '%#{query}%' #{query_builder}")
      else
        character_query = Character.where("#{query_builder[4..-1]}")
      end

      user_query = User.where("username ILIKE '%#{query}%' OR display_name ILIKE '%#{query}%' ")

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
    def validate_search(filter, negate=false)
      search_pair = filter.split(':')

      if search_pair.length != 2
        return false
      end

      filter_field, filter_term = *search_pair

      valid = false
      type = :equal
      column = filter_field

      VALID_FILTERS.each do |vf|
        if filter_field.gsub('!', '') == vf[:field].downcase && (vf[:members].nil? || vf[:members].include?(filter_term.downcase))
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
          if filter_field.gsub('!', '') == 'age'
            query = "AND #{column} #{negate ? '!' : ''}= '#{filter_term.to_i}' "
          else
            query = "AND #{column} #{negate ? 'NOT' : ''} ILIKE '#{filter_term}' "
          end
      end

      query

    end

end
