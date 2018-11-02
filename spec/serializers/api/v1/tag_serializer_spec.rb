require 'rails_helper'

describe API::V1::TagSerializer do
  it 'correctly serializes tag' do
    tag = Tag.create(title: 'Foobar')
    json = API::V1::TagSerializer.new(tag).as_json

    expect(json).to eq(id: tag.id, title: 'Foobar')
  end
end
