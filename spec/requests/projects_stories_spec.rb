require 'rails_helper'

RSpec.describe 'Projects/Stories API', type: :request do

  let(:user) { create(:user) }
  let!(:project) { create(:project, course_id: create(:course).id) }
  before(:each) do
    project.users << user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let(:project_id) { project.id }
  let!(:stories) { create_list(:story, 10, project_id: project.id) }
  let(:story_id) { stories.first.id }

  # Test suite for GET /projects/:project_id
  describe 'GET /projects/:project_id with serialized stories' do
    before { get "/projects/#{project_id}" }
    let(:expected_permissions) {
      {
          'stories' => {'read' => true, 'create' => true},
          'project' => {'update' => true, 'delete' => true}
      }
    }

    it 'returns stories' do
      expect(json).not_to be_empty
      expect(json['stories'].size).to eq(10)
      expect(json['permissions']).to eq(expected_permissions)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for POST /projects/:project_id/stories
  describe 'POST /projects/:project_id/stories' do
    let(:valid_attributes) { { title: 'Learn Elm', description: 'Foobar' } }

    context 'when the request is valid' do
      before { post "/projects/#{project_id}/stories", params: valid_attributes }

      it 'creates a story' do
        expect(json).not_to be_empty
        expect(json['title']).to eq('Learn Elm')
        expect(json['description']).to eq('Foobar')
        expect(json['status']).to eq(Story.statuses[:open])
        expect(json['points'].to_i).to be_an_instance_of(Integer).or(be_nil)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/projects/#{project_id}/stories", params: { description: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

end
