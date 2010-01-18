require 'test_helper'

ApplicationController.class_eval do
  def current_user_has_ruled_on_inquest?(i)
    inquest_ids_ruled_on_by_current_user.include?(i.id)
  end
end

class RulingsControllerTest < ActionController::TestCase
  
  setup do
    Inquest.delete_all
    @inquest1 = Inquest.create!(:image_url => 'http://myimageserver.com/images/1.png')
    @inquest2 = Inquest.create!(:image_url => 'http://myimageserver.com/images/2.png')
  end
  
  test "after successfully ruling on an Inquest, the user should be redirected to another random Inquest" do
    post :create, :inquest_id => @inquest1.id, :ruling => { :vote => 'yes' }
    assert_redirected_to random_inquest_path
  end
  
  test "after successfully ruling on an Inquest, should mark the current user as having ruled on it" do
    post :create, :inquest_id => @inquest2.id, :ruling => { :vote => 'no' }
    assert @controller.current_user_has_ruled_on_inquest?(@inquest2)
  end
  
end
