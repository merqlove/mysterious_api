require 'rails_helper'

RSpec.describe Post::Follow, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:post_id) }

  # it { should validate_uniqueness_of(:post_id).scoped_to(:user_id) }

  it { should belong_to(:user) }
  it { should belong_to(:post) }
end
