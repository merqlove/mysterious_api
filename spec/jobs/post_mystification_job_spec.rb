require 'rails_helper'

RSpec.describe PostMystificationJob, type: :job do
  let(:post) { create(:post) }

  it 'with success job' do
    expect {
      PostMystificationJob.perform_later(post.id)
    }.to have_enqueued_job
  end
end
