Apipie.configure do |config|
  config.app_name                = 'Mysterious API'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/docs'
  config.validate                = false

  config.copyright = '&copy; 2016 Alexander Merkulov'

  config.app_info['1.0'] = "
    Mysterious application wich gives you ability to change posts in your mind :)
  "

  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
end
