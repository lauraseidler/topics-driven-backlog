require 'rails_helper'

RSpec.describe 'Courses/Sprints API' do

  let!(:course) { create(:course) }
  let(:course_id) { course.id }
  let!(:sprints) { create_list(:sprint, 20, course_id: course.id) }
  let(:id) { sprints.first.id }

  # Test suite for GET /courses/:course_id
  describe 'GET /courses/:course_id with serialized sprints' do
    before { get "/courses/#{course_id}" }

    context 'when course exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all course sprints' do
        expect(json).not_to be_empty
        expect(json['sprints'].size).to eq(20)
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

  # Test suite for POST /courses/:course_id/sprints
  describe 'POST /courses/:course_id/sprints' do
    let(:valid_attributes) {
      {
        name: 'Visit Narnia',
        start_date: Date.today.to_s,
        end_date: Date.tomorrow.to_s
      }
    }

    context 'when request attributes are valid' do
      before { post "/courses/#{course_id}/sprints", params: valid_attributes }

      it 'creates a sprint' do
        expect(json['name']).to eq('Visit Narnia')
        expect(json['start_date']).to eq(Date.today.to_s)
        expect(json['end_date']).to eq(Date.tomorrow.to_s)
        expect(json['course_id']).to eq(course_id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/courses/#{course_id}/sprints", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank, Start date can't be blank, End date can't be blank/)
      end
    end
  end

  # Test suite for POST /courses/:course_id/sprint-collection
  describe 'POST /courses/:course_id/sprint-collection' do
    let(:valid_parameters) {
      {
          duration: 7,
          start_date: Date.new(2017,11,07).to_s,
          end_date: Date.new(2017,11,30).to_s
      }
    }

    let(:invalid_parameters) {
      {
          duration: 0,
          start_date: '',
          end_date: Date.new(2017,11,30).to_s
      }
    }

    context 'when request attributes are valid' do
      before { post "/courses/#{course_id}/sprint-collection", params: valid_parameters }

      it 'creates sprints' do
        expect(json).not_to be_empty
        expect(json.size).to eq(3)

        expect(json[0]['name']).to eq('1. Sprint')
        expect(json[0]['course_id']).to eq(course_id)
        expect(json[0]['start_date']).to eq('2017-11-07')
        expect(json[0]['end_date']).to eq('2017-11-13')

        expect(json[1]['name']).to eq('2. Sprint')
        expect(json[1]['course_id']).to eq(course_id)
        expect(json[1]['start_date']).to eq('2017-11-14')
        expect(json[1]['end_date']).to eq('2017-11-20')

        expect(json[2]['name']).to eq('3. Sprint')
        expect(json[2]['course_id']).to eq(course_id)
        expect(json[2]['start_date']).to eq('2017-11-21')
        expect(json[2]['end_date']).to eq('2017-11-27')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request attributes are invalid' do
      before { post "/courses/#{course_id}/sprint-collection", params: invalid_parameters }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Duration must be at least 1, Start date and end date cannot be empty/)
      end
    end

  end

end