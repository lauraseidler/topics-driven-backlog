# Source: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-two

require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new(user.email, 'ldap-pass') }

  # Test suite for AuthenticateUser#call
  describe 'AuthenticateUser#call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end
  end
end