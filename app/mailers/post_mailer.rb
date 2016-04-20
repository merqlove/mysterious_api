class PostMailer < ApplicationMailer
  def notice(post, user)
    @user = user
    @post = post
    mail(to: @user.email, subject: I18n.t('mailers.new_post.subject'))
  end
end
