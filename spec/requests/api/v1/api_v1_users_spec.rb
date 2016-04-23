require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users" do
    let(:user) { create(:admin) }

    context 'with credentials' do
      it "auth via params with token works!" do
        token = user.generate_authentication_token!
        get api_v1_users_path, params: { access_token: token, login: user.login }
        expect(response).to have_http_status(200)
      end

      it "auth via headers with token works!" do
        token = user.generate_authentication_token!
        get api_v1_users_path, params: {}, headers: { 'access-token' => token, 'login' => user.login }
        expect(response).to have_http_status(200)
      end

      context 'basic auth' do
        include AuthRequestHelper

        it 'which also works!' do
          user = create(:user, password: 'a1234567', login: 'somelogin1', role: :admin)
          http_auth_as user.login, 'a1234567' do
            auth_get api_v1_users_path
            expect(response).to have_http_status(200)
          end
        end
      end
    end

    context 'with wrong credentials' do
      it "auth via params with token works!" do
        get api_v1_users_path, params: { access_token: 'some', login: user.login }
        expect(response).to have_http_status(401)
      end

      it "auth via headers with token works!" do
        get api_v1_users_path, params: {}, headers: { 'access-token' => 'some', 'login' => user.login }
        expect(response).to have_http_status(401)
      end

      context 'basic auth' do
        include AuthRequestHelper

        it 'which also works!' do
          user = create(:user, password: 'a1234567', login: 'somelogin1', role: :admin)
          http_auth_as user.login, 'b1234568' do
            auth_get api_v1_users_path
            expect(response).to have_http_status(401)
          end
        end
      end
    end

  end
end
