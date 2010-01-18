class RulingsController < ApplicationController
  
  def create
    @ruling ||= Ruling.new(params[:ruling])
    if @ruling.save
      flash[:notice] = I18n.t('rulings.create.success')
      redirect_to random_inquest_path
      current_user_has_ruled_on_inquest(@ruling.inquest)
    else
      flash[:error] = I18n.t('rulings.create.error')
      @inquest = @ruling.inquest
      render :action => '/inquests/show'
    end
  end

end
