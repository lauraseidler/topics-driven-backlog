class TasksController < ApplicationController
  before_action :set_backlog
  before_action :set_story, only: [:show, :create, :update, :destroy]
  before_action :set_story_task, only: [:show, :update, :destroy]

  # GET /backlogs/:backlog_id/stories/:story_id/tasks
  # GET /backlogs/:backlog_id/tasks
  def index
    if params[:story_id]
      set_story
      json_response(@story.tasks)
    else
      @stories = @backlog.stories
      task_list = []
      @stories.each do |story|
        task_list.concat(story.tasks.all)
      end
      json_response(task_list)
    end
  end

  # GET /backlogs/:backlog_id/stories/:story_id/tasks/:id
  def show
    json_response(@task)
  end

  # POST /backlogs/:backlog_id/stories/:story_id/tasks
  def create
    @task = @story.tasks.create!(task_params)
    json_response(@task, :created)
  end

  # PUT /backlogs/:backlog_id/stories/:story_id/tasks/:id
  # PATCH /backlogs/:backlog_id/stories/:story_id/tasks/:id
  def update
    @task.update(task_params)
    head :no_content
  end

  # DELETE /backlogs/:backlog_id/stories/:story_id/tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  private

  def task_params
    params.permit(:title, :description)
  end

  def set_backlog
    @backlog = Backlog.find(params[:backlog_id])
  end

  def set_story
    @story = @backlog.stories.find_by!(id: params[:story_id]) if @backlog
  end

  def set_story_task
    if @story
      @task = @story.tasks.find_by!(id: params[:id])
    else
      @task = Task.find(params[:id])
    end
  end

end
