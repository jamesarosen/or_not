class RulingsController < ApplicationController
  
  def create
    @ruling ||= Ruling.new(params[:ruling])
    if @ruling.save
      redirect_to @ruling.inquest
    else
      @inquest = @ruling.inquest
      render :action => '/inquests/show'
    end
  end

end
