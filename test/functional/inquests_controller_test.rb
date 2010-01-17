require 'test_helper'

class InquestsControllerTest < ActionController::TestCase

  setup do
    Timecop.travel(6.days.ago) do
      @old_inquest = Inquest.create!(:image_url => 'http://foo.com/cabinet.jpg')
    end
    Timecop.travel(1.day.ago) do
      @new_inquest = Inquest.create!(:image_url => 'http://baz.com/guitar.gif')
    end
  end
  
  test "showing an inquest that does not exist should return a not-found" do
    assert Inquest.find_by_id(68381).blank?
    get :show, :id => 68381
    assert_response :not_found
  end

  test "showing an inquest that exists should be successful" do
    get :show, :id => @new_inquest.id
    assert_equal @new_inquest, assigns(:inquest)
    assert_response :success
  end
  
  test "showing the oldest inquest should not show a 'previous' link" do
    get :show, :id => @old_inquest.id
    assert_select 'a', :text => /prev|old/i, :count => 0
  end
  
  test "showing an inquest that is newer than another inquest should show an 'previous' link" do
    get :show, :id => @new_inquest.id
    assert_select "a[href='#{inquest_path(@old_inquest)}']", :text => /prev|old/i, :count => 1
  end
  
  test "showing an inquest that is older than another inquest should show a 'newer' link" do
    get :show, :id => @old_inquest.id
    assert_select "a[href='#{inquest_path(@new_inquest)}']", :text => /next|new/i, :count => 1
  end
  
  test "showing the newest inquest should not show a 'newer' link" do
    get :show, :id => @new_inquest.id
    assert_select 'a', :text => /next|new/i, :count => 0
  end
  
end
