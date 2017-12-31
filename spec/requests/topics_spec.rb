require 'rails_helper'

RSpec.describe 'Topics API' do

  let!(:course) { create(:course) }
  let(:course_id) { course.id }
  let!(:topics) { create_list(:topic, 20, course_id: course.id) }
  let(:id) { topics.first.id }

  # Test suite for PUT /topics/:id
  describe 'PUT /topics/:id' do
    let(:valid_attributes) {
      {
          title: 'Learn Elm',
          url: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a1-activerecord/'
      }
    }
    before { put "/topics/#{id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(json['title']).to eq('Learn Elm')
        expect(json['url'])
            .to eq('http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a1-activerecord/')
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
        expect(response.body).to match(/Couldn't find Topic/)
      end
    end
  end

  # Test suite for PATCH /topics/:id
  describe 'PATCH /topics/:id for url attribute' do
    let(:valid_url_attribute) {
      { url: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a1-activerecord/' }
    }
    let(:invalid_url_attribut) {
      { url: 'foo/bar' }
    }

    context 'updating a valid url' do
      before { patch "/topics/#{id}", params: valid_url_attribute }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'updating an invalid end date' do
      before { patch "/topics/#{id}", params: invalid_url_attribut }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Url is invalid./)
      end
    end
  end

  # Test suite for DELETE /topics/:id
  describe 'DELETE /topics/:id' do
    before { delete "/topics/#{id}"}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end