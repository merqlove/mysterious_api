class PostPreviewSerializer < ApplicationSerializer
  cache key: 'posts_preview', expires_in: 3.hours
  include FriendlyConcern
  attributes :slug, :status, :title, :content

  def content
    object&.content&.truncate(100, '...')
  end
end
