class API::V1::TasksController < API::V1Controller
  def index
    render json: Task.includes(:tags).order(:id)
  end

  def create
    task = Task.new

    save_record(task)
  end

  def show
    render json: Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])

    save_record(task)
  end

  def destroy
    Task.where(id: params[:id]).destroy_all

    head :no_content
  end

  private

  def save_record(task)
    result = API::V1::TaskUpdater.new(task, attribute_params).call

    if result[:success]
      render json: task
    else
      render json: { errors: result[:errors] }, status: :bad_request
    end
  end
end
