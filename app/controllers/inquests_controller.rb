class InquestsController < ApplicationController
  
  def show
    @inquest = Inquest.find(params[:id])
  end

end
