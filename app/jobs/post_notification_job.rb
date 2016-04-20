class PostNotificationJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.friendly.find(post_id)
    post&.users&.find_each do |user|
      PostMailer.notice(post, user).deliver_later
    end
  end
end
