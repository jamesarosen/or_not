class PagesController < ApplicationController
  
  def home
    @inquest = Inquest.last
  end

  def about
  end

end
