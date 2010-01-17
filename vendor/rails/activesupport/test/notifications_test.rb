require 'abstract_unit'

module Notifications
  class TestCase < ActiveSupport::TestCase
    def setup
      Thread.abort_on_exception = true

      ActiveSupport::Notifications.notifier = nil
      @notifier = ActiveSupport::Notifications.notifier
      @events = []
      @notifier.subscribe { |*args| @events << event(*args) }
    end

    def teardown
      Thread.abort_on_exception = false
    end

    private
      def event(*args)
        ActiveSupport::Notifications::Event.new(*args)
      end

      def drain
        @notifier.wait
      end
  end

  class PubSubTest < TestCase
    def test_events_are_published_to_a_listener
      @notifier.publish :foo
      @notifier.wait
      assert_equal [[:foo]], @events
    end

    def test_subscriber_with_pattern
      events = []
      @notifier.subscribe('1') { |*args| events << args }

      @notifier.publish '1'
      @notifier.publish '1.a'
      @notifier.publish 'a.1'
      @notifier.wait

      assert_equal [['1'], ['1.a']], events
    end

    def test_subscriber_with_pattern_as_regexp
      events = []
      @notifier.subscribe(/\d/) { |*args| events << args }

      @notifier.publish '1'
      @notifier.publish 'a.1'
      @notifier.publish '1.a'
      @notifier.wait

      assert_equal [['1'], ['a.1'], ['1.a']], events
    end

    def test_multiple_subscribers
      @another = []
      @notifier.subscribe { |*args| @another << args }
      @notifier.publish :foo
      @notifier.wait

      assert_equal [[:foo]], @events
      assert_equal [[:foo]], @another
    end

    private
      def event(*args)
        args
      end
  end

  class SyncPubSubTest < PubSubTest
    def setup
      Thread.abort_on_exception = true

      @notifier = ActiveSupport::Notifications::Notifier.new(ActiveSupport::Notifications::Fanout.new(true))
      @events = []
      @notifier.subscribe { |*args| @events << event(*args) }
    end
  end

  class InstrumentationTest < TestCase
    delegate :instrument, :instrument!, :to => ActiveSupport::Notifications

    def test_instrument_returns_block_result
      assert_equal 2, instrument(:awesome) { 1 + 1 }
      drain
    end

    def test_instrument_with_bang_returns_result_even_on_failure
      begin
        instrument!(:awesome, :payload => "notifications") do
          raise "OMG"
        end
        flunk
      rescue
      end

      drain

      assert_equal 1, @events.size
      assert_equal :awesome, @events.last.name
      assert_equal Hash[:payload => "notifications"], @events.last.payload
    end

    def test_instrument_yields_the_paylod_for_further_modification
      assert_equal 2, instrument(:awesome) { |p| p[:result] = 1 + 1 }
      drain

      assert_equal 1, @events.size
      assert_equal :awesome, @events.first.name
      assert_equal Hash[:result => 2], @events.first.payload
    end

    def test_instrumenter_exposes_its_id
      assert_equal 20, ActiveSupport::Notifications.instrumenter.id.size
    end

    def test_nested_events_can_be_instrumented
      instrument(:awesome, :payload => "notifications") do
        instrument(:wot, :payload => "child") do
          1 + 1
        end

        drain

        assert_equal 1, @events.size
        assert_equal :wot, @events.first.name
        assert_equal Hash[:payload => "child"], @events.first.payload
      end

      drain

      assert_equal 2, @events.size
      assert_equal :awesome, @events.last.name
      assert_equal Hash[:payload => "notifications"], @events.last.payload
    end

    def test_instrument_does_not_publish_when_exception_is_raised
      begin
        instrument(:awesome, :payload => "notifications") do
          raise "OMG"
        end
      rescue RuntimeError => e
        assert_equal "OMG", e.message
      end

      drain
      assert_equal 0, @events.size
    end

    def test_event_is_pushed_even_without_block
      instrument(:awesome, :payload => "notifications")
      drain

      assert_equal 1, @events.size
      assert_equal :awesome, @events.last.name
      assert_equal Hash[:payload => "notifications"], @events.last.payload
    end
  end

  class EventTest < TestCase
    def test_events_are_initialized_with_details
      time = Time.now
      event = event(:foo, time, time + 0.01, random_id, {})

      assert_equal :foo, event.name
      assert_equal time, event.time
      assert_equal 10.0, event.duration
    end

    def test_events_consumes_information_given_as_payload
      event = event(:foo, Time.now, Time.now + 1, random_id, :payload => :bar)
      assert_equal Hash[:payload => :bar], event.payload
    end

    def test_event_is_parent_based_on_time_frame
      time = Time.utc(2009, 01, 01, 0, 0, 1)

      parent    = event(:foo, Time.utc(2009), Time.utc(2009) + 100, random_id, {})
      child     = event(:foo, time, time + 10, random_id, {})
      not_child = event(:foo, time, time + 100, random_id, {})

      assert parent.parent_of?(child)
      assert !child.parent_of?(parent)
      assert !parent.parent_of?(not_child)
      assert !not_child.parent_of?(parent)
    end

    protected
      def random_id
        @random_id ||= ActiveSupport::SecureRandom.hex(10)
      end
  end
end
