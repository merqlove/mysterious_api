module Api
  module V1
    class UserPolicy < ApplicationPolicy
      class Scope < Scope
        def resolve
          scope[2]
        end
      end

      def index?
        user&.admin?
      end

      def show?
        return user&.admin? if record&.admin?
        user && record_exists?
      end

      def create?
        destroy?
      end

      def update?
        return false unless record
        destroy?
      end

      def destroy?
        return false unless record
        guest_same_admin?
      end

      def permitted_attributes_for_create
        [:login, :email, :password, :password_confirmation]
      end

      def permitted_attributes
        return permitted_attributes_for_create.push(:role) if user&.admin?
        permitted_attributes_for_create
      end

      private

      def guest_same_admin?
        return false if is_guest?
        return true  if user == record
        user&.admin?
      end

      def is_guest?
        user&.guest?
      end
    end
  end
end
