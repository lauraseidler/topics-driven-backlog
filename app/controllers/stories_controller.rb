class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :update, :destroy]

  # GET /stories
  def index
    @stories = Story.all
    json_response(@stories)
  end

  # POST /stories
  def create
    @story = Story.create!(story_params)
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
    @story.update(story_params)

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

  def set_story
    @story = Story.find_by!(id: params[:id])
  end

end
