class API::V1::TagsController < API::V1Controller
  def index
    scoped = Tag.order(:id)

    if params[:q].present?
      scoped = Tag.where(Tag.arel_table[:title].matches("%#{params[:q]}%"))
    end

    render json: scoped
  end

  def create
    tag = Tag.new

    save_record(tag)
  end

  def show
    render json: Tag.find(params[:id])
  end

  def update
    tag = Tag.find(params[:id])

    save_record(tag)
  end

  def destroy
    Tag.where(id: params[:id]).destroy_all

    head :no_content
  end

  private

  def save_record(tag)
    if tag.update_attributes(safe_params)
      render json: tag
    else
      render json: { errors: tag.errors.full_messages }, status: :bad_request
    end
  end

  def safe_params
    attribute_params.permit(:title)
  end
end
