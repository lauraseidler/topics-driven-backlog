class ProjectsController < ApplicationController
  include ProjectsHelper
  include CanCan::ControllerAdditions

  before_action :set_course, only: [:create]
  before_action :set_project, only: [:show, :update, :destroy, :enroll_user, :remove_enrollment]
  before_action :validate_users, only: [:create, :update]
  load_and_authorize_resource :except => [:create, :enroll_user, :remove_enrollment]

  # GET /projects/:id
  def show
    json_response(@project)
  end

  # POST /projects/:id/enrollments
  def enroll_user
    authorize! :enrollment, @project
    @project.users << current_user
    json_response(@project, :created)
  end

  # POST /courses/:course_id/projects
  def create
    authorize! :create, Project, @course
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
    @project.destroy!
    head :no_content
  end

  # DELETE /projects/:project_id/enrollment
  def remove_enrollment
    authorize! :enrollment, @project
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
  #
  # def check_abilities(action, course, project)
  #   case action
  #     when :enrollment
  #         enrollment_allowed(@course)
  #     when :create
  #
  #
  #   end
    # can :create, Project do
    #   enrollment_allowed(@course)
    # end
    #
    # can [:create, :enrollment], Project do |project|
    #   enrollment_allowed(project.course)
    # end
    #
    # can [:update, :delete], Project do |project|
    #   is_instructor(project.course) ||
    #       ( is_member(project) && enrollment_allowed(project.course) )
    # end
  # end
  #
  # def enrollment_allowed(course)
  #   course.allow_enrollment
  # end

end
