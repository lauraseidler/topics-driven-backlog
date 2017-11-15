class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :update, :destroy]

  # GET /courses
  def index
    @courses = Course.all
    json_response(@courses)
  end

  # POST /courses
  def create
    @course = Course.create!(course_params)
    json_response(@course, :created)
  end

  # GET /courses/:id
  def show
    json_response(@course)
  end

  # PUT /courses/:id
  # PATCH /courses/:id
  def update
    @course.update(course_params)
    json_response(@course)
  end

  # DELETE /courses/:id
  def destroy
    @course.destroy!
    head :no_content
  end

  private

  def course_params
    # whitelist params
    params.permit(:title, :hyperlink, :start_date, :end_date)
  end

  def set_course
    @course = Course.find_by!(id: params[:id])
  end

end
