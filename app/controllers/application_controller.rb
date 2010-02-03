class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'application'
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from ActionController::RoutingError, :with => :not_found
  rescue_from ActionController::UnknownAction, :with => :not_found
  rescue_from ActionController::UnknownController, :with => :not_found
  
  protected
  
  def not_found(e = nil)
    @exception = e
    render :action => '/pages/not_found', :status => :not_found
  end
  
  def inquest_ids_ruled_on_by_current_user
    session[:ruled_on_inquest_ids] ||= []
  end
  
  def current_user_has_ruled_on_inquest(inquest)
    inquest_ids_ruled_on_by_current_user << inquest.id
  end
end
