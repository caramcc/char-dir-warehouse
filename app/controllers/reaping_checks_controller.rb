class ReapingChecksController < ApplicationController


  def open
    @logged_in_user = User.find_by_id(session[:user_id])
    unless @logged_in_user.reaping_checks?
      render :status => :unauthorized
    end
    
  end

end
