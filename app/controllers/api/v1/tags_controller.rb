class API::V1::TagsController < API::V1Controller
  def index
    render json: Tag.all
  end

  def create
    tag = Tag.new

    tag.update_attributes(safe_params)

    render json: tag
  end

  def show
    render json: Tag.find(params[:id])
  end

  def update
    tag = Tag.find(params[:id])

    tag.update_attributes(safe_params)

    render json: tag
  end

  def destroy
    Tag.where(id: params[:id]).destroy_all

    head :no_content
  end

  private

  def safe_params
    attribute_params.permit(:title)
  end
end
