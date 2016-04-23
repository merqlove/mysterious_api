load 'lib/tasks/schema.rake'

module ApiAuthHelper
  include Warden::Test::Helpers

  def sign_in(user, scope = 'user'.to_sym)
    login_as user, scope: scope
    @controller.request.headers.merge!({
      :login         => user.login,
      'access-token' => user.generate_authentication_token!
    }) if user
  end

  def match_shared_schema(definition)
    match_response_schema(parent: 'shared', definition: definition)
  end

  def match_shared_error
    match_shared_schema('default_error_string')
  end

  def match_shared_success
    match_shared_schema('default_success_boolean')
  end

  def match_response_schema(**opts)
    expect(response).to match_json_schema(opts)
  end
end

RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/
  config.include ActiveModelSerializers::Test::Schema, file_path: /spec\/controllers\/api/
  config.include Committee::Test::Methods, file_path: /spec\/controllers\/api/
  config.include ApiAuthHelper, type: :controller
end
