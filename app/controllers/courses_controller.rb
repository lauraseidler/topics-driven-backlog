class CoursesController < ApplicationController
  include CanCan::ControllerAdditions

  before_action :set_course, only: [:show, :update, :destroy, :add_instructor, :remove_instructor]
  load_and_authorize_resource :except => :destroy

  # GET /courses
  def index
    @courses = Course.all
    json_response(@courses)
  end

  # POST /courses
  def create
    @course = Course.create!(course_params)
    @course.instructions.create!(user_id: current_user.id, initial_instructor: true)
    json_response(@course, :created)
  end

  # GET /courses/:id
  def show
    json_response(@course)
  end

  # PUT /courses/:id
  # PATCH /courses/:id
  def update
    @course.update!(course_params)
    json_response(@course)
  end

  # DELETE /courses/:id
  def destroy
    authorize! :delete, @course
    @course.destroy!
    head :no_content
  end

  # POST /courses/:id/instructor
  def add_instructor
    email_address = course_params[:instructor]
    instructor = User.find_by(email: email_address)
    if instructor.nil?
      instructor = User.create!(email: email_address, role: User.roles[:student])
    end
    @course.instructions.build(user_id: instructor.id, initial_instructor: false)
    json_response(@course, :created)
  end

  # DELETE /courses/:id/instructor
  def remove_instructor
    user = User.find_by!(email: course_params[:instructor])
    if user.present?
      @course.instructions.delete(user)
    end
    head :no_content
  end

  private

  def course_params
    # whitelist params
    params.permit(:title, :hyperlink, :semester_type, :semester_year, :short_title, :allow_enrollment, :instructor)
  end

  def set_course
    @course = Course.find_by!(id: params[:id])
  end

end
