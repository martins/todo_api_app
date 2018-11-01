class API::V1::TasksController < ApplicationController
  # before_action do
  #   self.namespace_for_serializer = API::V1
  # end

  def index
    render json: Task.all
  end

  def show
    render json: Task.find(params[:id])
  end

  def create
  end

  def destroy
  end
end
