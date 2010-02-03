require 'test_helper'

class InquestTest < ActiveSupport::TestCase
  
  setup do
    Inquest.delete_all
    Timecop.travel(6.days.ago) do
      @old_inquest = Inquest.create!(:image_url => 'http://foo.com/myGrumpyUncle.jpg')
    end
    Timecop.travel(1.day.ago) do
      @new_inquest = Inquest.create!(:image_url => 'http://bar.com/ghost.png')
    end
  end
  
  test 'finding a random Inquest not in a given list of IDs should return an Inquest if one exists' do
    assert_equal @new_inquest, Inquest.random_not_including([@old_inquest.id])
  end
  
  test 'finding a random Inquest not in a given list of IDs should return a _random_ Inquest if one exists' do
    flunk("I'll need to write some statistics-based testing for this one.")
  end
  
  test 'finding a random Inquest not in a given list of IDs should return nil if none exists' do
    assert_nil Inquest.random_not_including([@old_inquest.id, @new_inquest.id])
  end
  
  test 'a new Inquest should require an image_url' do
    i = Inquest.create(:image_url => nil)
    assert i.errors[:image_url].present?
  end
  
  test "a new Inquest with a non-fully-qualified image_url should not be valid" do
    i = Inquest.create(:image_url => '/foo')
    assert i.errors[:image_url].present?
  end
  
  test "a new Inquest with an image_url that's an absolute URL should be valid" do
    i = Inquest.create(:image_url => 'http://myimageserver.com/images/1.png')
    assert i.errors[:image_url].blank?
  end

  test 'an Inquest should return a nil predecessor if it has none' do
    assert_nil @old_inquest.predecessor
  end
  
  test 'an Inquest should know its predecessor if it exists' do
    assert_equal @old_inquest, @new_inquest.predecessor
  end
  
  test 'an Inquest should know its successor if it exists' do
    assert_equal @new_inquest, @old_inquest.successor
  end
  
  test 'an Inquest should return a nil successor if it has none' do
    assert_nil @new_inquest.successor
  end
  
  test 'an Inquest with Rulings should know its counts for each type of Ruling' do
    4.times { Ruling.create!(:inquest => @new_inquest, :vote => Ruling::YES) }
    3.times { Ruling.create!(:inquest => @new_inquest, :vote => Ruling::NO) }
    2.times { Ruling.create!(:inquest => @new_inquest, :vote => Ruling::NOT_SURE) }
    assert_equal 4, @new_inquest.yes_count
    assert_equal 3, @new_inquest.no_count
    assert_equal 2, @new_inquest.not_sure_count
  end
  
  test 'an Inquest with no Rulings should have 0-counts for each type of Ruling' do
    assert_equal 0, @new_inquest.yes_count
    assert_equal 0, @new_inquest.no_count
    assert_equal 0, @new_inquest.not_sure_count
  end
  
end
