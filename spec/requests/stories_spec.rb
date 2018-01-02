require 'rails_helper'

RSpec.describe 'Stories API', type: :request do

  let!(:course_id) { create( :course ).id }
  let!(:project) { create( :project, course_id: course_id ) }
  let!(:stories) {
    create_list(
        :story,
        10,
        project_id: project.id,
    )
  }

  let(:sprint_id) {
    create(
        :sprint,
        :course_id => course_id
    ).id
  }
  let(:story_id) { stories.first.id }

  # Test suite for GET /stories/:id
  describe 'GET /stories/:id' do
    before { stories.first.save! }
    before { get "/stories/#{story_id}" }

    context 'when the record exists' do
      it 'returns the story' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(story_id)
        expect(json['identifier']).to eq('S-'+story_id.to_s)
        expect(json['status']).to be >= Story.statuses[:open]
        expect(json['status']).to be <= Story.statuses[:canceled]
        expect(json['points'].to_i).to be_an_instance_of(Integer).or(be_nil)
        expect(json['project_id'].to_i).to eq(project.id)
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
  describe 'PATCH /stories/:id for position attributes' do
    let(:position_attributes) {
      {
          project_position: 1,
          sprint_id: sprint_id,
          sprint_position: 1
      }
    }
    before { patch "/stories/#{story_id}", params: position_attributes }

    context 'updating the a story of the backlog' do

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updating the a story of the backlog to the second position' do
      before { get "/stories/#{story_id}" }

      it 'returns the first position value' do
        expect(json).not_to be_empty
        expect(json['project_position']).to eq(1)
        expect(json['sprint_position']).to eq(1)
        expect(json['sprint_id']).to eq(sprint_id)
      end
    end
  end

  # Test suite for PATCH /stories/:id
  describe 'PATCH /stories/:id for status attribute' do
    let(:first_story) {stories.first}
    let(:last_story) {stories.last}
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
        expect(json['status']).to eq(Story.statuses[:progressing])
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

    context 'assigning a story to a sprint which is already finished' do
      let(:past_sprint_id) {
        create(
            :sprint,
            :course_id => create(:course).id,
            :start_date => Date.today - 1.week,
            :end_date => Date.yesterday
        ).id
      }
      let(:past_sprint_attribute) {{:sprint_id => past_sprint_id}}

      before {patch "/stories/#{story_id}", params: past_sprint_attribute}

      it 'updates the record' do
        expect(json['sprint_id']).to eq(nil)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Sprint was finished and cannot be changed/)
      end
    end
  end

  # Test suite for DELETE /stories/:id
  describe 'DELETE /stories/:id' do
    before { delete "/stories/#{story_id}"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end