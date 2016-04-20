require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:post) { create(:post, owner: admin) }

  it 'with notice' do
    email = PostMailer.notice(post, user)
    expect{email.deliver_now}.to change(ActionMailer::Base.deliveries, :size).by(1)

    expect(email).to deliver_to(user.email)
    expect(email).to deliver_from('from@example.com')
    expect(email).to have_subject('Read new Post on mysteryous Blog!')
    # assert_equal read_fixture('notice').join, email.body.to_s
    # expect(email).to have_body_text read_fixture('notice').join
  end
end
