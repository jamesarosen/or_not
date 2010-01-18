class InquestsController < ApplicationController
  
  def show
    @inquest = Inquest.find(params[:id])
  end
  
  def random
    @inquest = Inquest.random_not_including(inquest_ids_ruled_on_by_current_user)
    if @inquest.present?
      render :action => 'show'
    else
      render :action => 'none'
    end
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
