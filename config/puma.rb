# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }

preload_app!

# The file that gets logged to.
stdout_redirect "./log/puma.development.log", "./log/puma.development.err.log"

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

on_worker_boot do
  # Don't bother having the master process hang onto older connections.
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection

  Rails.cache&.reconnect if Rails.cache.respond_to?(:reconnect)
end
