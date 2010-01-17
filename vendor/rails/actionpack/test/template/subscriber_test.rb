require "abstract_unit"
require "rails/subscriber/test_helper"
require "action_view/railties/subscriber"
require "controller/fake_models"

module ActionViewSubscriberTest

  def setup
    @old_logger = ActionController::Base.logger
    @view = ActionView::Base.new(ActionController::Base.view_paths, {})
    Rails.stubs(:root).returns(File.expand_path(FIXTURE_LOAD_PATH))
    Rails::Subscriber.add(:action_view, ActionView::Railties::Subscriber.new)
    super
  end

  def teardown
    super
    Rails::Subscriber.subscribers.clear
    ActionController::Base.logger = @old_logger
  end

  def set_logger(logger)
    ActionController::Base.logger = logger
  end

  def test_render_file_template
    @view.render(:file => "test/hello_world.erb")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered test\/hello_world\.erb/, @logger.logged(:info).last
  end

  def test_render_text_template
    @view.render(:text => "OMG")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered text template/, @logger.logged(:info).last
  end

  def test_render_inline_template
    @view.render(:inline => "<%= 'OMG' %>")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered inline template/, @logger.logged(:info).last
  end

  def test_render_partial_template
    @view.render(:partial => "test/customer")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered test\/_customer.erb/, @logger.logged(:info).last
  end

  def test_render_partial_with_implicit_path
    @view.stubs(:controller_path).returns("test")
    @view.render(Customer.new("david"), :greeting => "hi")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered customers\/_customer\.html\.erb/, @logger.logged(:info).last
  end

  def test_render_collection_template
    @view.render(:partial => "test/customer", :collection => [ Customer.new("david"), Customer.new("mary") ])
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered test\/_customer.erb/, @logger.logged(:info).last
  end

  def test_render_collection_with_implicit_path
    @view.stubs(:controller_path).returns("test")
    @view.render([ Customer.new("david"), Customer.new("mary") ], :greeting => "hi")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered customers\/_customer\.html\.erb/, @logger.logged(:info).last
  end

  def test_render_collection_template_without_path
    @view.stubs(:controller_path).returns("test")
    @view.render([ GoodCustomer.new("david"), Customer.new("mary") ], :greeting => "hi")
    wait

    assert_equal 1, @logger.logged(:info).size
    assert_match /Rendered collection/, @logger.logged(:info).last
  end

  class SyncSubscriberTest < ActiveSupport::TestCase
    include Rails::Subscriber::SyncTestHelper
    include ActionViewSubscriberTest
  end

  class AsyncSubscriberTest < ActiveSupport::TestCase
    include Rails::Subscriber::AsyncTestHelper
    include ActionViewSubscriberTest
  end
end