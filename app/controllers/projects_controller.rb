class ProjectsController < ApplicationController
  include CanCan::ControllerAdditions

  before_action :set_course, only: [:create]
  before_action :set_project, only: [:show, :update, :destroy, :enroll_user, :remove_enrollment, :complete_sprint]
  load_and_authorize_resource :except => [:show, :create, :destroy, :enroll_user, :remove_enrollment, :complete_sprint]

  # GET /projects/:id
  def show
    json_response(@project)
  end

  # POST /projects/:id/enrollments
  def enroll_user
    authorize! :enroll, @project

    if !@project.user_ids.include?(current_user.id)
      @project.users << current_user
    end
    json_response(@project, :created)
  end

  # POST /courses/:course_id/projects
  def create
    authorize! :create_projects, @course
    @project = @course.projects.create!(project_params)
    @course.sprints.each do |sprint|
      @project.sprint_plannings.create(sprint_id: sprint.id, planned: false)
    end
    @project.users << current_user
    json_response(@project, :created)
  end

  # PUT /projects/:id
  # PATCH /projects/:id
  def update
    @project.update_attributes!(project_params)
    json_response(@project)
  end

  # PUT /project/:project_id/sprint-planning-complete/:sprint_id
  # PATCH /project/:project_id/sprint-planning-complete/:sprint_id
  def complete_sprint
    authorize! :update, @project
    sprint_planning = @project.sprint_plannings.find_by!(sprint_id: params[:sprint_id])
    sprint_planning.update_attribute(:planned, true)
    json_response(@project)
  end

  # DELETE /projects/:id
  def destroy
    authorize! :delete, @project
    @project.destroy!
    head :no_content
  end

  # DELETE /projects/:project_id/enrollment
  def remove_enrollment
    authorize! :disenroll, @project
    @project.users.delete(current_user)
    head :no_content
  end

  private

  def project_params
    # whitelist params
    params.permit(:title)
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
