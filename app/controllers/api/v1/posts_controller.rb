module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, except: [:index, :create]

      resource_description do
        short 'Posts'
        formats ['json']
        api_version '1'
      end

      api :GET, '/v1/posts', 'List posts'
      description 'List posts with pagination support'
      param :page, :number, desc: 'Page number'
      def index
        authorize_api(:post, :index?)
        @posts = policy_scope([:api, :v1, Post]).page(params[:page])

        render json: @posts, meta: pagination_dict(@posts), include: [:owner]
      end

      api :GET, '/v1/posts/:id', 'Show post'
      description 'Show post with specifed slug'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def show
        authorize_api(@post)
        render json: @post
      end

      def_param_group :post do
        param :post, Hash, 'Post information' do
          param :title, Post::POST_TITLE_REGEX, required: true, desc: 'Title'
          param :content, String, desc: 'Content'
          param :meta_keywords, String, desc: 'Meta keywords'
          param :meta_desc, String, desc: 'Meta description'
        end
      end

      api :POST, '/v1/posts', 'Create post'
      description 'Create post with params'
      param_group :post
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

      api :PUT, '/v1/posts/:id', 'Update post'
      description 'Update post with params'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      param_group :post
      def update
        authorize_api(@post)
        if @post.update(post_params)
          render json: @post, include: []
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/posts/:id/publish', 'Publish post'
      description 'Publish post to the Web.'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def publish
        authorize_api(@post)
        if @post.update({status: :published})
          render json: @post, include: [], root: 'post'
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/posts/:id/unpublish', 'Unpublish post'
      description 'Unpublish post from the Web.'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def unpublish
        authorize_api(@post)
        if @post.update({status: :unpublished})
          render json: @post, include: [], root: 'post'
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/posts/:id/follow', 'Follow post'
      description 'Follow published post.'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def follow
        authorize_api(@post)
        @post.users << pundit_user

        render json: @post, include: [], root: 'post'
      end

      api :POST, '/v1/posts/:id/unfollow', 'Unfollow post'
      description 'Unfollow post.'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def unfollow
        authorize_api(@post)
        @post.users.destroy(pundit_user)

        render json: @post, include: [], root: 'post'
      end

      api :DELETE, '/v1/posts/:id', 'Destroy post'
      description 'Destroy post from our DB.'
      param :id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
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
