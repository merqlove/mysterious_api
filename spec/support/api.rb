module ApiAuthHelper
  include Warden::Test::Helpers

  def sign_in(user, scope = 'user'.to_sym)
    login_as user, scope: scope
    @controller.request.headers.merge!({
      :login         => user.login,
      'access-token' => user.generate_authentication_token!
    }) if user
  end
end

RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/
  config.include ActiveModelSerializers::Test::Schema, file_path: /spec\/controllers\/api/
  config.include ApiAuthHelper, type: :controller
end
