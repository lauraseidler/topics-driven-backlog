# Source: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-two

require 'rails_helper'

RSpec.describe AuthenticateUser do

  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new(user.email, 'ldap-pass') }
  let(:invalid_email_address) { 'user1.invalid-domain.de' }
  subject(:invalid_domain_auth_obj) { described_class.new(invalid_email_address, 'ldap-pass') }
  let(:new_valid_email_address) { "#{Faker::Internet.user_name}@#{ENV['ORGANISATION_DOMAIN']}" }
  subject(:first_login_auth_obj) { described_class.new(new_valid_email_address, 'ldap-pass') }

  # Test suite for AuthenticateUser#call
  describe 'AuthenticateUser#call' do
    context 'when valid credentials' do
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:call).and_return(User.roles[:instructor])
      }
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end
  end

  describe 'AuthenticateUser#call' do
    context 'when valid credentials but first login (user is not in database)' do
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:call).and_return(User.roles[:instructor])
      }
      it 'returns an auth token for new registered user' do
        token = first_login_auth_obj.call
        expect(token).not_to be_nil
      end
    end
  end

  describe 'AuthenticateUser#call' do
    context 'when valid credentials and right ldap group' do
      let(:valid_student_member_result) {
        { 0 => { :memberof=> [ "CN=#{DomainDefinition::USER_GROUP_STUDENT},OU=Users,DC=SomeDomain,DC=com" ] } }
      }
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:connect_to_ldap)
                                                        .and_return(valid_student_member_result)
      }
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    context 'when valid credentials and right ldap group' do
      let(:valid_instructor_member_result) {
        { 0 => { :memberof=> [ "CN=#{DomainDefinition::USER_GROUP_INSTRUCTOR},OU=Users,DC=SomeDomain,DC=com" ] } }
      }
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:connect_to_ldap)
                                                        .and_return(valid_instructor_member_result)
      }
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end
  end

  describe 'AuthenticateUser#call' do
    context 'when valid credentials but no instructor or student' do
      let(:invalid_group_member_result) {
        { 0 => { :memberof=> [ 'CN=SomeGroup,OU=Users,DC=SomeDomain,DC=com' ] } }
      }
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:connect_to_ldap)
                                                        .and_return(invalid_group_member_result)
      }
      it 'raise exception: Not authorized' do
        expect{valid_auth_obj.call}
            .to raise_exception(
                    ExceptionHandler::AuthenticationError,
                    Message.not_authorized
                )
      end
    end
  end

  describe 'AuthenticateUser#call' do
    context 'when ldap server is down' do
      before {
        allow_any_instance_of(LdapAuthenticator).to receive(:call).and_raise(
            ExceptionHandler::AuthenticationServerIsDown,
            Message.contact_the_admin
        )
      }
      it 'raise exception: contact the administrator' do
        expect{valid_auth_obj.call}
            .to raise_exception(
                    ExceptionHandler::AuthenticationServerIsDown,
                    Message.contact_the_admin
                )
      end
    end
  end

  describe 'AuthenticateUser#call' do
    context 'when invalid email address' do
      it 'raise exception: not domain email address' do
        expect{invalid_domain_auth_obj.call}
            .to raise_exception(
                    ExceptionHandler::AuthenticationError,
                    Message.not_domain_email_address(invalid_email_address)
                )
      end
    end
  end
end
