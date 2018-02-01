require 'rails_helper'

RSpec.describe 'Projects API' do

  let!(:users) { create_list(:user, 3) }
  let(:user) { users.first}
  let!(:course) { create(:course) }
  let(:course_id) { course.id }
  let(:project) { create(:project, course_id: course_id) }
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
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
    before { project.users << user }
    before { delete "/projects/#{project.id}/enrollment"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
