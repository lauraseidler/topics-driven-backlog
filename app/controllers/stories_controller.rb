class StoriesController < ApplicationController
  before_action :set_project, only: [:create]
  before_action :set_story, only: [:show, :update, :destroy]

  # POST /projects/:project_id/stories
  def create
    @story = @project.stories.create!(story_params)
    project_position = ProjectPosition.find_by(story_id: @story.id)
    if project_position.present?
      project_position.move_to_bottom
    end
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
    set_positions(params[:sprint_position], params[:project_position])
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
    params.permit(:title, :description, :status, :points, :sprint_id, :topic_id)
  end

  def set_project
    @project = Project.find_by!(id: params[:project_id])
  end

  def set_story
    @story = Story.find_by!(id: params[:id])
  end

  def set_positions(sprint_pos, project_pos)
    if sprint_pos.present? & @story.sprint_id.present?
      sprint_position = SprintPosition.find_by(story_id: @story.id)
      sprint_position.set_list_position(sprint_pos)
    elsif !@story.sprint_id.present?
      remove_sprint_position
    elsif !sprint_pos.present? & @story.sprint_id.present?
      sprint_position = SprintPosition.find_by(story_id: @story.id)
      if sprint_position.present?
        sprint_position.move_to_bottom
      end
    end

    if project_pos.present?
      project_position = ProjectPosition.find_by!(story_id: @story.id)
      project_position.set_list_position(project_pos)
    end
  end

  def remove_positions
    remove_sprint_position

    project_position = ProjectPosition.find_by!(story_id: @story.id)
    project_position.remove_from_list
    project_position.destroy!
  end

  def remove_sprint_position
      sprint_position = SprintPosition.find_by(story_id: @story.id)
      if sprint_position.present?
        sprint_position.remove_from_list
        sprint_position.destroy!
      end
  end

end
