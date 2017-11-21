class SprintsController < ApplicationController
  before_action :set_course, only: [:create]
  before_action :set_sprint, only: [:update, :destroy]

  # POST /courses/course_id/sprints
  def create
    @sprint = @course.sprints.create!(sprint_params)
    json_response(@sprint, :created)
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
    params.permit(:name, :end_date, :start_date)
  end

  def set_course
    @course = Course.find_by!(id: params[:course_id])
  end

  def set_sprint
    @sprint = Sprint.find_by!(id: params[:id])
  end

end
