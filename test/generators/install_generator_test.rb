require 'test_helper'

require 'generators/grape/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  include GrapeApiGenerator::TestHelper

  tests ::Grape::Generators::InstallGenerator
  destination File.expand_path("../../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  setup :copy_routes

  test "generate base api file" do
    run_generator %w(my_app)
    assert_file "app/api/my_app/api.rb", /module MyApp/
    assert_file "app/api/my_app/api.rb", /class API < Grape::API/
  end

  test "generate version api files" do
    run_generator %w(my_app)
    assert_file "app/api/my_app/v1.rb", /class V1 < MyApp::API/

    run_generator %w(my_app --version 2)
    assert_file "app/api/my_app/v2.rb", /class V2 < MyApp::API/
  end

  test "generate api helper file" do
    run_generator %w(my_app)
    assert_file "app/api/my_app/api_helpers.rb", /module ApiHelpers/
    assert_file "app/api/my_app/api.rb", /helpers MyApp::ApiHelpers/
  end

  test "add route for api" do
    run_generator %w(my_app)
    assert_file "config/routes.rb", %r(mount MyApp::V1 => '/')
  end
end