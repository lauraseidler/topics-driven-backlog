# require 'rails_helper'
#
# RSpec.describe 'Tasks API' do
#
#   let!(:story) { create(:story) }
#   let!(:tasks) { create_list(:task, 20, story_id: story.id) }
#   let(:story_id) { story.id }
#   let(:id) { tasks.first.id }
#
#   # Test suite for GET /stories/:story_id/tasks
#   describe 'GET /stories/:story_id/tasks' do
#     before { get "/stories/#{story_id}/tasks" }
#
#     context 'when story exists' do
#       it 'returns status code 200' do
#         expect(response).to have_http_status(200)
#       end
#
#       it 'returns all story tasks' do
#         expect(json.size).to eq(20)
#       end
#     end
#
#     context 'when story does not exist' do
#       let(:story_id) { 0 }
#
#       it 'returns status code 404' do
#         expect(response).to have_http_status(404)
#       end
#
#       it 'returns a not found message' do
#         expect(response.body).to match(/Couldn't find Story/)
#       end
#     end
#   end
#
#   # Test suite for GET /stories/:story_id/tasks/:id
#   describe 'GET /stories/:story_id/tasks/:id' do
#     before { get "/stories/#{story_id}/tasks/#{id}" }
#
#     context 'when story task exists' do
#       it 'returns status code 200' do
#         expect(response).to have_http_status(200)
#       end
#
#       it 'returns the task' do
#         expect(json['id']).to eq(id)
#       end
#     end
#
#     context 'when story task does not exist' do
#       let(:id) { 0 }
#
#       it 'returns status code 404' do
#         expect(response).to have_http_status(404)
#       end
#
#       it 'returns a not found message' do
#         expect(response.body).to match(/Couldn't find Task/)
#       end
#     end
#   end
#
#   # Test suite for PUT /stories/:story_id/tasks
#   describe 'POST /stories/:story_id/tasks' do
#     let(:valid_attributes) { { title: 'Visit Narnia', description: 'wow' } }
#
#     context 'when request attributes are valid' do
#       before { post "/stories/#{story_id}/tasks", params: valid_attributes }
#
#       it 'returns status code 201' do
#         expect(response).to have_http_status(201)
#       end
#     end
#
#     context 'when an invalid request' do
#       before { post "/stories/#{story_id}/tasks", params: {} }
#
#       it 'returns status code 422' do
#         expect(response).to have_http_status(422)
#       end
#
#       it 'returns a failure message' do
#         expect(response.body).to match(/Validation failed: Title can't be blank/)
#       end
#     end
#   end
#
#   # Test suite for PUT /stories/:story_id/tasks/:id
#   describe 'PUT /stories/:story_id/tasks/:id' do
#     let(:valid_attributes) { { title: 'Mozart' } }
#
#     before { put "/stories/#{story_id}/tasks/#{id}", params: valid_attributes }
#
#     context 'when task exists' do
#       it 'returns status code 204' do
#         expect(response).to have_http_status(204)
#       end
#
#       it 'updates the task' do
#         updated_task = Task.find(id)
#         expect(updated_task.name).to match(/Mozart/)
#       end
#     end
#
#     context 'when the task does not exist' do
#       let(:id) { 0 }
#
#       it 'returns status code 404' do
#         expect(response).to have_http_status(404)
#       end
#
#       it 'returns a not found message' do
#         expect(response.body).to match(/Couldn't find Task/)
#       end
#     end
#   end
#
#   # Test suite for DELETE /stories/:id
#   describe 'DELETE /stories/:id' do
#     before { delete "/stories/#{story_id}/tasks/#{id}" }
#
#     it 'returns status code 204' do
#       expect(response).to have_http_status(204)
#     end
#   end
# end