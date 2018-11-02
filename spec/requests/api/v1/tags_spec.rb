require 'rails_helper'

describe 'Tags' do
  describe '#index' do
    it 'returns empty list when tags are not present' do
      get '/api/v1/tags'

      expect(response.body).to have_json_size(0).at_path('data')
    end

    it 'returns list with tag' do
      tag = Tag.create!(title: 'Foobar')

      get '/api/v1/tags'

      tag_attributes = %({"title":"Foobar"})
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/0/attributes')
    end
  end

  describe '#show' do
    it 'returns tag' do
      tag = Tag.create!(title: 'Foobar')

      get '/api/v1/tags/1'

      tag_attributes = %({"title":"Foobar"})
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/attributes')
    end
  end

  describe '#create' do
    it 'creates tag' do
      post '/api/v1/tags', params: { data: { attributes: { title: 'Test create tag' } } }

      tag_attributes = %({"title":"Test create tag"})

      expect(response.body).to be_json_eql(tag_attributes).at_path('data/attributes')
    end

    it 'returns errors when creation fails' do
      post '/api/v1/tags', params: { data: { attributes: { title: '' } } }

      expected_result = %({"errors":["Title can't be blank"]})
      expect(response.body).to be_json_eql(expected_result)
      expect(response.status).to eq 400
    end
  end

  describe '#update' do
    it 'updates tag' do
      tag = Tag.create!(title: 'Lorem')

      patch "/api/v1/tags/#{tag.id}", params: { data: { attributes: { title: 'Ipsum' } } }

      tag_attributes = %({"title":"Ipsum"})
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/attributes')
      expect(tag.reload).to have_attributes(title: 'Ipsum')
    end

    it 'returns errors when update fails' do
      tag = Tag.create!(title: 'Lorem')
      patch "/api/v1/tags/#{tag.id}", params: { data: { attributes: { title: '' } } }

      expected_result = %({"errors":["Title can't be blank"]})
      expect(response.body).to be_json_eql(expected_result)
      expect(response.status).to eq 400
      expect(tag.reload).to have_attributes(title: 'Lorem')
    end
  end

  describe '#destroy' do
    it 'removes tag' do
      tag = Tag.create!(title: 'Lorem')
      task = Task.create!(title: 'Test once', tags: [tag])
      delete "/api/v1/tags/#{tag.id}"

      expect(response.status).to eq 204
      expect { tag.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { task.reload }.not_to raise_error
    end

    it 'returns success even if task doesn`t exist' do
      delete '/api/v1/tags/999'

      expect(response.status).to eq 204
    end
  end
end
