require 'uri'

class Inquest < ActiveRecord::Base
  
  validates_presence_of :image_url
  validate :validate_image_url_is_fully_qualified_url
  
  protected
  
  def validate_image_url_is_fully_qualified_url
    as_uri = URI.parse(self.image_url) rescue nil
    errors.add(:image_url, 'is not a proper URL') unless as_uri.kind_of?(URI::HTTP)
  end
  
end
