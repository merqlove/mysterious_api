class PostTinySerializer < ApplicationSerializer
  cache key: 'posts_tiny', expires_in: 3.hours
  include FriendlyConcern
end
