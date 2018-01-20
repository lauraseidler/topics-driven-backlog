require 'rails_helper'

RSpec.describe 'Authentication', type: :request do

  # Test suite for POST /get-token
  describe 'POST /get-token' do
    let!(:user) { create(:user) }
    let(:valid_credentials) {
      {
          HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'ldap-password')
      }
    }
    let(:invalid_credentials) {
      {
          HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user.email, '')
      }
    }

    # set request.headers to our custon headers
    # before { allow(request).to receive(:headers).and_return(headers) }

    context 'When request is valid' do
      before { post '/get-token', params: {}, headers: valid_credentials }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      before { post '/get-token', params: {}, headers: invalid_credentials }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/#{Message::invalid_credentials}/)
      end
    end
  end
end
