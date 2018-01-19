require 'rails_helper'

RSpec.describe 'Projects API' do

  let!(:course) { create(:course) }
  let(:course_id) { course.id }
  # create_list doesn't work here because we need a unique title
  let!(:projects) { create_list(:project, 20, course_id: course.id) }
  let!(:users) { create_list(:user, 2) }
  let(:id) { projects.first.id }

  # Test suite for GET /courses/:course_id
  describe 'GET /courses/:course_id with serialized projects' do
    before { get "/courses/#{course_id}" }

    context 'when course exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all course projects' do
        expect(json['projects'].size).to eq(20)
      end
    end

    context 'when course does not exist' do
      let(:course_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Course/)
      end
    end
  end

  # Test suite for POST /courses/:course_id/projects
  describe 'POST /courses/:course_id/projects' do
    let(:valid_attributes) {
      {
        title: 'Visit Narnia'
      }
    }

    context 'when request attributes are valid' do
      before { post "/courses/#{course_id}/projects", params: valid_attributes }

      it 'creates a project' do
        expect(json['title']).to eq('Visit Narnia')
        expect(json['course_id']).to eq(course_id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/courses/#{course_id}/projects", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /projects/:id
  describe 'PUT /projects/:id' do
    let(:valid_attributes) {
      {
          title: 'Learn Elm'
      }
    }
    before { put "/projects/#{id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(json['title']).to eq('Learn Elm')
        expect(json['course_id']).to eq(course_id)
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
        expect(response.body).to match(/Couldn't find Project/)
      end
    end
  end

  # Test suite for PATCH /projects/:id
  describe 'PATCH /projects/:id with user attributes' do
    let(:valid_attributes) {
      {
          user_ids: [users.first.id, users.second.id]
      }
    }
    let(:invalid_attributes) {
      {
          user_ids: [3]
      }
    }

    context 'when the record exists' do
      before { patch "/projects/#{id}", params: valid_attributes }

      it 'updates the record' do
        expect(json.size).to eq(4)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists' do
      before { patch "/projects/#{id}", params: invalid_attributes }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: User 3 does not exist/)
      end
    end
  end

  # Test suite for DELETE /projects/:id
  describe 'DELETE /projects/:id' do
    before { delete "/projects/#{id}"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
