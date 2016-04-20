class UserTinySerializer < ApplicationSerializer
  cache key: 'users_tiny', expires_in: 3.hours
  attributes :login
end
