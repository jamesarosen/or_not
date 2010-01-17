require 'abstract_unit'
require 'generators/generators_test_helper'
require 'rails/generators/rails/app/app_generator'

class AppGeneratorTest < GeneratorsTestCase
  arguments [destination_root]

  def setup
    super
    Rails::Generators::AppGenerator.instance_variable_set('@desc', nil)
  end

  def teardown
    super
    Rails::Generators::AppGenerator.instance_variable_set('@desc', nil)
  end

  def test_application_skeleton_is_created
    run_generator

    %w(
      app/controllers
      app/helpers
      app/models
      app/views/layouts
      config/environments
      config/initializers
      config/locales
      db
      doc
      lib
      lib/tasks
      log
      public/images
      public/javascripts
      public/stylesheets
      script/performance
      test/fixtures
      test/functional
      test/integration
      test/performance
      test/unit
      vendor
      vendor/plugins
      tmp/sessions
      tmp/sockets
      tmp/cache
      tmp/pids
    ).each{ |path| assert_file path }
  end

  def test_invalid_database_option_raises_an_error
    content = capture(:stderr){ run_generator([destination_root, "-d", "unknown"]) }
    assert_match /Invalid value for \-\-database option/, content
  end

  def test_invalid_application_name_raises_an_error
    content = capture(:stderr){ run_generator [File.join(destination_root, "43-things")] }
    assert_equal "Invalid application name 43-things. Please give a name which does not start with numbers.\n", content
  end

  def test_invalid_application_name_is_fixed
    run_generator [File.join(destination_root, "things-43")]
    assert_file "things-43/config/environment.rb", /Things43::Application\.initialize!/
    assert_file "things-43/config/application.rb", /^module Things43$/
  end

  def test_application_names_are_not_singularized
    run_generator [File.join(destination_root, "hats")]
    assert_file "hats/config/environment.rb", /Hats::Application\.initialize!/
  end

  def test_config_database_is_added_by_default
    run_generator
    assert_file "config/database.yml", /sqlite3/
  end

  def test_config_database_is_not_added_if_skip_activerecord_is_given
    run_generator [destination_root, "--skip-activerecord"]
    assert_no_file "config/database.yml"
  end

  def test_activerecord_is_removed_from_frameworks_if_skip_activerecord_is_given
    run_generator [destination_root, "--skip-activerecord"]
    assert_file "config/boot.rb", /# require "active_record\/railtie"/
  end

  def test_prototype_and_test_unit_are_added_by_default
    run_generator
    assert_file "public/javascripts/prototype.js"
    assert_file "test"
  end

  def test_prototype_and_test_unit_are_skipped_if_required
    run_generator [destination_root, "--skip-prototype", "--skip-testunit"]
    assert_no_file "public/javascripts/prototype.js"
    assert_no_file "test"
  end

  def test_shebang_is_added_to_files
    run_generator [destination_root, "--ruby", "foo/bar/baz"]

    %w(
      about
      console
      dbconsole
      destroy
      generate
      plugin
      runner
      server
    ).each { |path| assert_file "script/#{path}", /#!foo\/bar\/baz/ }
  end

  def test_shebang_when_is_the_same_as_default_use_env
    run_generator [destination_root, "--ruby", Thor::Util.ruby_command]

    %w(
      about
      console
      dbconsole
      destroy
      generate
      plugin
      runner
      server
    ).each { |path| assert_file "script/#{path}", /#!\/usr\/bin\/env/ }
  end

  def test_template_from_dir_pwd
    FileUtils.cd(Rails.root)
    assert_match /It works from file!/, run_generator([destination_root, "-m", "lib/template.rb"])
  end

  def test_template_raises_an_error_with_invalid_path
    content = capture(:stderr){ run_generator([destination_root, "-m", "non/existant/path"]) }
    assert_match /The template \[.*\] could not be loaded/, content
    assert_match /non\/existant\/path/, content
  end

  def test_template_is_executed_when_supplied
    path = "http://gist.github.com/103208.txt"
    template = %{ say "It works!" }
    template.instance_eval "def read; self; end" # Make the string respond to read

    generator([destination_root], :template => path).expects(:open).with(path).returns(template)
    assert_match /It works!/, silence(:stdout){ generator.invoke }
  end

  def test_usage_read_from_file
    File.expects(:read).returns("USAGE FROM FILE")
    assert_equal "USAGE FROM FILE", Rails::Generators::AppGenerator.desc
  end

  def test_default_usage
    File.expects(:exist?).returns(false)
    assert_match /Create rails files for app generator/, Rails::Generators::AppGenerator.desc
  end

  def test_default_namespace
    assert_match "rails:generators:app", Rails::Generators::AppGenerator.namespace
  end

  def test_file_is_added_for_backwards_compatibility
    action :file, 'lib/test_file.rb', 'heres test data'
    assert_file 'lib/test_file.rb', 'heres test data'
  end

  def test_dev_option
    generator([destination_root], :dev => true).expects(:run).with("gem bundle")
    silence(:stdout){ generator.invoke }
    rails_path = File.expand_path('../../..', Rails.root)
    dev_gem = %(directory #{rails_path.inspect}, :glob => "{*/,}*.gemspec")
    assert_file 'Gemfile', /^#{Regexp.escape(dev_gem)}$/
  end

  def test_edge_option
    generator([destination_root], :edge => true).expects(:run).with("gem bundle")
    silence(:stdout){ generator.invoke }
    edge_gem = %(gem "rails", :git => "git://github.com/rails/rails.git")
    assert_file 'Gemfile', /^#{Regexp.escape(edge_gem)}$/
  end

  protected

    def action(*args, &block)
      silence(:stdout){ generator.send(*args, &block) }
    end

end
