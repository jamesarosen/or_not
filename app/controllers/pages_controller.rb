class PagesController < ApplicationController
  
  def home
    @inquest = Inquest.random_not_including(inquest_ids_ruled_on_by_current_user)
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
