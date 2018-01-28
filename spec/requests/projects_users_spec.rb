require 'rails_helper'

RSpec.describe 'Projects API' do

  let(:user) { create(:user) }
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let!(:users) { create_list(:user, 2) }
  let!(:course) { create(:course) }
  let(:course_id) { course.id }
  let(:project) { create(:project, course_id: course_id) }

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
      before { patch "/projects/#{project.id}", params: valid_attributes }

      it 'updates the record' do
        expect(json.size).to eq(5)
        expect(json['user_ids']).to eq([users.first.id, users.second.id])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists' do
      before { patch "/projects/#{project.id}", params: invalid_attributes }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: User 3 does not exist/)
      end
    end
  end

  # Test suite for POST /projects/:id/enrollments
  describe 'POST /projects/:id/enrollments' do
    context 'when current user is allowed to enroll' do
      before { post "/projects/#{project.id}/enrollments" }

      it 'returns the project' do
        expect(json['title']).to eq(project.title)
        expect(json['course_id']).to eq(course_id)
        expect(json['user_ids']).to eq([user.id])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  # Test suite for DELETE /projects/:project_id/enrollment
  describe 'DELETE /projects/:project_id/enrollment' do
    before { delete "/projects/#{project.id}/enrollment"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
