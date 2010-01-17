require 'test_helper'

class NotFoundTest < ActionController::IntegrationTest

  test 'a GET to a wrong route should return a 404' do
    get '/fazbot'
    assert_response :not_found
    assert_template '/pages/not_found'
  end
  
  test "a GET to an Inquest that doesn't exist should return a 404" do
    assert_nil Inquest.find_by_id(1923942)
    get '/inquests/1923942'
    assert_response :not_found
    assert_template '/pages/not_found'
  end
  
end
