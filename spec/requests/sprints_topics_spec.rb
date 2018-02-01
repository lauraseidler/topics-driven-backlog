require 'rails_helper'

RSpec.describe 'Sprints/Topics API' do

  let(:user) { create(:user) }
  let!(:course) { create(:course) }
  before(:each) do
    course.instructions.build( user_id: user.id, initial_instructor: true )
    course.save!
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let!(:second_course) { create(:course) }
  let!(:sprint) { create(:sprint, course_id: course.id)}
  let!(:sprint_id) { sprint.id }
  let!(:topics) { create_list(:topic, 2, course_id: course.id) }
  let!(:topic_id) { topics.first.id }
  let!(:invalid_sprint_topic_id) { create(:topic, course_id: second_course.id).id }

  # Test suite for POST /courses/:course_id/sprints
  describe 'POST /courses/:course_id/sprints with defining topics' do
    let(:valid_attributes) {
      {
          name: 'Visit Narnia',
          start_date: Date.today.to_s,
          end_date: Date.tomorrow.to_s,
          topic_ids: [topics.first.id, topics.last.id]
      }
    }

    context 'when request attributes are valid' do
      before { post "/courses/#{course.id}/sprints", params: valid_attributes }

      it 'creates a sprint with topics' do
        expect(json['name']).to eq('Visit Narnia')
        expect(json['start_date']).to eq(Date.today.to_s)
        expect(json['end_date']).to eq(Date.tomorrow.to_s)
        expect(json['course_id']).to eq(course.id)
        expect(json['topic_ids']).to eq([topics.first.id, topics.last.id])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  # Test suite for PATCH /sprints/:id
  describe 'PATCH /sprints/:id for adding topics' do
    let(:valid_topics) {
      { topic_ids: [topics.first.id, topics.last.id] }
    }
    let(:invalid_topics) {
      { topic_ids: [topics.first.id, 100] }
    }
    let(:topic_from_wrong_course) {
      { topic_ids: [topics.first.id, invalid_sprint_topic_id] }
    }

    context 'updating with valid topics' do
      before { patch "/sprints/#{sprint_id}", params: valid_topics }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updating with a topic which does not exist' do
      before { patch "/sprints/#{sprint_id}", params: invalid_topics }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Topic 100 does not exist/)
      end
    end

    context 'updating with a topic which does not belong to the sprints course' do
      before { patch "/sprints/#{sprint_id}", params: topic_from_wrong_course }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a failure message' do
        expect(response.body)
            .to match(
                    "Validation failed: Topic #{invalid_sprint_topic_id} does not exists for course #{course.id.to_s}"
                )
      end
    end

  end

  # Test suite for DELETE /topics/:id
  describe 'DELETE /topics/:id to get deleted as reference for sprints' do
    context 'when the story was part of a sprint' do
      before { delete "/topics/#{topic_id}"}

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the topic association for the sprint' do
        expect(sprint.topics.find_by(id: topic_id)).to eq(nil)
      end
    end
  end

end
