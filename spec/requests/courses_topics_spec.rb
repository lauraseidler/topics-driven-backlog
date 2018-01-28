require 'rails_helper'

RSpec.describe 'Courses/Topics API' do

  let(:user) { create(:user) }
  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let!(:course) { create(:course) }
  let(:course_id) { course.id }
  let!(:topics) { create_list(:topic, 20, course_id: course.id) }
  let(:id) { topics.first.id }

  # Test suite for GET /courses/:course_id
  describe 'GET /courses/:course_id with serialized topics' do
    before { get "/courses/#{course_id}" }

    context 'when course exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all course topics' do
        expect(json).not_to be_empty
        expect(json['topics'].size).to eq(20)
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

  # Test suite for POST /courses/:course_id/topics
  describe 'POST /courses/:course_id/topics' do
    let(:valid_attributes) {
      {
          title: 'Learn Elm',
          url: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a1-activerecord/'
      }
    }

    context 'when request attributes are valid' do
      before { post "/courses/#{course_id}/topics", params: valid_attributes }

      it 'creates a topic' do
        expect(json['title']).to eq('Learn Elm')
        expect(json['url'])
            .to eq('http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a1-activerecord/')
        expect(json['course_id']).to eq(course_id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/courses/#{course_id}/topics", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

end