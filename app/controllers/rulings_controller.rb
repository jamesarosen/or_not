class RulingsController < ApplicationController
  
  def create
    @ruling ||= Ruling.new(params[:ruling])
    if @ruling.save
      redirect_to random_inquest_path
      current_user_has_ruled_on_inquest(@ruling.inquest)
    else
      @inquest = @ruling.inquest
      render :action => '/inquests/show'
    end
  end

end
