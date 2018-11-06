class API::V1::TaskUpdater
  def initialize(task, params)
    @tag_titles = Array.wrap(params.permit(tags: [])[:tags]).select(&:present?)
    @safe_params = params.permit(:title)
    @task = task
  end

  def call
    ActiveRecord::Base.transaction do
      @task.update_attributes!(task_attributes)
    end
    { success: true }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    { success: false, errors: [e.message] }
  end

  private

  def existing_tags
    @existing_tags ||= Tag.where(title: @tag_titles)
  end

  def new_tags
    new_tag_titles = @tag_titles - existing_tags.map(&:title)
    new_tag_titles.map { |title| Tag.create!(title: title) }
  end

  def task_attributes
    @safe_params.merge(tags: (new_tags + existing_tags))
  end
end
