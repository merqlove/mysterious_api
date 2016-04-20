require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require './lib/gems/pundit'

module Mysterious
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      # g.test_framework :minitest, spec: true, fixture: true
      g.orm :active_record
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl
      g.factory_girl dir: 'spec/factories'
      g.template_engine :erb
      g.assets false
      g.helper = false
      g.view false

      g.view_specs false
      g.helper_specs false
    end

    config.active_record.schema_format = :sql

    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/lib/middlewares)
    config.autoload_paths += %W(#{config.root}/lib/strategies)
    config.autoload_paths += %W(#{config.root}/lib/gems)

    config.time_zone = 'Moscow'
  end
end
