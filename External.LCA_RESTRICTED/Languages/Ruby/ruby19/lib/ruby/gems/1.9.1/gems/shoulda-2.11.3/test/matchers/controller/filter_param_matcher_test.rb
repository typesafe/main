require 'test_helper'

class FilterParamMatcherTest < ActionController::TestCase # :nodoc:

  context "a controller that filters no parameters" do
    setup do
      if Rails.respond_to?(:application)
        Rails.application.config.filter_parameters = []
      end
      @controller = define_controller(:examples).new
    end

    should "reject filtering any parameter" do
      assert_rejects filter_param(:any), @controller
    end
  end

  context "a controller that filters a parameter" do
    setup do
      if Rails.respond_to?(:application)
        Rails.application.config.filter_parameters = [:password]
      end
      @controller = define_controller :examples do
        unless Rails.respond_to?(:application)
          filter_parameter_logging :password
        end
      end.new
    end

    should "accept filtering that parameter" do
      assert_accepts filter_param(:password), @controller
    end

    should "reject filtering another parameter" do
      assert_rejects filter_param(:other), @controller
    end
  end

end
