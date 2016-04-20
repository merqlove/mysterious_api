module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_post
      before_action :set_comment, only: [:show, :update, :destroy]

      resource_description do
        short 'Comments'
        formats ['json']
        param :id, :number, :desc => 'Comment ID', :required => false
        param :post_id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
        api_version "1"
      end

      api :GET, '/posts/:post_id/comments', 'List post comments'
      description 'List Comments of the Post with pagination support'
      param :page, :number, desc: 'Page number'
      param :post_id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def index
        authorize_api(:comment, :index?)
        @comments = @post.comments
                         .page(params[:page])

        render json: @comments, meta: pagination_dict(@comments)
      end

      api :GET, '/posts/:post_id/comments/:id', 'Show comment'
      description 'Show comment for the specifed post'
      param :id, :number, desc: 'Comment id', required: true
      param :post_id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def show
        authorize_api(@comment)
        render json: @comment
      end

      def_param_group :comment do
        param :comment, Hash, 'Comment information', required: true do
          param :content, String, desc: 'Content', required: true
        end
      end

      api :POST, '/post/:post_id/comments', 'Create comment'
      description 'Create comment for the post with params'
      param :post_id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      param_group :comment
      def create
        authorize_api(:comment)
        @comment = @post.comments.build(user: pundit_user)
        @comment.attributes = comment_params

        if @comment.save
          render json: @comment, include: [], status: :created
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      api :PUT, '/post/:post_id/comments/:id', 'Update comment'
      description 'Update comment for the specified post with params'
      param :id, :number, desc: 'Comment id', required: true
      param :post_id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      param_group :comment
      def update
        authorize_api(@comment)
        if @comment.update(comment_params)
          render json: @comment, include: []
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      api :DELETE, '/posts/:post_id/comments/:id', 'Destroy comment'
      description 'Destroy comment from our DB.'
      param :id, :number, desc: 'Comment id', required: true
      param :post_id, Post::POST_SLUG_REGEX, desc: 'Post slug', required: true
      def destroy
        authorize_api(@comment)
        if @comment.destroy
          render json: { success: true }, status: :no_content
        else
          render json: { success: false }, status: :no_content
        end
      end

      private

      def set_post
        @post = policy_scope([:api, :v1, Post])
                  .friendly.find(params[:post_id])
      end

      def set_comment
        @comment = Comment.find_by(id: params[:id], post_id: @post.id)
      end

      def comment_params
        permitted_attributes(policy_namespace(@comment || Comment))
      end
    end
  end
end
