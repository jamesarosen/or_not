class RulingsController < ApplicationController
  
  def create
    @ruling ||= Ruling.new(params[:ruling])
    if @ruling.save
      redirect_to random_inquest_path
    else
      @inquest = @ruling.inquest
      render :action => '/inquests/show'
    end
  end

end
