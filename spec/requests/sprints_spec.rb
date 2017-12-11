require 'rails_helper'

RSpec.describe 'Sprints API' do

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

  # Test suite for PUT /sprints/:id
  describe 'PUT /sprints/:id' do
    let(:valid_attributes) {
      {
          name: 'Learn Elm',
          start_date: Date.today.to_s,
          end_date: Date.tomorrow.to_s
      }
    }
    before { put "/sprints/#{id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(json['name']).to eq('Learn Elm')
        expect(json['start_date']).to eq(Date.today.to_s)
        expect(json['end_date']).to eq(Date.tomorrow.to_s)
        expect(json['course_id']).to eq(course_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Sprint/)
      end
    end
  end

  # Test suite for PATCH /sprints/:id
  describe 'PATCH /sprints/:id for date attributes' do
    let(:valid_date_attributes) {
      { start_date: Date.today.to_s, end_date: Date.tomorrow.to_s }
    }
    let(:invalid_dates_attribute) {
      { start_date: Date.tomorrow.to_s, end_date: Date.today.to_s }
    }

    context 'updating a valid end date' do
      before { patch "/sprints/#{id}", params: valid_date_attributes }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updating an invalid end date' do
      before { patch "/sprints/#{id}", params: invalid_dates_attribute }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: End date cannot be before the start date/)
      end
    end

    context 'updating dates to the past' do
      before { patch "/sprints/#{id}", params:
          { start_date: Date.new(2017,10,1).to_s, end_date: Date.new(2017,10,8).to_s }
      }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: End date cannot be in the past/)
      end
    end
  end

  # Test suite for DELETE /sprints/:id
  describe 'DELETE /sprints/:id' do
    before { delete "/sprints/#{id}"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end