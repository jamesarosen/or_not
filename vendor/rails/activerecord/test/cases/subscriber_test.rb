require "cases/helper"
require "models/developer"
require "rails/subscriber/test_helper"
require "active_record/railties/subscriber"

module SubscriberTest
  Rails::Subscriber.add(:active_record, ActiveRecord::Railties::Subscriber.new)

  def setup
    @old_logger = ActiveRecord::Base.logger
    super
  end

  def teardown
    super
    ActiveRecord::Base.logger = @old_logger
  end

  def set_logger(logger)
    ActiveRecord::Base.logger = logger
  end

  def test_basic_query_logging
    Developer.all
    wait
    assert_equal 1, @logger.logged(:debug).size
    assert_match /Developer Load/, @logger.logged(:debug).last
    assert_match /SELECT .*?FROM .?developers.?/, @logger.logged(:debug).last
  end

  def test_cached_queries
    ActiveRecord::Base.cache do
      Developer.all
      Developer.all
    end
    wait
    assert_equal 2, @logger.logged(:debug).size
    assert_match /CACHE/, @logger.logged(:debug).last
    assert_match /SELECT .*?FROM .?developers.?/, @logger.logged(:debug).last
  end

  class SyncSubscriberTest < ActiveSupport::TestCase
    include Rails::Subscriber::SyncTestHelper
    include SubscriberTest
  end

  class AsyncSubscriberTest < ActiveSupport::TestCase
    include Rails::Subscriber::AsyncTestHelper
    include SubscriberTest
  end
end