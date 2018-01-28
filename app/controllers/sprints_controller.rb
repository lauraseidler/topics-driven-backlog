class SprintsController < ApplicationController
  include SprintsHelper

  before_action :set_course, only: [:create, :create_collection]
  before_action :set_sprint, only: [:update, :destroy]
  before_action only: [:create_collection] {
    validate_sprint_collection_params(params[:start_date], params[:end_date], params[:duration].to_i)
  }
  before_action only:[:update] {
    validate_sprint_date_parameter(params[:start_date], params[:end_date])
  }
  before_action :validate_topics, only: [:create, :update]

  # POST /courses/course_id/sprints
  def create
    @sprint = @course.sprints.create!(sprint_params)
    json_response(@sprint, :created)
  end

  # POST /courses/course_id/sprint-collection
  def create_collection
    sprints = create_sprint_collection(
        params[:duration].to_i,
        params[:start_date].to_date,
        params[:end_date].to_date
    )
    json_response(sprints, :created)
  end

  # PATCH /courses/course_id/sprint-collection
  def update_collection
    sprints = update_sprint_collection(params[:collection])
    json_response(sprints)
  end

  # PUT /sprints/:id
  # PATCH /sprints/:id
  def update
    @sprint.update!(sprint_params)
    json_response(@sprint)
  end

  # DELETE /sprints/:id
  def destroy
    @sprint.destroy!
    head :no_content
  end

  private

  def sprint_params
    # whitelist params
    params.permit(:name, :end_date, :start_date, :duration, :collection, :topic_ids => [])
  end

  def set_course
    @course = Course.find_by!(id: params[:course_id])
  end

  def set_sprint
    @sprint = Sprint.find_by!(id: params[:id])
  end
end
