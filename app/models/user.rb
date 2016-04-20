class User < ApplicationRecord
  include TokenAuth

  USER_EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/
  USER_LOGIN_REGEX = /\A[a-z0-9_\-]+\z/

  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  has_many :follows, class_name: 'Post::Follow', dependent: :destroy
  has_many :followings, through: :follows, source: :post

  validates_presence_of   :email
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  validates_format_of     :email, with: USER_EMAIL_REGEX, allow_blank: true

  validates_uniqueness_of :authentication_token, allow_blank: true

  validates_uniqueness_of :login, allow_blank: true
  validates_format_of     :login, with: USER_LOGIN_REGEX, allow_blank: true

  enum role: {
    guest: 0,
    user: 1,
    admin: 2
  }

  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :guest
  end
end
