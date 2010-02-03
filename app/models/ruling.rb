class Ruling < ActiveRecord::Base
  
  YES      = 'yes'.freeze
  NO       = 'no'.freeze
  NOT_SURE = 'not_sure'.freeze
  VOTES = [ YES, NO, NOT_SURE ].freeze
  
  VOTES.each do |vote|
    scope vote.to_sym, :conditions => { :vote => vote }
  end
  
  belongs_to :inquest
  
  validates_presence_of :inquest, :vote
  validates_inclusion_of :vote, :in => Ruling::VOTES, :allow_blank => true
  
end
