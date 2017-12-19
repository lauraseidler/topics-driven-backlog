class StoriesController < ApplicationController
  before_action :set_project, only: [:create]
  before_action :set_story, only: [:show, :update, :destroy]

  # POST /projects/:project_id/stories
  def create
    @story = @project.stories.create!(story_params)
    @story.move_to_bottom
    json_response(@story, :created)
  end

  # GET /stories/:id
  def show
    json_response(@story)
  end

  # PUT /stories/:id
  # PATCH /stories/:id
  def update
    if params[:position]
      @story.set_list_position(params[:position])
    end
    @story.update!(story_params)

    json_response(@story)
  end

  # DELETE /stories/:id
  def destroy
    @story.remove_from_list
    @story.destroy!
    head :no_content
  end

  private

  def story_params
    # whitelist params
    params.permit(:title, :description, :status, :points, :sprint_id)
  end

  def set_project
    @project = Project.find_by!(id: params[:project_id])
  end

  def set_story
    @story = Story.find_by!(id: params[:id])
  end

end
