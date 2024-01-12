require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    let!(:tickets) { FactoryBot.create_list(:ticket, 2, user: user) }

    context 'when user is logged in' do
      before do
        request.headers['Authorization'] = "Bearer #{user_token}"
      end

      it 'returns a list of tickets' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    private

    def user_token
      JWT.encode({user_id: user.id, exp: 1.hours.from_now.to_i}, Rails.application.secrets.secret_key)
    end
  end
end
