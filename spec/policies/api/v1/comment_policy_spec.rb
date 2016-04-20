require 'rails_helper'

RSpec.describe Api::V1::CommentPolicy do

  let(:guest) { build(:guest) }
  let(:user) { build(:user) }
  let(:post) { create(:post) }

  subject { described_class }

  permissions :index? do
    let(:comments) { create_list(:comment, 5, post: post) }

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
    let(:comment) { create(:comment, post: post) }

    it 'grants access if user is guest' do
      expect(subject).to permit(guest, comment)
    end

    it 'grants access if user is user' do
      expect(subject).to permit(user, comment)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, comment)
    end

    it 'restricts access if invalid comment' do
      admin = build(:admin)
      expect(subject).not_to permit(admin, nil)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, comment)
    end
  end

  permissions :create? do
    let(:comment) { create(:comment, post: post) }

    it 'grants access if user' do
      expect(subject).to permit(user, comment)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, comment)
    end

    it 'restricts access if user is guest' do
      comment.user = guest
      expect(subject).not_to permit(guest, comment)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, comment)
    end
  end

  permissions :update?, :destroy? do
    let(:comment) { create(:comment, post: post) }

    it 'restricts access if user' do
      expect(subject).not_to permit(user, comment)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, comment)
    end

    it 'restricts access if invalid comment' do
      admin = build(:admin)
      expect(subject).not_to permit(admin, nil)
    end

    it 'restricts access if user is guest' do
      expect(subject).not_to permit(guest, comment)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, comment)
    end
  end
end
