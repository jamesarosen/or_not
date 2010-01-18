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
  
  def self.random_not_including(ids)
    if (c = self.count - ids.size) <= 0
      nil
    else
      # Without the sub-query, the offset could be for one
      # of the rows omitted by the where clause. Using the
      # sub-query means that all rows that the offset sees
      # are valid.
      # 
      # The alternative would be to use :order => rand,
      # but that gets very slow for large tables.
      # (hat tip: http://github.com/hgimenez/fast_random)
      find(:first, :select => 'remaining_inquests.*',
                   :from => "(select * from `#{self.table_name}` where " +
                              sanitize_sql_array(['id not in (?)', ids]) +
                            ") as remaining_inquests",
                   :offset => rand(c))
    end
  end
  
  validates_presence_of :image_url
  validate :validate_image_url_is_fully_qualified_url
  
  def predecessor
    @predecessor ||= self.class.predecessor_of(self)
  end
  
  def successor
    @successor ||= self.class.successor_of(self)
  end
  
  protected
  
  def validate_image_url_is_fully_qualified_url
    as_uri = URI.parse(self.image_url) rescue nil
    errors.add(:image_url, I18n.translate('errors.messages.improper_url')) unless as_uri.kind_of?(URI::HTTP)
  end
  
end
