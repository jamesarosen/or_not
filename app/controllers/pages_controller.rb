class PagesController < ApplicationController
  
  def home
    @inquest = Inquest.last
  end

  def about
  end
  
  def not_found
    render :status => :not_found
  end

end
