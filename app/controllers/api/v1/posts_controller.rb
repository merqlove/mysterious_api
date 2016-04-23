module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, except: [:index, :create]

      def index
        authorize_api(:post, :index?)
        @posts = policy_scope([:api, :v1, Post]).page(params[:page])

        render json: @posts, meta: pagination_dict(@posts), include: [:owner]
      end

      def show
        authorize_api(@post)
        render json: @post, include: [:owner]
      end

      def create
        authorize_api(:post)
        @post = Post.new(owner: pundit_user)
        @post.attributes = post_params

        if @post.save
          render json: @post, include: [], status: :created
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize_api(@post)
        if @post.update(post_params)
          render json: @post, include: []
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def publish
        authorize_api(@post)
        if @post.update({status: :published})
          render json: @post, include: [], root: 'post'
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def unpublish
        authorize_api(@post)
        if @post.update({status: :unpublished})
          render json: @post, include: [], root: 'post'
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def follow
        authorize_api(@post)
        @post.users << pundit_user

        render json: @post, include: [], root: 'post'
      end

      def unfollow
        authorize_api(@post)
        @post.users.destroy(pundit_user)

        render json: @post, include: [], root: 'post'
      end

      def destroy
        authorize_api(@post)

        PostService.new(pundit_user, @post).call

        if @post.destroy
          render json: { success: true }, status: :no_content
        else
          render json: { success: false }, status: :no_content
        end
      end

      private

      def set_post
        @post = Post.friendly.find(params[:id])
      end

      def post_params
        permitted_attributes(policy_namespace(@post || Post))
      end
    end
  end
end
