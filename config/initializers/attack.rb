class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  whitelist('allow-localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  throttle('req/ip', limit: 50, period: 5) do |req|
    req.ip
  end

  self.blacklisted_response = lambda do |_|
    [
      403,
      {'Content-Type' => 'application/json'},
      [{error: "Forbidden\n"}.to_json]
    ]
  end

  self.throttled_response = lambda do |env|
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    [
      429,
      {'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s},
      [{error: 'Retry later.'}.to_json]
    ]
  end
end
