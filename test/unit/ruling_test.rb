require 'test_helper'

class RulingTest < ActiveSupport::TestCase
  
  setup do
    @filing_cabinet = Inquest.new(:image_url => 'http://images.filingCabinets.com/1')
    @tortoise = Inquest.new(:image_url => 'http://animals.org/tortoise.png')
  end

  test "a Ruling should require an Inquest" do
    r = Ruling.create(:inquest => nil)
    assert r.errors[:inquest].present?
  end
  
  test "a Ruling should require a vote" do
    r = Ruling.create(:inquest => @filing_cabinet, :vote => nil)
    assert r.errors[:vote].present?
  end
  
  test "a Ruling with an unknown vote value should be invalid" do
    r = Ruling.create(:inquest => @tortoise, :vote => 'fazbot')
    assert r.errors[:vote].present?
  end
  
  ['yes', 'no', 'not_sure'].each do |vote|
    test "a Ruling with an Inquest and a '#{vote}' vote should be valid" do
      r = Ruling.new(:inquest => @tortoise, :vote => vote)
      assert r.valid?
    end
  end
  
end
