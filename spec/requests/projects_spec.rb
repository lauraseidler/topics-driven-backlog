require 'rails_helper'

RSpec.describe 'Projects API' do

  let(:user) { create(:user, role: User.roles[:student]) }
  let!(:course) { create(:course) }
  let!(:projects) { create_list(:project, 20, course_id: course.id) }
  before(:each) do
    projects.each do |project|
      project.users << user
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let(:course_id) { course.id }
  let(:id) { projects.first.id }

  # Test suite for GET /courses/:course_id
  describe 'GET /courses/:course_id with serialized projects' do
    before { get "/courses/#{course_id}" }
    let(:expected_permissions) {
      {
          'stories'=> { 'read' => true, 'create' => true},
          'project' => {'update' => true, 'delete' => true, 'enroll' => false, 'disenroll' => true}
      }
    }

    context 'when course exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all course projects' do
        expect(json['projects'].size).to eq(20)
        expect(json['projects'][0]['permissions']).to eq(expected_permissions)
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

  # Test suite for DELETE /projects/:id
  describe 'DELETE /projects/:id' do
    before { delete "/projects/#{id}"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
