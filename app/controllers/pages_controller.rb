class PagesController < ApplicationController
  
  def home
    @inquest = Inquest.last
    if @inquest.present?
      render :action => '/inquests/show'
    else
      render :action => '/inquests/none'
    end
  end

  def about
  end
  
  def not_found
    render :status => :not_found
  end

end
