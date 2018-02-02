require 'rails_helper'

RSpec.describe 'Stories API', type: :request do

  let(:user) { create(:user, role: User.roles[:student]) }
  let!(:course_id) { create( :course ).id }
  let!(:project) { create( :project, course_id: course_id ) }
  before(:each) do
    project.users << user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end


  let(:sprint_id) {
    create(
        :sprint,
        :course_id => course_id
    ).id
  }

  let(:story) { create(:story, project_id: project.id) }
  let(:second_story) { create(:story, project_id: project.id) }
  let(:story_id) { story.id }
  let(:second_story_id) { second_story.id }

  # Test suite for GET /stories/:id
  describe 'GET /stories/:id' do
    before { get "/stories/#{story_id}" }
    let(:expected_permissions) {
      {
          'story' => {'update' => true, 'delete' => true}
      }
    }

    context 'when the record exists' do
      it 'returns the story' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(story_id)
        expect(json['identifier']).to eq('S-1')
        expect(json['status']).to be >= Story.statuses[:open]
        expect(json['status']).to be <= Story.statuses[:canceled]
        expect(json['points'].to_i).to be_an_instance_of(Integer).or(be_nil)
        expect(json['project_id'].to_i).to eq(project.id)
        expect(json['permissions']).to eq(expected_permissions)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:story_id) { 100000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Story/)
      end
    end
  end

  # Test suite for PUT /stories/:id
  describe 'PUT /stories/:id' do
    let(:valid_attributes) { { title: 'Shopping', description: 'Foobar' } }
    before { put "/stories/#{story_id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json['title']).to eq('Shopping')
        expect(json['description']).to eq('Foobar')
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


  # Test suite for PATCH /stories/:id
  describe 'PATCH /stories/:id for project position attribute' do
    let(:position_attributes) {
      {
          project_position: 2,
          sprint_id: sprint_id,
          sprint_position: 1
      }
    }
    before { patch "/stories/#{story_id}", params: position_attributes }

    context 'updating the story of the backlog' do

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updates the story of the backlog to the second position' do
      before { get "/stories/#{story_id}" }

      it 'returns the first position value' do
        expect(json).not_to be_empty
        expect(json['project_position']).to eq(2)
        expect(json['sprint_position']).to eq(1)
        expect(json['sprint_id']).to eq(sprint_id)
      end
    end

  end

  # Test suite for PATCH /stories/:id
  describe 'PATCH /stories/:id for sprint position attribute' do
    let(:second_sprint_id) {
      create(
          :sprint,
          :course_id => course_id
      ).id
    }
    let(:sprint_attribute) {
      {
          sprint_id: second_sprint_id
      }
    }

    before { patch "/stories/#{story_id}", params: sprint_attribute }
    before { patch "/stories/#{second_story_id}", params: sprint_attribute }

    context 'updates the story in the sprint to the first position' do
      before { get "/stories/#{story_id}" }

      it 'returns the first position value' do
        expect(json).not_to be_empty
        expect(json['sprint_id']).to eq(second_sprint_id)
        expect(json['sprint_position']).to eq(1)
      end
    end

    context 'updates second story to the second position' do
      before { get "/stories/#{second_story_id}" }

      it 'returns the second position value' do
        expect(json).not_to be_empty
        expect(json['sprint_id']).to eq(second_sprint_id)
        expect(json['sprint_position']).to eq(2)
      end
    end

    context 'updates first storys sprint and position' do
      let(:sprint_and_position_attribute) {
        {
            sprint_id: sprint_id,
            sprint_position: 1
        }
      }
      before { patch "/stories/#{story_id}", params: sprint_and_position_attribute }
      before { get "/stories/#{story_id}" }

      it 'returns the first position value' do
        expect(json).not_to be_empty
        expect(json['sprint_id']).to eq(sprint_id)
        expect(json['sprint_position']).to eq(1)
      end
    end

  end

  # Test suite for PATCH /stories/:id
  describe 'PATCH /stories/:id for status attribute' do
    let(:first_story) {story}
    let(:last_story) {second_story}
    let(:status_attribute) { { :status => Story.statuses[:progressing] } }

    before { patch "/stories/#{last_story.id}", params: status_attribute }

    context 'updating a story status' do
      it 'updates the record' do
        expect(json['status']).to eq(Story.statuses[:progressing])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists' do
      before { get "/stories/#{last_story.id}" }

      it 'provides the story status' do
        expect(json).not_to be_empty
        expect(json['status']).to eq(Story.statuses[:progressing])
      end
    end
  end

  # Test suite for PATCH /stories/:id
  describe 'PATCH /stories/:id for topic attribute' do
    let(:course_id) { create(:course).id }
    let(:topic_id) { create(:topic, :course_id => course_id).id }
    let(:topic_attribute) { { :topic_id => topic_id } }

    before { patch "/stories/#{story_id}", params: topic_attribute }

    context 'updating a story status' do
      it 'updates the record' do
        expect(json['topic_id']).to eq(topic_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists' do
      before { get "/stories/#{story_id}" }

      it 'provides the story status' do
        expect(json).not_to be_empty
        expect(json['topic_id']).to eq(topic_id)
      end
    end
  end

  # Test suite for PATCH /stories/:id
  describe 'PATCH /stories/:id for sprint attribute' do
    let(:sprint_attribute) {{:sprint_id => sprint_id}}

    context 'assigning a story to a sprint' do
      before {patch "/stories/#{story_id}", params: sprint_attribute}

      it 'updates the record' do
        expect(json['sprint_id']).to eq(sprint_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists' do
      before {patch "/stories/#{story_id}", params: sprint_attribute}
      before {get "/stories/#{story_id}"}

      it 'provides the sprint id for a story' do
        expect(json['sprint_id']).to eq(sprint_id)
      end
    end
  end

  # Test suite for DELETE /stories/:id
  describe 'DELETE /stories/:id' do

    context 'when the record exists' do
      before { delete "/stories/#{story_id}"}

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    let(:sprint_attribute) {{:sprint_id => sprint_id}}
    before { patch "/stories/#{story_id}", params: sprint_attribute}

    context 'when the story was part of a sprint' do
      before { delete "/stories/#{story_id}"}

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the SprintPosition record' do
        sprint_position = SprintPosition.find_by(sprint_id: sprint_id, story_id: story_id)
        expect(sprint_position).to eq(nil)
      end
    end
  end

end