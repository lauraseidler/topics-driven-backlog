class TasksController < ApplicationController
  before_action :set_story
  before_action :set_story_task, only: [:show, :update, :destroy]

  # GET /stories/:story_id/tasks
  def index
    json_response(@story.tasks)
  end

  # GET /stories/:story_id/tasks/:id
  def show
    json_response(@task)
  end

  # POST /stories/:story_id/tasks
  def create
    @story.tasks.create!(task_params)
    json_response(@story, :created)
  end

  # PUT /stories/:story_id/tasks/:id
  def update
    @task.update(task_params)
    head :no_content
  end

  # DELETE /stories/:story_id/tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  private

  def task_params
    params.permit(:title)
  end

  def set_story
    @story = Story.find(params[:story_id])
  end

  def set_story_task
    @task = @story.tasks.find_by!(id: params[:id]) if @story
  end
  
end
