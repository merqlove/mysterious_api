module AuthRequestHelper
  def http_auth_as(username, password, &block)
    @env = {} unless @env
    old_auth = @env['HTTP_AUTHORIZATION']
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    yield block
    @env['HTTP_AUTHORIZATION'] = old_auth
  end

  def auth_get(url, params={}, env={})
    get url, params: params, env: @env.merge(env)
  end
end
