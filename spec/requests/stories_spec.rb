require 'rails_helper'

RSpec.describe 'Stories API', type: :request do

  let!(:stories) { create_list(:story, 10) }
  let(:story_id) { stories.first.id }

  # Test suite for GET /stories
  describe 'GET /stories' do
    # make HTTP get request before each example
    before { get '/stories' }

    it 'returns stories' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /stories/:id
  describe 'GET /stories/:id' do
    before { get "/stories/#{story_id}" }

    context 'when the record exists' do
      it 'returns the story' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(story_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:story_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Story/)
      end
    end
  end

  # Test suite for POST /stories
  describe 'POST /stories' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm' } }

    context 'when the request is valid' do
      before { post '/stories', params: valid_attributes }

      it 'creates a story' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/stories', params: { description: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /stories/:id
  describe 'PUT /stories/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }
    before { put "/stories/#{story_id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      let(:story_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Story/)
      end
    end
  end

  # Test suite for DELETE /stories/:id
  describe 'DELETE /stories/:id' do
    before { delete "/stories/#{story_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end