require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do
  include_context 'api_v1'

  describe 'PUT #update' do
    it 'returns http success with token' do
      user = create(:user)
      sign_in user
      put :update
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['access_token']).to be_truthy
      assert_schema_conform
    end

    it 'returns http 401' do
      put :update
      expect(response).to have_http_status(401)
      match_shared_error
    end
  end

end
