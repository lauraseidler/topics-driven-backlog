class StoriesController < ApplicationController
  before_action :set_backlog
  before_action :set_story, only: [:show, :update, :destroy]

  # GET /backlogs/:backlog_id/stories
  def index
    @stories = @backlog.stories
    json_response(@stories)
  end

  # POST /backlogs/:backlog_id/stories
  def create
    @story = @backlog.stories.create!(story_params)
    @story.move_to_bottom
    json_response(@story, :created)
  end

  # GET /backlogs/:backlog_id/stories/:id
  def show
    json_response(@story)
  end

  # PUT /backlogs/:backlog_id/stories/:id
  # PATCH /backlogs/:backlog_id/stories/:id
  def update
    if params[:position]
      @story.set_list_position(params[:position])
    end
    @story.update(story_params)
    head :no_content
  end

  # DELETE /backlogs/:backlog_id/stories/:id
  def destroy
    @story.remove_from_list
    @story.destroy!
    head :no_content
  end

  private

  def story_params
    # whitelist params
    params.permit(:title, :description)
  end

  def set_backlog
    @backlog = Backlog.find(params[:backlog_id])
  end

  def set_story
    @story = @backlog.stories.find_by!(id: params[:id]) if @backlog
  end

end
