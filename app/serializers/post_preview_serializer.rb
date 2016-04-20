class PostPreviewSerializer < ApplicationSerializer
  cache key: 'posts_preview', expires_in: 3.hours
  include FriendlyConcern
  attributes :title, :content

  def content
    object&.content&.truncate(255, '...')
  end
end
