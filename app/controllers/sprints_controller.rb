class SprintsController < ApplicationController
  include CanCan::ControllerAdditions
  include SprintsHelper

  before_action :set_sprint, only: [:update, :destroy]
  before_action :set_course, only: [:create, :create_collection, :update, :update_collection]
  before_action only: [:create_collection] {
    validate_sprint_collection_params(params[:start_date], params[:end_date], params[:duration].to_i)
  }
  before_action only:[:update] {
    validate_sprint_date_parameter(params[:start_date], params[:end_date])
  }
  before_action only: [:create, :update] {
    validate_topics(params[:topic_ids] || '', @course)
  }
  load_and_authorize_resource :except => [:create, :destroy, :create_collection, :update_collection]

  # POST /courses/:course_id/sprints
  def create
    authorize! :create, Sprint, @course
    @sprint = @course.sprints.create!(sprint_params)
    json_response(@sprint, :created)
  end

  # POST /courses/:course_id/sprint-collection
  def create_collection
    authorize! :create, Sprint, @course
    sprints = create_sprint_collection(
        params[:duration].to_i,
        params[:start_date].to_date,
        params[:end_date].to_date
    )
    json_response(sprints, :created)
  end

  # PATCH /courses/:course_id/sprint-collection
  def update_collection
    authorize! :update, Sprint, @course
    sprints = update_sprint_collection(params[:collection], @course)
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
    authorize! :delete, @sprint
    @sprint.destroy!
    head :no_content
  end

  private

  def sprint_params
    # whitelist params
    params.permit(:name, :end_date, :start_date, :duration, :collection, :topic_ids => [])
  end

  def set_sprint
    @sprint = Sprint.find_by!(id: params[:id])
  end

  def set_course
    if params[:course_id].present?
      @course = Course.find_by!(id: params[:course_id])
    else
      @course = @sprint.course
    end
  end
end
