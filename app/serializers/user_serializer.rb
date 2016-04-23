class UserSerializer < ApplicationSerializer
  cache key: 'users', expires_in: 3.hours
  attributes :login, :email, :role
  attributes :id

  def is_owner?
    is_admin? || current_user == object
  end

  has_many :followings, serializer: PostPreviewSerializer
end
