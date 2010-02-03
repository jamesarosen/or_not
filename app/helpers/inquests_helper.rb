module InquestsHelper
  
  def inquest_image_tag(inquest)
    image_tag inquest.image_url, :class => 'xOrNot'
  end

  def inquest_image_tag_small(inquest)
    image_tag inquest.image_url, :class => 'xOrNot small'
  end
  
end
