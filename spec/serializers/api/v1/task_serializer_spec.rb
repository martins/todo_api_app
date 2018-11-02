require 'rails_helper'

describe API::V1::TaskSerializer do
  context 'without tags' do
    it 'correctly serializes task' do
      task = Task.create(title: 'Wash car')
      json = API::V1::TaskSerializer.new(task, namespace: API::V1).as_json

      expect(json).to eq(id: task.id, title: 'Wash car', tags: [])
    end
  end

  context 'with tags' do
    it 'correctly serializes task' do
      tag = Tag.create(title: 'Foobar')
      task = Task.create(title: 'Wash car', tags: [tag])
      json = API::V1::TaskSerializer.new(task, namespace: API::V1).as_json

      expect(json).to eq(id: task.id, title: 'Wash car', tags: [{ id: tag.id, title: 'Foobar' }])
    end
  end
end
