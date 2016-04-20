# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview
  def notice
    user = User.create(email: 'some@email.com',
                       login: 'somelogin',
                       password: 'password')
    post = Post.create(
      title: 'some',
      content: 'Some',
      meta_desc: 'SEO Desc',
      meta_keywords: 'SEO Keywords',
      owner: user
    )
    user.followings << post
    PostMailer.notice post
    post.destroy
    user.destroy
  end
end
