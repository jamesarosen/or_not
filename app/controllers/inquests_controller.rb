class InquestsController < ApplicationController
  
  def show
    @inquest = Inquest.find(params[:id])
  end
  
  def new
    @inquest ||= new_inquest_from_params
  end
  
  def create
    @inquest ||= new_inquest_from_params
    if @inquest.save
      redirect_to @inquest
    else
      render :action => :new
    end
  end
  
  private
  
  def new_inquest_from_params
    Inquest.new(params[:inquest])
  end

end
