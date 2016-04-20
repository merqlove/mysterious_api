class PostSerializer < ApplicationSerializer
  cache key: 'posts', expires_in: 3.hours
  attributes :title, :content, :meta_keywords, :meta_desc

  include FriendlyConcern

  belongs_to :owner, serializer: UserTinySerializer
  has_many :comments, serializer: CommentLiteSerializer
end
