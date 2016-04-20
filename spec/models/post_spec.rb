require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:title) }
  it { should allow_value('a:az(A)Я ,.а1!?').for(:title) }
  it { should_not allow_values(';', '=').for(:title) }

  it { should allow_value('aaz-1avbqru4-d').for(:slug) }
  it { should_not allow_values(',', ':', ';', '=', '_').for(:slug) }

  it { should validate_uniqueness_of(:slug) }

  it { should belong_to(:owner).class_name('User') }
  it { should have_many(:users).through(:follows) }
  it { should have_many(:comments) }

  context '.status' do
    let(:post) { build(:post) }

    it 'unpublished by default' do
      expect(post.status).to eq('unpublished')
      expect(post.unpublished?).to be_truthy
    end

    it 'can be published' do
      post.status = 'published'
      expect(post.status).to eq('published')
      expect(post.published?).to be_truthy
    end
  end
end
