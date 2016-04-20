module Api
  module V1
    class CommentPolicy < ApplicationPolicy
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

      def create?
        return false if is_guest?
        user.present?
      end

      def update?
        destroy?
      end

      def destroy?
        guest_user_admin?
      end

      def permitted_attributes
        return default_permitted_attributes.push(:user_id) if user&.admin?
        default_permitted_attributes
      end

      private

      def default_permitted_attributes
        [:content]
      end

      def is_guest?
        user&.guest?
      end

      def guest_user_admin?
        return false unless record
        return false if     is_guest?
        return true  if     user == record&.user
        user&.admin?
      end
    end
  end
end
