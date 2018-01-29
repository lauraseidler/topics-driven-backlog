require 'rails_helper'

RSpec.describe 'Authentication', type: :request do

  let(:user) { create(:user, role: User.roles[:student]) }
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(LdapAuthenticator).to receive(:call).and_return(User.roles[:instructor])
  end

  # Test suite for POST /get-token
  describe 'POST /get-token' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) {
      {
          email: user.email.to_s,
          password: 'ldap-password'
      }.to_json
    }
    let(:invalid_credentials) {
      {
          email: Faker::Internet.email.to_s,
          password: ''
      }.to_json
    }

    context 'When request is valid' do
      before { post '/get-token', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
        expect(json['user']).not_to be_nil
        expect(json['user']['email']).to eq(user.email)
        expect(json['user']['id']).to eq(user.id)
        expect(json['user']['role']).to eq(user.role)
      end
    end

    context 'When request is invalid' do
      before { post '/get-token', params: invalid_credentials, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/#{Message::invalid_credentials}/)
      end
    end
  end
end
