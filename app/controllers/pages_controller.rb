class PagesController < ApplicationController
  
  def home
    @inquest = Inquest.last
    render :action => '/inquests/show'
  end

  def about
  end
  
  def not_found
    render :status => :not_found
  end

end
