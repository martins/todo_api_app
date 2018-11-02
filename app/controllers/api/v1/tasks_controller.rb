class API::V1::TasksController < API::V1Controller
  def index
    render json: Task.all
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
    tag_titles = Array.wrap(attribute_params.permit(tags: [])[:tags])

    ActiveRecord::Base.transaction do
      tags = tag_titles.map { |title| Tag.where(title: title).first_or_create! if title.present? }
      task.update_attributes!(safe_params.merge(tags: tags))
    end

    render json: task
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    render json: { errors: [e.message] }, status: :bad_request
  end

  def safe_params
    attribute_params.permit(:title)
  end
end
