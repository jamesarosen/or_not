require 'uri'

class Inquest < ActiveRecord::Base
  
  def self.predecessor_of(i)
    raise ArgumentError.new("Cannot find predecessor of #{i}") unless i.kind_of?(self)
    find(:first, :conditions => ['created_at < ?', i.created_at],
                 :order => 'created_at desc',
                 :limit => 1)
  end
  
  def self.successor_of(i)
    raise ArgumentError.new("Cannot find predecessor of #{i}") unless i.kind_of?(self)
    find(:first, :conditions => ['created_at > ?', i.created_at],
                 :order => 'created_at asc',
                 :limit => 1)
  end
  
  validates_presence_of :image_url
  validate :validate_image_url_is_fully_qualified_url
  
  def predecessor
    self.class.predecessor_of(self)
  end
  
  def successor
    self.class.successor_of(self)
  end
  
  protected
  
  def validate_image_url_is_fully_qualified_url
    as_uri = URI.parse(self.image_url) rescue nil
    errors.add(:image_url, 'is not a proper URL') unless as_uri.kind_of?(URI::HTTP)
  end
  
end
