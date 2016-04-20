class PostMystificationJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    Post.friendly.find(post_id)&.destroy
  end
end
