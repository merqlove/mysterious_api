require 'rails_helper'

RSpec.describe PostService do
  include ActiveJob::TestHelper

  let(:post) { create(:post) }
  let(:user) { build(:admin) }
  subject   { described_class.new(user, post) }

  it 'sets job on call' do
    expect { subject.call }.to have_enqueued_job
  end
end
