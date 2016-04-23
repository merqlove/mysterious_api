module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        authorize_api(:user, :index?)
        @users = policy_scope([:api, :v1, User]).page(params[:page])

        render json: @users, meta: pagination_dict(@users), include: []
      end

      def show
        authorize_api(@user)
        render json: @user, include: [:followings]
      end

      def create
        authorize_api(:user)
        @user = User.new(user_params)

        if @user.save
          render json: @user, include: [], status: :created
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize_api(@user)
        if @user.update(user_params)
          render json: @user, include: []
        else
          render json: { errors: @user.errors } , status: :unprocessable_entity
        end
      end

      def destroy
        authorize_api(@user)
        if @user.destroy
          render json: { success: true }, status: :no_content
        else
          render json: { success: false }, status: :no_content
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          permitted_attributes(policy_namespace(@user || User))
        end
    end
  end
end
