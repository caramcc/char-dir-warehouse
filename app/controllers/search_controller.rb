class SearchController < ApplicationController
  def search
    query = params[:query]
    if query
      if query.split(' ').length == 2
        character_query = Character.where("`first_name` LIKE '%#{query.split(' ')[0]}%' AND `last_name` LIKE '%#{query.split(' ')[2]}%'")
      else
        character_query = Character.where("`first_name` LIKE '%#{query}%' OR `last_name` LIKE '%#{query}%'")
      end

      user_query = User.where("`username` LIKE '%#{query}%' OR `display_name` LIKE '%#{query}%'")

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
  
end
