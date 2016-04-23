require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  include_context 'api_v1'

  let(:valid_attributes) {
    { content: 'eehe'}
  }

  let(:invalid_attributes) {
    { content: 'aa'  }
  }

  let(:valid_session) { {} }



  def match_comments_error
    match_response_schema(parent: 'comment', definition: 'errors_object')
  end

  describe "GET #index" do

    it "assigns all comments as @comments" do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post: post, user: user)
      sign_in user
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:comments)).to eq([comment])
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      post = create(:post)
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "GET #index_for_post" do
    it "assigns all comments as @comments" do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post: post, user: user)
      sign_in user
      get :index_for_post, params: {:post_id => post.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:comments)).to eq([comment])
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      post = create(:post)
      get :index_for_post, params: {:post_id => post.to_param}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "GET #show" do
    it "assigns the requested comment as @comment" do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post: post, user: user)
      sign_in user
      get :show, params: {:id => comment.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:comment)).to eq(comment)
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      post = create(:post)
      user = create(:user)
      comment = create(:comment, post: post, user: user)
      get :show, params: {:id => comment.to_param}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "GET #create" do
    context "with valid params" do
      it "creates a new Comment" do
        user = create(:user)
        post_obj = create(:post, owner: user)
        sign_in user
        expect {
          post :create, params: {:post_id => post_obj.to_param, 
                                 :comment => valid_attributes}, session: valid_session
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(201)
        assert_schema_conform
      end

      it "assigns a newly created comment as @comment" do
        user = create(:user)
        post_obj = create(:post, owner: user)
        sign_in user
        post :create, params: {:post_id => post_obj.to_param, 
                               :comment => valid_attributes}, session: valid_session
        expect(response).to have_http_status(201)
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
        assert_schema_conform
      end

      it "restricts access to guests" do
        user = create(:guest)
        post_obj = create(:post, owner: user)
        sign_in user
        post :create, params: {:post_id => post_obj.to_param,
                               :comment => valid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        match_shared_error
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        user = create(:admin)
        post_obj = create(:post, owner: user)
        sign_in user
        post :create, params: {:post_id => post_obj.to_param, 
                               :comment => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(422)
        expect(assigns(:comment)).to be_a_new(Comment)
        match_comments_error
      end

      it "restricts access to guests" do
        user = create(:guest)
        post_obj = create(:post, owner: user)
        sign_in user
        post :create, params: {:post_id => post_obj.to_param, 
                               :comment => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        match_shared_error
      end
    end
  end

  describe "GET #update" do
    let(:post_obj) { create(:post) }

    context "with valid params" do
      it "updates the requested comment" do
        user = create(:user)
        sign_in user
        post_obj.update(owner: user)
        comment = create(:comment, post: post_obj, user: user)
        put :update, params: {:id => comment.to_param, 
                              :post_id => post_obj.to_param, 
                              :comment => valid_attributes}, session: valid_session
        comment.reload
        expect(response).to have_http_status(200)
        expect(assigns(:comment)).to eq(comment)
        assert_schema_conform
      end

      it "assigns the requested comment as admin" do
        user = create(:admin)
        admin = create(:admin)
        comment = create(:comment, post: post_obj, user: user)
        sign_in admin
        put :update, params: {:id => comment.to_param,
                              :post_id => post_obj.to_param,
                              :comment => valid_attributes}, session: valid_session
        comment.reload
        expect(response).to have_http_status(200)
        expect(assigns(:comment)).to eq(comment)
        assert_schema_conform
      end

      it "restricts access for the guests" do
        user = create(:guest)
        sign_in user
        post_obj.update(owner: user)
        comment = create(:comment, post: post_obj, user: user)
        put :update, params: {:id => comment.to_param,
                              :post_id => post_obj.to_param,
                              :post => valid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        expect(assigns(:comment)).to eq(comment)
        match_shared_error
      end
    end

    context "with invalid params" do
      it "assigns the post as @post" do
        user = create(:admin)
        sign_in user
        post_obj.update(owner: user)
        comment = create(:comment, post: post_obj, user: user)
        put :update, params: {:id => comment.to_param,
                              :post_id => post_obj.to_param,
                              :comment => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(422)
        expect(assigns(:comment)).to eq(comment)
        match_comments_error
      end

      it "restricts access for the guests" do
        user = create(:guest)
        sign_in user
        comment = create(:comment, post: post_obj, user: user)
        put :update, params: {:id => comment.to_param,
                              :post_id => post_obj.to_param,
                              :comment => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        expect(assigns(:comment)).to eq(comment)
        match_shared_error
      end
    end
  end

  describe "DELETE #destroy" do

    it "destroys the requested post as admin" do
      admin = create(:admin)
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post: post, user: user)
      sign_in admin
      expect {
        delete :destroy, params: {:id => comment.to_param, :post_id => post.to_param}, session: valid_session
      }.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(204)
      assert_schema_conform
    end

    it "destroys the requested comment as user" do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, post: post, user: user)
      sign_in user
      expect {
        delete :destroy, params: {:id => comment.to_param, :post_id => post.to_param}, session: valid_session
      }.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(204)
      assert_schema_conform
    end

    it "restricts for guest" do
      guest = create(:guest)
      user = create(:guest)
      post = create(:post)
      comment = create(:comment, post: post, user: user)
      sign_in guest
      expect {
        delete :destroy, params: {:id => comment.to_param, :post_id => post.to_param}, session: valid_session
      }.to change(Comment, :count).by(0)
      expect(response).to have_http_status(403)
      match_shared_error
    end
  end

end
