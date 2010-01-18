class PagesController < ApplicationController

  def about
  end
  
  def not_found
    render :status => :not_found
  end

end
