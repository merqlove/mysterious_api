require 'rails_helper'

RSpec.describe Api::V1::PostPolicy do

  let(:guest) { build(:guest) }
  let(:user) { build(:user) }

  subject { described_class }

  permissions :index? do
    let(:posts) { create_list(:post, 5) }

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, subject)
    end

    it 'grants access to guest' do
      expect(subject).to permit(guest, subject)
    end

    it 'grants access to user' do
      expect(subject).to permit(user, subject)
    end

    it 'restricts access to any' do
      expect(subject).not_to permit(nil, subject)
    end
  end

  permissions :show? do
    let(:post) { create(:post) }

    it 'grants access if user is guest' do
      expect(subject).to permit(guest, post)
    end

    it 'grants access if user is user' do
      expect(subject).to permit(user, post)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, post)
    end

    it 'restricts access if invalid post' do
      expect(subject).not_to permit(user, nil)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, post)
    end
  end

  permissions :follow?, :unfollow? do
    let(:post) { create(:post, status: :published) }

    it 'grants access if user' do
      expect(subject).to permit(user, post)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, post)
    end

    it 'restricts access for unpublished' do
      post.owner = user
      post.status = :unpublished
      expect(subject).not_to permit(user, post)
    end

    it 'restricts access if user is guest' do
      post.owner = guest
      expect(subject).not_to permit(guest, post)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, post)
    end
  end

  permissions :create? do
    let(:post) { create(:post) }

    it 'grants access if user' do
      expect(subject).to permit(user, post)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, post)
    end

    it 'restricts access if user is guest' do
      post.owner = guest
      expect(subject).not_to permit(guest, post)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, post)
    end
  end

  permissions :publish?, :unpublish?, :update?, :destroy? do
    let(:post) { create(:post) }

    it 'restricts access if user not owner' do
      expect(subject).not_to permit(user, post)
    end

    it 'grants access if user is owner' do
      post.owner = user
      expect(subject).to permit(user, post)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, post)
    end

    it 'restricts access if invalid post' do
      admin = build(:admin)
      expect(subject).not_to permit(admin, nil)
    end

    it 'restricts access if user is guest' do
      post.owner = guest
      expect(subject).not_to permit(guest, post)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, post)
    end
  end
end
