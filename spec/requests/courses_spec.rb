require 'rails_helper'

RSpec.describe 'Courses API', type: :request do

  let(:user) { create(:user) }
  let!(:courses) { create_list(:course, 10) }
  let(:course) { courses.first }
  before(:each) do
    courses.each do |course|
      course.instructions.build( user_id: user.id, initial_instructor: true )
      course.save!
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authorize_request).and_return(user)
  end

  let(:course_id) { courses.first.id }

  # Test suite for GET /courses
  describe 'GET /courses' do
    # make HTTP get request before each example
    before { get '/courses' }

    it 'returns courses' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /courses/:id
  describe 'GET /courses/:id' do
    before { get "/courses/#{course_id}" }
    let(:expected_permissions) {
      [
          'sprints' => ['read' => true, 'create' => true],
          'topics' => ['read' => true, 'create' => true],
          'projects' => ['read' => true, 'create' => true],
          'course' => ['update' => true, 'delete' => true],
      ]
    }

    context 'when the record exists' do
      it 'returns the course' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(course_id)
        expect(json['title']).to eq(course.title)
        expect(json['short_title']).to eq(course.short_title)
        expect(json['hyperlink']).to eq(course.hyperlink)
        expect(json['semester_type']).to eq(course.semester_type)
        expect(json['semester_year']).to eq(course.semester_year)
        expect(json['permissions']).to eq(expected_permissions)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:course_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Course/)
      end
    end
  end

  # Test suite for POST /courses
  describe 'POST /courses' do
    # valid payload
    let(:valid_attributes) {
      {
        title: 'Learn Elm',
        short_title: 'LE',
        hyperlink: 'example.com',
        semester_type: Course.semester_types[:summer],
        semester_year: Date.today.year.to_s
      }
    }

    context 'when the request is valid' do
      before { post '/courses', params: valid_attributes }

      it 'creates a course' do
        expect(json).not_to be_empty
        expect(json['title']).to eq('Learn Elm')
        expect(json['short_title']).to eq('LE')
        expect(json['hyperlink']).to eq('example.com')
        expect(json['semester_type']).to eq(Course.semester_types[:summer])
        expect(json['semester_year']).to eq(Date.today.year)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/courses', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Semester year must be in format YYYY, Semester type must be `S` or `W`/)
      end
    end
  end

  # Test suite for PUT /courses/:id
  describe 'PUT /courses/:id' do
    let(:valid_attributes) {
      {
          title: 'Learn Elm',
          hyperlink: 'example.com',
          semester_type: Course.semester_types[:summer],
          semester_year: Date.today.year.to_s,
          allow_enrollment: true
      }
    }
    before { put "/courses/#{course_id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json['title']).to eq('Learn Elm')
        expect(json['hyperlink']).to eq('example.com')
        expect(json['semester_type']).to eq(Course.semester_types[:summer])
        expect(json['semester_year']).to eq(Date.today.year)
        expect(json['allow_enrollment']).to eq(true)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:course_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Course/)
      end
    end
  end

  # Test suite for PATCH /courses/:id
  describe 'PATCH /courses/:id for semester attributes' do
    let(:valid_semester_attributes) {
      { semester_type: Course.semester_types[:summer], semester_year: Date.today.year }
    }
    let(:invalid_semester_attributes) {
      { semester_type: 'Q', semester_year: 100 }
    }

    context 'updating with a valid semester attributes' do
      before { patch "/courses/#{course_id}", params: valid_semester_attributes }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updating with invalid semester attributes' do
      before { patch "/courses/#{course_id}", params: invalid_semester_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Semester year must be in format YYYY, Semester type must be `S` or `W`/)
      end
    end
  end

  # Test suite for DELETE /courses/:id
  describe 'DELETE /courses/:id' do
    before { delete "/courses/#{course_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end