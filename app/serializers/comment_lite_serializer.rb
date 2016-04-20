class CommentLiteSerializer < CommentSerializer
  cache key: 'comments_lite', expires_in: 3.hours

  def content
    object&.content&.truncate(50, '...')
  end
end
