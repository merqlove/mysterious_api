Warden::Strategies.add(:token_auth, TokenAuthStrategy)
Warden::Strategies.add(:basic_auth, BasicAuthStrategy)

Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.default_strategies :token_auth, :basic_auth
  manager.failure_app =  lambda { |env|
    failure_action = env['warden.options'][:action].to_sym
    ApplicationController.action(failure_action).call(env)
  }
end
