RSpec.configure do |config|
  config.include ActiveJob::TestHelper, type: :job
  ActiveJob::Base.queue_adapter = :test
end
