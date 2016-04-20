require 'rails_helper'

RSpec.describe Api::V1::UserPolicy do

  let(:guest) { build(:guest) }
  let(:user) { build(:user) }

  subject { described_class }

  permissions :index? do
    let(:users) { create_list(:user, 5) }

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, subject)
    end

    it 'restricts access to any' do
      expect(subject).not_to permit(user, subject)
    end
  end

  permissions :show? do
    it 'grants access if user is user' do
      other_user = create(:user)
      expect(subject).to permit(user, other_user)
    end

    it 'restricts access if other user is admin' do
      other_user = create(:admin)
      expect(subject).not_to permit(guest, other_user)
    end

    it 'grants access if both users is admin' do
      other_user = create(:admin)
      admin = build(:admin)
      expect(subject).to permit(admin, other_user)
    end

    it 'grants access if user is guest' do
      other_user = create(:user)
      expect(subject).to permit(guest, other_user)
    end

    it 'restricts access if invalid user' do
      admin = build(:admin)
      expect(subject).not_to permit(admin, nil)
    end

    it 'restricts access if user is anonymous' do
      other_user = create(:user)
      expect(subject).not_to permit(nil, other_user)
    end
  end

  permissions :create?, :update?, :destroy? do
    let(:other_user) { create(:user) }

    it 'restricts access if user not the same' do
      expect(subject).not_to permit(user, other_user)
    end

    it 'grants access if user the same' do
      expect(subject).to permit(user, user)
    end

    it 'grants access if user is admin' do
      admin = build(:admin)
      expect(subject).to permit(admin, other_user)
    end

    it 'restricts access if invalid user' do
      admin = build(:admin)
      expect(subject).not_to permit(admin, nil)
    end

    it 'restricts access if user is guest' do
      expect(subject).not_to permit(guest, other_user)
    end

    it 'restricts access if both users is guest' do
      expect(subject).not_to permit(guest, guest)
    end

    it 'restricts access if user is anonymous' do
      expect(subject).not_to permit(nil, other_user)
    end
  end
end
