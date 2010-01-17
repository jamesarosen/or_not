class ApplicationController < ActionController::Base
  
  protect_from_forgery
  filter_parameter_logging :password
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from ActionController::RoutingError, :with => :not_found
  rescue_from ActionController::UnknownAction, :with => :not_found
  rescue_from ActionController::UnknownController, :with => :not_found
  
  protected
  
  def not_found(e = nil)
    @exception = e
    render :action => '/pages/not_found', :status => :not_found
  end
  
end
