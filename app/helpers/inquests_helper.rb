module InquestsHelper
  
  def inquest_image_tag(inquest)
    image_tag @inquest.image_url, :class => 'xOrNot'
  end
  
end
