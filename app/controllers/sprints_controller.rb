class SprintsController < ApplicationController
  include SprintsHelper

  before_action :set_course, only: [:create, :create_collection]
  before_action :set_sprint, only: [:update, :destroy]
  before_action :validate_sprint_collection_params, only: [:create_collection]
  before_action :validate_sprint_date_parameter, only: [:update]
  before_action :validate_sprint_collision, only: [:update]

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
   # todo
    json_response([], :created)
  end

  # PUT /sprints/:id
  # PATCH /sprints/:id
  def update
    @sprint.update_attributes!(sprint_params)
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
    params.permit(:name, :end_date, :start_date, :duration)
  end

  def set_course
    @course = Course.find_by!(id: params[:course_id])
  end

  def set_sprint
    @sprint = Sprint.find_by!(id: params[:id])
  end

end
