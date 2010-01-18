require 'test_helper'

ApplicationController.class_eval do
  def public_current_user_has_ruled_on_inquest(i)
    current_user_has_ruled_on_inquest(i)
  end
end

class PagesControllerTest < ActionController::TestCase
  
  setup do
    Inquest.create!(:image_url => 'http://myimageserver.com/images/1.png')
  end
  
  test 'should route /about to pages/about' do
    assert_routing '/about', :controller => 'pages', :action => 'about'
    assert_recognizes({:controller => 'pages', :action => 'about'}, '/about.html')
  end
  
end
