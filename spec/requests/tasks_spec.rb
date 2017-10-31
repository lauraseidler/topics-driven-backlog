require 'rails_helper'
require 'database_cleaner'

RSpec.describe 'Tasks API' do

  let!(:story) { create(:story) }
  let!(:tasks) { create_list(:task, 20, story_id: story.id) }
  let(:story_id) { story.id }
  let(:id) { tasks.first.id }

  # Test suite for GET /stories/:story_id/tasks
  describe 'GET /stories/:story_id/tasks' do
    before { get "/stories/#{story_id}/tasks" }

    context 'when story exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all story tasks' do
        expect(json.size).to eq(20)
      end
    end

    context 'when story does not exist' do
      let(:story_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Story/)
      end
    end
  end

  # Test suite for GET /stories
  describe 'GET /tasks' do
    let!(:story_2) { create(:story) }
    let!(:tasks_2) { create_list(:task, 5, story_id: story_2.id) }
    before { get '/tasks' }

    context 'when tasks exists' do

      it 'returns tasks' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(25)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for GET /tasks/:id
  describe 'GET /tasks/:id' do
    before { get "/tasks/#{id}" }

    context 'when story task exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the task' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when story task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  # Test suite for POST /stories/:story_id/tasks
  describe 'POST /stories/:story_id/tasks' do
    let(:valid_attributes) { { title: 'Visit Narnia', description: 'wow' } }

    context 'when request attributes are valid' do
      before { post "/stories/#{story_id}/tasks", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/stories/#{story_id}/tasks", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT tasks/:id
  describe 'PUT tasks/:id' do
    let(:valid_attributes) { { title: 'Mozart' } }

    before { put "/tasks/#{id}", params: valid_attributes }

    context 'when task exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the task' do
        updated_task = Task.find(id)
        expect(updated_task.title).to match(/Mozart/)
      end
    end

    context 'when the task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  # Test suite for DELETE /tasks/:id
  describe 'DELETE /tasks/:id' do
    before { delete "/tasks/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
