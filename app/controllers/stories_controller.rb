class StoriesController < ApplicationController
  before_action :set_project, only: [:create]
  before_action :set_story, only: [:show, :update, :destroy]

  # POST /projects/:project_id/stories
  def create
    @story = @project.stories.create!(story_params)
    create_project_position
    @story.reload
    json_response(@story, :created)
  end

  # GET /stories/:id
  def show
    json_response(@story)
  end

  # PUT /stories/:id
  # PATCH /stories/:id
  def update
    @story.update!(story_params)
    set_positions(params[:sprint_position] || nil, params[:project_position] || nil)

    json_response(@story)
  end

  # DELETE /stories/:id
  def destroy
    remove_positions

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

  def set_positions(sprint_pos, project_pos)
    if sprint_pos.present? & @story.sprint_id.present?
      sprint_position = SprintPosition.find_by!(id: @story.sprint_position_id)
      if @story.sprint_id != sprint_position.sprint_id
        sprint_position.sprint_id = @story.sprint_id
      end
      sprint_position.set_list_position(sprint_pos)
    end
    if project_pos.present?
      project_position = ProjectPosition.find_by!(id: @story.project_position_id)
      project_position.set_list_position(project_pos)
    end
  end

  def remove_positions
    if @story.sprint_position_id.present?
      sprint_position = SprintPosition.find_by!(id: @story.sprint_position_id)
      sprint_position.remove_from_list
    end
    project_position = ProjectPosition.find_by!(id: @story.project_position_id)
    project_position.remove_from_list
  end

  def create_project_position
    project_position = ProjectPosition.create(:project_id => @project.id)
    project_position.move_to_bottom
  end

end
