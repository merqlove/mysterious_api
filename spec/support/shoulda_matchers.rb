require 'shoulda-matchers'

module ShouldaMatchersFixDeprecation
  def matches?(controller)
    @controller = controller
    ensure_action_and_verb_present!

    parameters_double_registry.register

    Doublespeak.with_doubles_activated do
      context.__send__(verb, action, params: request_params)
    end

    unpermitted_parameter_names.empty?
  end
end

Shoulda::Matchers::ActionController::PermitMatcher.send(:include, ShouldaMatchersFixDeprecation)

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Choose one or more libraries:
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end
