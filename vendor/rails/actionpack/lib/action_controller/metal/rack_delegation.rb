require 'action_dispatch/http/request'
require 'action_dispatch/http/response'

module ActionController
  module RackDelegation
    extend ActiveSupport::Concern

    included do
      delegate :session, :to => "@_request"
      delegate :headers, :status=, :location=, :content_type=,
               :status, :location, :content_type, :to => "@_response"
      attr_internal :request
    end

    def dispatch(action, env)
      @_request = ActionDispatch::Request.new(env)
      @_response = ActionDispatch::Response.new
      @_response.request = request
      super
    end

    def params
      @_params ||= @_request.parameters
    end

    def response_body=(body)
      response.body = body if response
      super
    end

    def reset_session
      @_request.reset_session
    end
  end
end
