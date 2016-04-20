Rails.application.config.middleware.insert 0, Rack::Attack

if Rails.env.production?
  Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout
  Rack::Timeout.timeout = 10 # seconds
end

Rails.application.config.middleware.insert_after ActiveRecord::QueryCache, Rack::Protection,
                                                 :except => [:remote_token, :session_hijacking]
