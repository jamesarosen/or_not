require "isolation/abstract_unit"

module ApplicationTests
  class GeneratorsTest < Test::Unit::TestCase
    include ActiveSupport::Testing::Isolation

    def setup
      build_app
      boot_rails
    end

    def app_const
      @app_const ||= Class.new(Rails::Application)
    end

    def with_config
      require "rails/all"
      require "rails/generators"
      yield app_const.config
    end

    test "generators default values" do
      with_config do |c|
        assert_equal(true, c.generators.colorize_logging)
        assert_equal({}, c.generators.aliases)
        assert_equal({}, c.generators.options)
      end
    end

    test "generators set rails options" do
      with_config do |c|
        c.generators.orm            = :datamapper
        c.generators.test_framework = :rspec
        c.generators.helper         = false
        expected = { :rails => { :orm => :datamapper, :test_framework => :rspec, :helper => false } }
        assert_equal(expected, c.generators.options)
      end
    end

    test "generators set rails aliases" do
      with_config do |c|
        c.generators.aliases = { :rails => { :test_framework => "-w" } }
        expected = { :rails => { :test_framework => "-w" } }
        assert_equal expected, c.generators.aliases
      end
    end

    test "generators aliases and options on initialization" do
      add_to_config <<-RUBY
        config.generators.rails :aliases => { :test_framework => "-w" }
        config.generators.orm :datamapper
        config.generators.test_framework :rspec
      RUBY

      # Initialize the application
      require "#{app_path}/config/environment"
      require "rails/generators"
      Rails::Generators.configure!

      assert_equal :rspec, Rails::Generators.options[:rails][:test_framework]
      assert_equal "-w", Rails::Generators.aliases[:rails][:test_framework]
    end

    test "generators no color on initialization" do
      add_to_config <<-RUBY
        config.generators.colorize_logging = false
      RUBY

      # Initialize the application
      require "#{app_path}/config/environment"
      require "rails/generators"
      Rails::Generators.configure!

      assert_equal Thor::Base.shell, Thor::Shell::Basic
    end

    test "generators with hashes for options and aliases" do
      with_config do |c|
        c.generators do |g|
          g.orm    :datamapper, :migration => false
          g.plugin :aliases => { :generator => "-g" },
                   :generator => true
        end

        expected = {
          :rails => { :orm => :datamapper },
          :plugin => { :generator => true },
          :datamapper => { :migration => false }
        }

        assert_equal expected, c.generators.options
        assert_equal({ :plugin => { :generator => "-g" } }, c.generators.aliases)
      end
    end

    test "generators with hashes are deep merged" do
      with_config do |c|
        c.generators do |g|
          g.orm    :datamapper, :migration => false
          g.plugin :aliases => { :generator => "-g" },
                   :generator => true
        end
      end

      assert Rails::Generators.aliases.size >= 1
      assert Rails::Generators.options.size >= 1
    end
  end
end
