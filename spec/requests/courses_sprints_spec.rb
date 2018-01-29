require 'rails_helper'

RSpec.describe 'Courses/Sprints API' do

  let(:user) { create(:user) }
  let!(:course) { create(:course) }
  before(:each) do
    course.instructions.build( user_id: user.id, initial_instructor: true )
    course.save!
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let(:course_id) { course.id }
  let!(:sprints) { create_list(:sprint, 20, course_id: course.id) }
  let(:id) { sprints.first.id }
  let(:id_2) { sprints.second.id }

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
          start_date: Date.new(2200,11,07).to_s,
          end_date: Date.new(2200,11,30).to_s
      }
    }

    let(:invalid_parameters) {
      {
          duration: 0,
          start_date: '',
          end_date: Date.new(2200,11,30).to_s
      }
    }

    context 'when request attributes are valid' do
      before { post "/courses/#{course_id}/sprint-collection", params: valid_parameters }

      it 'creates sprints' do
        expect(json).not_to be_empty
        expect(json.size).to eq(3)

        expect(json[0]['name']).to eq('1. Sprint')
        expect(json[0]['course_id']).to eq(course_id)
        expect(json[0]['start_date']).to eq('2200-11-07')
        expect(json[0]['end_date']).to eq('2200-11-13')

        expect(json[1]['name']).to eq('2. Sprint')
        expect(json[1]['course_id']).to eq(course_id)
        expect(json[1]['start_date']).to eq('2200-11-14')
        expect(json[1]['end_date']).to eq('2200-11-20')

        expect(json[2]['name']).to eq('3. Sprint')
        expect(json[2]['course_id']).to eq(course_id)
        expect(json[2]['start_date']).to eq('2200-11-21')
        expect(json[2]['end_date']).to eq('2200-11-27')
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
        expect(response.body).to match(/Validation failed: Duration must be at least 1, Start date or end date cannot be empty/)
      end
    end

  end

  # Test suite for PATCH /courses/:course_id/sprint-collection
  describe 'PATCH /courses/:course_id/sprint-collection' do

    context 'updating a valid parameter collection' do
      let(:valid_parameters) {
        {
            collection: [
                {
                    id: id,
                    start_date: Date.new(2200,11,07).to_s,
                    end_date: Date.new(2200,11,30).to_s
                },
                {
                    id: id_2,
                    start_date: Date.new(2200,12,01).to_s,
                    end_date: Date.new(2200,12,8).to_s
                }
            ]
        }
      }
      before { patch "/courses/#{course_id}/sprint-collection", params: valid_parameters }

      it 'updates the records' do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)

        expect(json[0]['course_id']).to eq(course_id)
        expect(json[0]['start_date']).to eq('2200-11-07')
        expect(json[0]['end_date']).to eq('2200-11-30')

        expect(json[1]['course_id']).to eq(course_id)
        expect(json[1]['start_date']).to eq('2200-12-01')
        expect(json[1]['end_date']).to eq('2200-12-08')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updating an invalid parameter collection' do
      let(:invalid_parameters) {
        {
            collection: [
                {
                    id: id,
                    start_date: Date.new(2200,11,07).to_s,
                    end_date: Date.new(2200,11,30).to_s
                },
                {
                    id: id_2,
                    start_date: Date.new(2200,12,01).to_s,
                    end_date: Date.new(2001,12,8).to_s
                }
            ]
        }
      }
      before { patch "/courses/#{course_id}/sprint-collection", params: invalid_parameters }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: End date cannot be before the start date, End date cannot be in the past/)
      end
    end
  end

end
