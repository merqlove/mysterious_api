class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, length: 3..255, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true

  after_create :notify_followers

  private

  def notify_followers
    PostNotificationJob.perform_later(post.id)
  end
end
