class TasksController < ApplicationController
  before_action :set_story, only: [:show, :create, :update, :destroy]
  before_action :set_story_task, only: [:show, :update, :destroy]

  # GET /stories/:story_id/tasks
  # GET /tasks
  def index
    if params[:story_id]
      set_story
      json_response(@story.tasks)
    else
      @stories = Story.all
      task_list = []
      @stories.each do |story|
        task_list.concat(story.tasks.all)
      end
      json_response(task_list)
    end
  end

  # GET /stories/:story_id/tasks/:id
  def show
    json_response(@task)
  end

  # POST /stories/:story_id/tasks
  def create
    @task = @story.tasks.create!(task_params)
    json_response(@task, :created)
  end

  # PUT /stories/:story_id/tasks/:id
  # PATCH /stories/:story_id/tasks/:id
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
    params.permit(:title, :description)
  end

  def set_story
    @story = Story.find_by!(id: params[:story_id])
  end

  def set_story_task
    if @story
      @task = @story.tasks.find_by!(id: params[:id])
    else
      @task = Task.find(params[:id])
    end
  end

end
