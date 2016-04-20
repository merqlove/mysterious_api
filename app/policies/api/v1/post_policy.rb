module Api
  module V1
    class PostPolicy < ApplicationPolicy
      class Scope < Scope
        def resolve
          scope[2]
        end
      end

      def index?
        user.present?
      end

      def show?
        user && record_exists?
      end

      def publish?
        destroy?
      end

      def unpublish?
        destroy?
      end

      def follow?
        return false unless is_published?
        create?
      end

      def unfollow?
        follow?
      end

      def create?
        return false if is_guest?
        user.present?
      end

      def update?
        destroy?
      end

      def destroy?
        guest_owner_admin?
      end

      def permitted_attributes
        return default_permitted_attributes.push(:user_id) if user&.admin?
        default_permitted_attributes
      end

      private

      def is_published?
        record&.published?
      end

      def default_permitted_attributes
        [:title, :content, :meta_keywords, :meta_desc]
      end

      def is_guest?
        user&.guest?
      end

      def guest_owner_admin?
        return false unless record
        return false if     is_guest?
        return true  if     user == record&.owner
        user&.admin?
      end
    end
  end
end
