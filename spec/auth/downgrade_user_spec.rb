require 'rails_helper'

RSpec.describe DowngradeUser do
  let(:user) { create(:user) }
  subject(:valid_downgrade_obj) { described_class.new(user, true) }

  describe 'DowngradeUser#call' do
    context 'when instructor' do
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:call).and_return(User.roles[:instructor])
      }
      it 'returns an auth token' do
        token = valid_downgrade_obj.call
        expect(token).not_to be_nil
      end
    end

  end
end
