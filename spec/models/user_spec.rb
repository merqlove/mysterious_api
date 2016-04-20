require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of :password }

  it { should allow_value('jdsdnjksjg-_4sa').for(:login) }
  it { should_not allow_values(',aafffa', ':afffaa', ';sssssaaa', '=ssaaa', '!ssddsf').for(:login) }

  it { should allow_value('aaa@ddd.ru').for(:email) }
  it { should_not allow_values('aaa', 'aaa@', 'aaa@sss', 'aad@.').for(:email) }

  it { should have_secure_password }
  it { should validate_uniqueness_of(:email).allow_blank }
  it { should validate_uniqueness_of(:login).allow_blank }
  it { should validate_uniqueness_of(:authentication_token).allow_blank }

  it { should have_many(:followings).through(:follows) }
  it { should have_many(:posts) }
  it { should have_many(:comments) }

  context '.generate_authentication_token!' do
    let(:user) {create(:user) }

    it 'creates user with token' do
      expect(user.authentication_token).to be_truthy
    end

    it 'updates user with good token' do
      token = user.generate_authentication_token!
      expect(::BCrypt::Password.new(user.authentication_token) == token)
        .to be_truthy
    end
  end

  context '.role' do
    let(:user) { build(:guest) }

    it 'guest by default' do
      expect(user.role).to eq('guest')
      expect(user.guest?).to be_truthy
    end

    it 'can be guest' do
      user.role = 'guest'
      expect(user.role).to eq('guest')
      expect(user.guest?).to be_truthy
    end

    it 'can be user' do
      user.role = 'user'
      expect(user.role).to eq('user')
      expect(user.user?).to be_truthy
    end

    it 'can be admin' do
      user.role = 'admin'
      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
    end
  end

  context '.followings' do
    let(:user) { create(:user) }
    let(:post) { create(:post, owner: create(:user)) }

    it 'skip duplicate follow post' do
      user.followings << post
      expect {
        user.followings << post
      }.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it 'follow post' do
      expect {
        user.followings << post
      }.to change(user.followings, :count).to(1)
    end

    it 'follow unknown post' do
      expect {
        user.followings << nil
      }.to raise_exception(ActiveRecord::AssociationTypeMismatch)
    end

    it 'unfollow post' do
      user.followings << post

      expect {
        user.followings.destroy(post)
      }.to change(user.followings, :count).to(0)
    end

    it 'unfollow not followed post' do
      user.followings << create(:post)

      expect {
        user.followings.destroy(post)
      }.to change(user.followings, :count).by(0)
    end

    it 'unfollow unknown post' do
      user.followings << create(:post)

      expect {
        user.followings.destroy(nil)
      }.to raise_exception(ActiveRecord::AssociationTypeMismatch)
    end
  end
end
