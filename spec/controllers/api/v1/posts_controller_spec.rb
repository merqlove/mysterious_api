require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  include_context 'api_v1'

  let(:valid_attributes) {
    { title: 'eee', content: 'Some content', meta_keywords: 'some keywords', meta_desc: 'some desc'}
  }

  let(:invalid_attributes) {
    { title: '=fkalg'  }
  }

  let(:valid_session) { {} }

  def match_posts_error
    match_response_schema(parent: 'post', definition: 'errors_object')
  end

  describe "GET #index" do
    it "assigns all posts as @posts" do
      user = create(:user)
      post = create(:post)
      sign_in user
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:posts)).to eq([post])
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "GET #show" do
    it "assigns the requested post as @post" do
      user = create(:user)
      post = create(:post)
      sign_in user
      get :show, params: {:id => post.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:post)).to eq(post)
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      post = create(:post)
      get :show, params: {:id => post.to_param}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Post" do
        user = create(:user)
        sign_in user
        expect {
          post :create, params: {:post => valid_attributes}, session: valid_session
        }.to change(Post, :count).by(1)
        expect(response).to have_http_status(201)
        assert_schema_conform
      end

      it "assigns a newly created post as @post" do
        user = create(:user)
        sign_in user
        post :create, params: {:post => valid_attributes}, session: valid_session
        expect(response).to have_http_status(201)
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
        assert_schema_conform
      end

      it "restricts access to guests" do
        user = create(:guest)
        sign_in user
        post :create, params: {:post => valid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        match_shared_error
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        user = create(:admin)
        sign_in user
        post :create, params: {:post => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(422)
        expect(assigns(:post)).to be_a_new(Post)
        match_posts_error
      end

      it "restricts access to guests" do
        user = create(:guest)
        sign_in user
        post :create, params: {:post => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        match_shared_error
      end
    end
  end

  describe "PUT #update" do
    let(:post_obj) { create(:post) }

    context "with valid params" do
      it "updates the requested post" do
        user = create(:user)
        sign_in user
        post_obj.update(owner: user)
        put :update, params: {:id => post_obj.to_param, :post => valid_attributes}, session: valid_session
        post_obj.reload
        expect(response).to have_http_status(200)
        expect(assigns(:post)).to eq(post_obj)
        assert_schema_conform
      end

      it "assigns the requested post as admin" do
        user = create(:admin)
        sign_in user
        put :update, params: {:id => post_obj.to_param, :post => valid_attributes}, session: valid_session
        post_obj.reload
        expect(response).to have_http_status(200)
        expect(assigns(:post)).to eq(post_obj)
        assert_schema_conform
      end

      it "restricts access for the guests" do
        user = create(:guest)
        sign_in user
        post_obj.update(owner: user)
        put :update, params: {:id => post_obj.to_param, :post => valid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        expect(assigns(:post)).to eq(post_obj)
        match_shared_error
      end
    end

    context "with invalid params" do
      it "assigns the post as @post" do
        user = create(:admin)
        sign_in user
        post_obj.update(owner: user)
        put :update, params: {:id => post_obj.to_param, :post => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(422)
        expect(assigns(:post)).to eq(post_obj)
        match_posts_error
      end

      it "restricts access for the guests" do
        user = create(:guest)
        sign_in user
        put :update, params: {:id => post_obj.to_param, :post => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        expect(assigns(:post)).to eq(post_obj)
        match_shared_error
      end
    end
  end

  describe "POST #publish" do
    it "returns published post with http success" do
      user = create(:user)
      sign_in user
      post_obj = create(:post, owner: user)
      post :publish, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      post_obj.reload
      expect(post_obj.published?).to be_truthy
      assert_schema_conform
    end

    it "restricts access to guests" do
      user = create(:guest)
      sign_in user
      post_obj = create(:post, owner: user)
      post :publish, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(403)
      post_obj.reload
      expect(post_obj.published?).to be_falsey
      match_shared_error
    end
  end

  describe "POST #unpublish" do
    it "returns unpublished post with http success" do
      user = create(:user)
      sign_in user
      post_obj = create(:post, owner: user, status: :published)
      post :unpublish, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      post_obj.reload
      expect(post_obj.published?).to be_falsey
      assert_schema_conform
    end

    it "restricts access to guests" do
      user = create(:guest)
      sign_in user
      post_obj = create(:post, owner: user, status: :published)
      post :unpublish, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(403)
      post_obj.reload
      expect(post_obj.published?).to be_truthy
      match_shared_error
    end
  end

  describe "POST #follow" do
    it "returns followed post with http success" do
      user = create(:user)
      admin = create(:admin)
      sign_in user
      post_obj = create(:post, owner: admin, status: :published)
      post :follow, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      post_obj.reload
      expect(post_obj.users.exists?(user.id)).to be_truthy
      assert_schema_conform
    end

    it "restricts access to unpublished" do
      user = create(:user)
      admin = create(:admin)
      sign_in user
      post_obj = create(:post, owner: admin)
      post :follow, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(403)
      post_obj.reload
      expect(post_obj.users.exists?(user.id)).to be_falsey
      match_shared_error
    end

    it "restricts access to guests" do
      user = create(:guest)
      admin = create(:admin)
      sign_in user
      post_obj = create(:post, owner: admin, status: :published)
      post :follow, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(403)
      post_obj.reload
      expect(post_obj.users.exists?(user.id)).to be_falsey
      match_shared_error
    end
  end

  describe "POST #unfollow" do
    it "returns unfollowed post with http success" do
      user = create(:user)
      admin = create(:admin)
      sign_in user
      post_obj = create(:post, owner: admin, status: :published)
      post_obj.users << user
      post :unfollow, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      post_obj.reload
      expect(post_obj.users.exists?(user.id)).to be_falsey
      assert_schema_conform
    end

    it "restricts access to unpublished" do
      user = create(:user)
      admin = create(:admin)
      sign_in user
      post_obj = create(:post, owner: admin)
      post_obj.users << user
      post :unfollow, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(403)
      post_obj.reload
      expect(post_obj.users.exists?(user.id)).to be_truthy
      match_shared_error
    end

    it "restricts access to guests" do
      user = create(:guest)
      admin = create(:admin)
      sign_in user
      post_obj = create(:post, owner: admin, status: :published)
      post_obj.users << user
      post :unfollow, params: {:id => post_obj.to_param}, session: valid_session
      expect(response).to have_http_status(403)
      post_obj.reload
      expect(post_obj.users.exists?(user.id)).to be_truthy
      match_shared_error
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested post as admin" do
      admin = create(:admin)
      post = create(:post)
      sign_in admin
      expect {
        delete :destroy, params: {:id => post.to_param}, session: valid_session
      }.to change(Post, :count).by(-1)
      expect(response).to have_http_status(204)
      match_shared_success
    end

    it "destroys the requested post as owner" do
      user = create(:user)
      post = create(:post, owner: user)
      sign_in user
      expect {
        delete :destroy, params: {:id => post.to_param}, session: valid_session
      }.to change(Post, :count).by(-1)
      expect(response).to have_http_status(204)
      match_shared_success
    end

    it "restricts for guest" do
      user = create(:guest)
      post = create(:post)
      sign_in user
      expect {
        delete :destroy, params: {:id => post.to_param}, session: valid_session
      }.to change(Post, :count).by(0)
      expect(response).to have_http_status(403)
      match_shared_error
    end
  end

end
