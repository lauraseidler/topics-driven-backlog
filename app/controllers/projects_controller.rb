class ProjectsController < ApplicationController
  include ProjectsHelper

  before_action :set_course, only: [:create]
  before_action :set_project, only: [:show, :update, :destroy, :enroll_user, :remove_enrollment]
  before_action :validate_users, only: [:create, :update]

  # GET /projects/:id
  def show
    json_response(@project)
  end

  # POST /projects/:id/enrollments
  def enroll_user
    @project.users << current_user
    json_response(@project, :created)
  end

  # POST /courses/:course_id/projects
  def create
    @project = @course.projects.create!(project_params)
    @project.users << current_user
    json_response(@project, :created)
  end

  # PUT /projects/:id
  # PATCH /projects/:id
  def update
    @project.update_attributes!(project_params)
    json_response(@project)
  end

  # DELETE /projects/:id
  def destroy
    authorize! :destroy, @project
    @project.destroy!
    head :no_content
  end

  # DELETE /projects/:project_id/enrollment
  def remove_enrollment
    @project.users.delete(current_user)
    head :no_content
  end

  private

  def project_params
    # whitelist params
    params.permit(:title, :user_ids => [])
  end

  def set_course
    @course = Course.find_by!(id: params[:course_id])
  end

  def set_project
    @project = Project.find_by(id: params[:id])
    if @project.nil?
      @project = Project.find_by!(id: params[:project_id])
    end
  end

end
