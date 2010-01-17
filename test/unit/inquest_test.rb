require 'test_helper'

class InquestTest < ActiveSupport::TestCase
  
  test 'a new Inquest should require an image_url' do
    assert !Inquest.new(:image_url => nil).valid?
  end
  
  test "a new Inquest with a non-fully-qualified image_url should not be valid" do
    assert !Inquest.new(:image_url => '/my_image').valid?
  end
  
  test "a new Inquest with an image_url that's an absolute URL should be valid" do
    assert Inquest.new(:image_url => 'http://imageserver.com/12345.png').valid?
  end
  
end
