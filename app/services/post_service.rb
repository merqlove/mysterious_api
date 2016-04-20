class PostService
  attr_reader :user, :post

  def initialize(user, post)
    @post = post
    @user = user
  end

  def call
    PostMystificationJob
      .set(wait: 1.day).perform_later(post.id) if is_admin_and_post?
  end

  private

  def is_admin_and_post?
    user && user&.admin? && post.present?
  end
end
