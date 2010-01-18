require 'test_helper'

class RulingsControllerTest < ActionController::TestCase
  
  setup do
    Inquest.delete_all
    @inquest1 = Inquest.create!(:image_url => 'http://myimageserver.com/images/1.png')
    @inquest2 = Inquest.create!(:image_url => 'http://myimageserver.com/images/2.png')
  end
  
  test "after successfully ruling on an Inquest, the user should be redirected to another random Inquest" do
    post :create, :ruling => { :inquest_id => @inquest1.id, :vote => 'yes' }
    assert_redirected_to random_inquest_path
  end
  
end
