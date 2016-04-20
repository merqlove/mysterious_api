require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_most(255).is_at_least(3) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:post_id) }

  it { should belong_to(:user) }
  it { should belong_to(:post) }

  context 'runs mailer job' do
    include ActiveJob::TestHelper

    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it 'it enqueue job' do
      expect {
        Comment.create(post: post, user: user, content: 'Some text')
      }.to have_enqueued_job
    end
  end
end
