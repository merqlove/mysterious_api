class Post < ApplicationRecord
  POST_SLUG_REGEX = /\A[a-z0-9\-]+\z/i
  POST_TITLE_REGEX = /\A[A-ZА-Яа-яЁёa-z0-9\s_\-!\?\.,:\)\(]+\z/i

  extend FriendlyId

  friendly_id :title, :use => :slugged

  validates :slug, format: { with: POST_SLUG_REGEX }, uniqueness: true
  validates :title, presence: true, format: { with: POST_TITLE_REGEX }

  enum status: {
    unpublished: 0,
    published: 1
  }

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :comments, dependent: :destroy

  has_many :follows, class_name: 'Post::Follow', dependent: :destroy
  has_many :users, through: :follows, source: :user

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :unpublished
  end
end
