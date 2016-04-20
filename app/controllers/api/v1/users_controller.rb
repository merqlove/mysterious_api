module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      resource_description do
        short 'Users'
        formats ['json']
        param :id, :number, :desc => 'User ID', :required => false
        api_version "1"
      end

      api :GET, '/users', 'List users'
      description 'List users with pagination support'
      param :page, :number, desc: 'Page number'
      def index
        authorize_api(:user, :index?)
        @users = policy_scope([:api, :v1, User]).page(params[:page])

        render json: @users, meta: pagination_dict(@users), include: []
      end

      api :GET, '/users/:id', 'Show user'
      description 'Show user with specifed :id'
      param :id, :number, desc: 'User id', required: true
      def show
        authorize_api(@user)
        render json: @user, include: [:followings]
      end

      def_param_group :user do
        param :user, Hash, 'User information' do
          param :login, User::USER_LOGIN_REGEX, required: true, desc: 'Title'
          param :email, User::USER_EMAIL_REGEX, desc: 'E-mail'
          param :password, String, desc: 'Password'
          param :password_confirmation, String, desc: 'Password confirmation'
        end
      end

      api :POST, '/users', 'Create user'
      description 'Create user with specifed user params'
      param_group :user
      def create
        authorize_api(:user)
        @user = User.new(user_params)

        if @user.save
          render json: @user, include: [], status: :created
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      api :POST, '/users/:id', 'Update user'
      description 'Update user with specifed user params'
      param :id, :number, desc: 'User id', required: true
      param_group :user
      def update
        authorize_api(@user)
        if @user.update(user_params)
          render json: @user, include: []
        else
          render json: { errors: @user.errors } , status: :unprocessable_entity
        end
      end

      api :DELETE, '/users/:id', 'Destroy user for admins'
      description 'Destroy user from our DB.'
      param :id, :number, desc: 'User id', required: true
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
