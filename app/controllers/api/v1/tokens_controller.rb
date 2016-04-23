module Api
  module V1
    class TokensController < ApplicationController
      skip_after_action :verify_authorized, only: [:update]

      def update
        token = current_user.generate_authentication_token!

        render json: { access_token: token }
      end
    end
  end
end
