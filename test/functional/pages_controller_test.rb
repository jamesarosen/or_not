require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  test 'should route / to pages/home' do
    assert_routing '/', :controller => 'pages', :action => 'home'
    assert_recognizes({:controller => 'pages', :action => 'home'}, '/index.html')
  end
  
  test 'should route /about to pages/about' do
    assert_routing '/about', :controller => 'pages', :action => 'about'
    assert_recognizes({:controller => 'pages', :action => 'about'}, '/about.html')
  end
  
end
