module Api
  module V1
    class TokensController < ApplicationController
      skip_after_action :verify_authorized, only: [:update]

      resource_description do
        short 'Tokens'
        formats ['json']
        api_version "1"
      end

      api :POST, '/tokens', 'Update users'
      description """
        Refresh tokens for user.\n
        User can login via BasicAuth & update its token by this service.\n
        Also user can provide current :access_token, :login params to receive new token.
      """
      param :access_token, String, desc: 'Access Token'
      param :login, String, desc: 'Login'
      def update
        token = current_user.generate_authentication_token!

        render json: { access_token: token }
      end
    end
  end
end
