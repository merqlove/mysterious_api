module Api
  module V1
    class ApplicationPolicy < ::ApplicationPolicy
      class Scope < Scope
        def resolve
          scope[2]
        end
      end

      def initialize(user, record)
        @user = user
        @record = record.is_a?(Array) ? record.last : record
      end

      def scope
        Pundit.policy_scope!(user, [:api, :v1, record.class]) if record
      end
    end
  end
end
