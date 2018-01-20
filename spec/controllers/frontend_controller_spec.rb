require 'rails_helper'

RSpec.describe FrontendController, type: :controller do

  let(:user) { create(:user) }
  let(:headers) { valid_headers }

  describe "GET #index" do
    before { get :index, params: {}, headers: headers }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

end
