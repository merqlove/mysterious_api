require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do

  describe 'PUT #update' do
    it 'returns http success with token' do
      user = create(:user)
      sign_in user
      put :update
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['access_token']).to be_truthy
    end

    it 'returns http 401' do
      put :update
      expect(response).to have_http_status(401)
    end
  end

end
