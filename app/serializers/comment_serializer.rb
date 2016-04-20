class CommentSerializer < ApplicationSerializer
  cache key: 'comments', expires_in: 3.hours
  attributes :id, :content

  belongs_to :post, serializer: PostTinySerializer
  belongs_to :user, serializer: UserTinySerializer
end
