require 'rails_helper'

RSpec.describe 'Backlogs API', type: :request do

  let!(:backlogs) { create_list(:backlog, 10) }
  let!(:backlog) { backlogs.first }
  let(:id) { backlog.id }

  # Test suite for GET /backlogs/:id
  describe 'GET /backlogs/:id' do
    before { get "/backlogs/#{id}" }

    context 'when the record exists' do
      it 'returns the backlog' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Backlog/)
      end
    end
  end

  # Test suite for POST /backlogs
  describe 'POST /backlogs' do
    # valid payload
    let(:valid_attributes) { {} }

    context 'when the request is valid' do
      before { post '/backlogs', params: valid_attributes }

      it 'creates a backlog' do
        expect(json['created_at']).not_to be_empty
        expect(json['updated_at']).not_to be_empty
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  # Test suite for PUT /backlogs/:id
  describe 'PUT /backlogs/:id' do
    let(:valid_attributes) { {} }
    before { put "/backlogs/#{id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Backlog/)
      end
    end
  end

  # Test suite for DELETE /backlogs/:id
  describe 'DELETE /backlogs/:id' do
    before { delete "/backlogs/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
