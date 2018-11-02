class API::V1::TaskSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :tags
end
