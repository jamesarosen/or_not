require 'test_helper'

class InquestTest < ActiveSupport::TestCase
  
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
  
end
