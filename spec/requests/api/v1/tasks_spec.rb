require 'rails_helper'

describe 'Tasks' do
  describe '#index' do
    it 'returns empty list when tasks are not present' do
      get '/api/v1/tasks'

      expect(response.body).to have_json_size(0).at_path('data')
    end

    it 'returns list with task' do
      tag = Tag.create!(title: 'Foobar')
      task = Task.create!(title: 'Testing', tags: [tag])

      get '/api/v1/tasks'

      task_attributes = %({"title":"Testing"})
      tag_attributes = %({"id":"#{tag.id}", "type":"tags"})

      expect(response.body).to be_json_eql(task_attributes).at_path('data/0/attributes')
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/0/relationships/tags/data/0')
    end
  end

  describe '#show' do
    it 'returns task' do
      tag = Tag.create!(title: 'Foobar')
      task = Task.create!(title: 'Testing', tags: [tag])

      get '/api/v1/tasks/1'

      task_attributes = %({"title":"Testing"})
      tag_attributes = %({"id":"#{tag.id}", "type":"tags"})

      expect(response.body).to be_json_eql(task_attributes).at_path('data/attributes')
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/relationships/tags/data/0')
    end
  end

  describe '#create' do
    it 'creates task' do
      post '/api/v1/tasks', params: { data: { attributes: { title: 'Test create', tags: ['Now'] } } }

      tag = Tag.last!
      task_attributes = %({"title":"Test create"})
      tag_attributes = %({"id":"#{tag.id}", "type":"tags"})

      expect(response.body).to be_json_eql(task_attributes).at_path('data/attributes')
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/relationships/tags/data/0')
    end

    it 'returns errors when creation fails' do
      post '/api/v1/tasks', params: { data: { attributes: { title: '' } } }

      expected_result = %({"errors":["Validation failed: Title can't be blank"]})
      expect(response.body).to be_json_eql(expected_result)
      expect(response.status).to eq 400
    end
  end

  describe '#update' do
    it 'updates task' do
      tag = Tag.create!(title: 'Lorem')
      task = Task.create!(title: 'Test once', tags: [tag])
      patch "/api/v1/tasks/#{task.id}", params: { data: { attributes: { title: 'Test twice', tags: ['Later'] } } }

      tag = Tag.last!
      task_attributes = %({"title":"Test twice"})
      tag_attributes = %({"id":"#{tag.id}", "type":"tags"})

      expect(response.body).to be_json_eql(task_attributes).at_path('data/attributes')
      expect(response.body).to be_json_eql(tag_attributes).at_path('data/relationships/tags/data/0')
    end

    it 'returns errors when update fails' do
      task = Task.create!(title: 'Test once')
      patch "/api/v1/tasks/#{task.id}", params: { data: { attributes: { title: '' } } }

      expected_result = %({"errors":["Validation failed: Title can't be blank"]})
      expect(response.body).to be_json_eql(expected_result)
      expect(response.status).to eq 400
      expect(task.reload).to have_attributes(title: 'Test once')
    end
  end

  describe '#destroy' do
    it 'removes task' do
      tag = Tag.create!(title: 'Lorem')
      task = Task.create!(title: 'Test once', tags: [tag])
      delete "/api/v1/tasks/#{task.id}"

      expect(response.status).to eq 204
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { tag.reload }.not_to raise_error
    end

    it 'returns success even if task doesn`t exist' do
      delete '/api/v1/tasks/999'

      expect(response.status).to eq 204
    end
  end
end
