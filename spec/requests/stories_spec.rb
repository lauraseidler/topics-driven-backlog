require 'rails_helper'

RSpec.describe 'Stories API', type: :request do

  let!(:backlog) { create(:backlog) }
  let(:backlog_id) { backlog.id }
  let!(:stories) { create_list(:story, 10, backlog_id: backlog_id) }
  let(:story_id) { stories.first.id }

  # Test suite for GET /backlogs/:backlog_id/stories
  describe 'GET /backlogs/:backlog_id/stories' do
    # make HTTP get request before each example
    before { get "/backlogs/#{backlog_id}/stories" }

    it 'returns stories' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /backlogs/:backlog_id/stories/:id
  describe 'GET /backlogs/:backlog_id/stories/:id' do
    before { get "/backlogs/#{backlog_id}/stories/#{story_id}" }

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

  # Test suite for POST /backlogs/:backlog_id/stories
  describe 'POST /backlogs/:backlog_id/stories' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm', description: 'Foobar' } }

    context 'when the request is valid' do
      before { post "/backlogs/#{backlog_id}/stories", params: valid_attributes }

      it 'creates a story' do
        expect(json['title']).to eq('Learn Elm')
        expect(json['description']).to eq('Foobar')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/backlogs/#{backlog_id}/stories", params: { description: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /backlogs/:backlog_id/stories/:id
  describe 'PUT /backlogs/:backlog_id/stories/:id' do
    let(:valid_attributes) { { title: 'Shopping', description: 'Foobar' } }
    before { put "/backlogs/#{backlog_id}/stories/#{story_id}", params: valid_attributes }

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

  # Test suite for PATCH /backlogs/:backlog_id/stories/:id
  describe 'PATCH /backlogs/:backlog_id/stories/:id' do
    let(:first_story) {stories.first}
    let(:last_story) {stories.last}
    let(:position_attribute) { { position: 1 } }
    before { patch "/backlogs/#{backlog_id}/stories/#{last_story.id}", params: position_attribute }

    context 'updating the last story of the backlog' do

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'updating the last story of the backlog' do
      before { get "/backlogs/#{backlog_id}/stories/#{last_story.id}" }

      it 'returns the first position' do
        expect(json['position']).to eq(1)
      end
    end

    context 'updating the last story of the backlog to the first position' do
      before { get "/backlogs/#{backlog_id}/stories/#{first_story.id}" }

      it 'leads to the second position for the former first one' do
        expect(json['position']).to eq(2)
      end
    end
  end

  # Test suite for DELETE /backlogs/:backlog_id/stories/:id
  describe 'DELETE /backlogs/:backlog_id/stories/:id' do
    before { delete "/backlogs/#{backlog_id}/stories/#{story_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end