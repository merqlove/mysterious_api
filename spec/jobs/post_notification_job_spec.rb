require 'rails_helper'

RSpec.describe PostNotificationJob, type: :job do
  let(:post) { create(:post) }

  it 'with success job' do
    expect {
      PostNotificationJob.perform_later(post.id)
    }.to have_enqueued_job
  end
end
