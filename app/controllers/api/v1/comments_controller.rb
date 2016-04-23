module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_post, only: [:index_for_post, :create]
      before_action :set_comment, only: [:show, :update, :destroy]

      def index
        authorize_api(:comment, :index?)
        @comments = policy_scope([:api, :v1, Comment]).page(params[:page])

        render json: @comments, meta: pagination_dict(@comments)
      end

      def index_for_post
        authorize_api(:comment, :index?)
        @comments = @post.comments
                         .page(params[:page])

        render json: @comments, meta: pagination_dict(@comments)
      end

      def show
        authorize_api(@comment)
        render json: @comment
      end

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

      def update
        authorize_api(@comment)
        if @comment.update(comment_params)
          render json: @comment, include: []
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

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
        @comment = Comment.find_by(id: params[:id])
      end

      def comment_params
        permitted_attributes(policy_namespace(@comment || Comment))
      end
    end
  end
end
