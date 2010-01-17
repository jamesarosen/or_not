require 'test_helper'

class NotFoundTest < ActionController::IntegrationTest

  test 'a GET to a wrong route should return a 404' do
    get '/fazbot'
    assert_response :not_found
    assert_template '/pages/not_found'
  end
  
end
