class TokenAuthStrategy < ::Warden::Strategies::Base
  TOKEN_HEADER = 'access-token'
  LOGIN_HEADER = 'login'

  def valid?
    authentication_token && login
  end

  # Fail fast to mitigate timing attacks!
  def authenticate!
    user = User.find_by(login: login)

    if user && valid_token?(user&.authentication_token)
      success!(user)
    else
      fail!('strategies.token_auth.failed')
    end
  end

  private

  def request_headers
    @request_headers ||= ::ActionDispatch::Http::Headers.new(request)
  end

  def valid_token?(token)
    return false unless token
    ::BCrypt::Password.new(token) == authentication_token
  end

  def authentication_token
    params['access_token'] || request_headers[TOKEN_HEADER]
  end

  def login
    params['login'] || request_headers[LOGIN_HEADER]
  end
end
