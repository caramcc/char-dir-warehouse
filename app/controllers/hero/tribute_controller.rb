module Hero
  class TributeController < ApplicationController

    def show
      @tribute = Tribute.find_by_id(params[:id])
    end

    def update

    end

    def edit
      @tribute = Tribute.find_by_id(params[:id])
    end

  end
end
