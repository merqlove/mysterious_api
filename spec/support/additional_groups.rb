RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, file_path: /spec\/services/
  config.include RSpec::Rails::RequestExampleGroup, file_path: /spec\/lib\/middlewares/
end
