class RulingsController < ApplicationController
  
  helper :all
  
  def index
    @inquest = Inquest.find(params[:inquest_id])
  end
  
  def create
    @inquest = Inquest.find(params[:inquest_id])
    @ruling ||= Ruling.new(params[:ruling].merge(:inquest => @inquest))
    if @ruling.save
      flash[:notice] = I18n.t('rulings.create.success')
      redirect_to random_inquest_path
      current_user_has_ruled_on_inquest(@inquest)
    else
      flash[:error] = I18n.t('rulings.create.error')
      render :action => '/inquests/show'
    end
  end

end
