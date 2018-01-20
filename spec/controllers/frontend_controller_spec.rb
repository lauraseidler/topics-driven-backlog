require 'rails_helper'

RSpec.describe FrontendController, type: :controller do

  let(:user) { create(:user) }
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  describe "GET #index" do
    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

end
