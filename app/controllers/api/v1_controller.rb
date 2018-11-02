class API::V1Controller < ApplicationController
  before_action do
    self.namespace_for_serializer = API::V1
  end

  def base_params
    params.require(:data)
  end

  def attribute_params
    base_params.require(:attributes)
  end
end
