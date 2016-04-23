require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  include_context 'api_v1'
  
  let(:valid_attributes) {
    { login: 'eee', email: 'bbb@ddd.ru', password: 'a12344556', password_confirmation: 'a12344556'}
  }

  let(:invalid_attributes) {
    { email: 'aaa', password: '', login: '^&%$&' }
  }

  let(:valid_session) { {} }

  def match_users_error
    match_response_schema(parent: 'user', definition: 'errors_object')
  end

  describe "GET #index" do
    it "assigns all users as @users" do
      user = create(:admin)
      sign_in user
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:users)).to eq([user])
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "GET #show" do
    it "assigns the requested user as @user" do
      user = create(:user)
      sign_in user
      get :show, params: {:id => user.to_param}, session: valid_session
      expect(response).to have_http_status(:success)
      expect(assigns(:user)).to eq(user)
      assert_schema_conform
    end

    it "restricts access to unauthorised" do
      user = create(:user)
      get :show, params: {:id => user.to_param}, session: valid_session
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        user = create(:admin)
        sign_in user
        expect {
          post :create, params: {:user => valid_attributes}, session: valid_session
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(201)
        assert_schema_conform
      end

      it "assigns a newly created user as @user" do
        user = create(:admin)
        sign_in user
        post :create, params: {:user => valid_attributes}, session: valid_session
        expect(response).to have_http_status(201)
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
        assert_schema_conform
      end

      it "restricts access to guests" do
        user = create(:guest)
        sign_in user
        post :create, params: {:user => valid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        match_shared_error
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        user = create(:admin)
        sign_in user
        post :create, params: {:user => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(422)
        expect(assigns(:user)).to be_a_new(User)
        match_users_error
      end

      it "restricts access to guests" do
        user = create(:guest)
        sign_in user
        post :create, params: {:user => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        match_shared_error
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the logged in user" do
        user = create(:user)
        sign_in user
        put :update, params: {:id => user.to_param, :user => valid_attributes}, session: valid_session
        user.reload
        expect(response).to have_http_status(200)
        expect(assigns(:user)).to eq(user)
        assert_schema_conform
      end

      it "assigns the requested user as @user" do
        admin = create(:admin)
        user = create(:user)
        sign_in admin
        put :update, params: {:id => user.to_param, :user => valid_attributes}, session: valid_session
        user.reload
        expect(response).to have_http_status(200)
        expect(assigns(:user)).to eq(user)
        assert_schema_conform
      end

      it "restricts access for the guests" do
        user = create(:guest)
        sign_in user
        put :update, params: {:id => user.to_param, :user => valid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        expect(assigns(:user)).to eq(user)
        match_shared_error
      end
    end

    context "with invalid params" do
      it "assigns the user as @user" do
        user = create(:user)
        sign_in user
        put :update, params: {:id => user.to_param, :user => invalid_attributes}, session: valid_session
        expect(assigns(:user)).to eq(user)
        expect(response).to have_http_status(422)
        match_users_error
      end

      it "restricts access for the guests" do
        user = create(:guest)
        sign_in user
        put :update, params: {:id => user.to_param, :user => invalid_attributes}, session: valid_session
        expect(response).to have_http_status(403)
        expect(assigns(:user)).to eq(user)
        match_shared_error
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      admin = create(:admin)
      user = create(:user)
      sign_in admin
      expect {
        delete :destroy, params: {:id => user.to_param}, session: valid_session
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(204)
      match_shared_success
    end

    it "destroys the same user" do
      user = create(:user)
      sign_in user
      expect {
        delete :destroy, params: {:id => user.to_param}, session: valid_session
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(204)
      match_shared_success
    end

    it "restricts for guest" do
      user = create(:guest)
      sign_in user
      expect {
        delete :destroy, params: {:id => user.to_param}, session: valid_session
      }.to change(User, :count).by(0)
      expect(response).to have_http_status(403)
      match_shared_error
    end
  end

end
