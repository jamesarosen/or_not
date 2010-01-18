class Ruling < ActiveRecord::Base
  
  YES      = 'yes'
  NO       = 'no'
  NOT_SURE = 'not_sure'
  VOTES = [ YES, NO, NOT_SURE ]
  
  belongs_to :inquest
  
  validates_presence_of :inquest, :vote
  validates_inclusion_of :vote, :in => Ruling::VOTES, :allow_blank => true
  
end
