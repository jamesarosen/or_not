require 'test_helper'

class InquestsControllerTest < ActionController::TestCase

  setup do
    Inquest.delete_all
    Timecop.travel(6.days.ago) do
      @old_inquest = Inquest.create!(:image_url => 'http://foo.com/cabinet.jpg')
    end
    Timecop.travel(1.day.ago) do
      @new_inquest = Inquest.create!(:image_url => 'http://baz.com/guitar.gif')
    end
  end
  
  test 'showing the home page when no Inquests have been created should be OK' do
    Inquest.delete_all
    get :random
    assert_response :success
    assert_select "a[href='#{new_inquest_path}']"
    assert_template '/inquests/none'
  end
  
  test 'showing the home page when the user has ruled on all inquests should be OK' do
    Inquest.all.each do |i|
      @controller.public_current_user_has_ruled_on_inquest(i)
    end
    get :random
    assert_response :success
    assert_select "a[href='#{new_inquest_path}']"
    assert_template '/inquests/none'
  end

  test 'should route / to inquests/random' do
    assert_routing '/', :controller => 'inquests', :action => 'random'
    assert_recognizes({:controller => 'inquests', :action => 'random'}, '/index.html')
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
    assert_select 'a', :text => /pred|prev|older/i, :count => 0
  end
  
  test "showing an inquest that is newer than another inquest should show an 'previous' link" do
    get :show, :id => @new_inquest.id
    assert_select "a[href='#{inquest_path(@old_inquest)}']", :text => /pred|prev|older/i, :count => 1
  end
  
  test "showing an inquest that is older than another inquest should show a 'newer' link" do
    get :show, :id => @old_inquest.id
    assert_select "a[href='#{inquest_path(@new_inquest)}']", :text => /succ|next|newer/i, :count => 1
  end
  
  test "showing the newest inquest should not show a 'newer' link" do
    get :show, :id => @new_inquest.id
    assert_select 'a', :text => /succ|next|newer/i, :count => 0
  end
  
  test "showing the form to add an Inquest should be successful" do
    get :new
    assert_response :success
    assert_kind_of Inquest, assigns(:inquest)
    assert assigns(:inquest).new_record?
    assert_template '/inquests/new'
  end
  
  test "saving a new Inquest with an image_url should be successful" do
    post :create, :inquest => { :image_url => 'http://troglodyte.com/fi3m2.jpg' }
    assert_redirected_to Inquest.last
  end
  
  test "saving a new Inquest with no image_url should fail" do
    post :create, :inquest => { :image_url => nil }
    assert_kind_of Inquest, assigns(:inquest)
    assert assigns(:inquest).errors[:image_url].present?
    assert_template '/inquests/new'
  end
  
  test "saving a new Inquest with a bad image_url should fail" do
    post :create, :inquest => { :image_url => 'umlauts rock!' }
    assert_kind_of Inquest, assigns(:inquest)
    assert assigns(:inquest).errors[:image_url].present?
    assert_template '/inquests/new'
  end
  
end
