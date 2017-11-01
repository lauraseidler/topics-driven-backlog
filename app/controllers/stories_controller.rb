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
    json_response(@story, :created)
  end

  # GET /stories/:id
  def show
    json_response(@story)
  end

  # PUT /stories/:id
  # PATCH /stories/:id
  def update
    @story.update(story_params)
    head :no_content
  end

  # DELETE /stories/:id
  def destroy
    @story.destroy
    head :no_content
  end

  private

  def story_params
    # whitelist params
    params.permit(:title, :description)
  end

  def set_story
    @story = Story.find(params[:id])
  end

end
