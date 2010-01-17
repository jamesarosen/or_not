require 'generators/generators_test_helper'
require 'rails/generators/rails/performance_test/performance_test_generator'

class PerformanceTestGeneratorTest < GeneratorsTestCase
  arguments %w(performance)

  def test_performance_test_skeleton_is_created
    run_generator
    assert_file "test/performance/performance_test.rb", /class PerformanceTest < ActionController::PerformanceTest/
  end
end
