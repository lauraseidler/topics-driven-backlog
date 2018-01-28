class TopicsController < ApplicationController
  include CanCan::ControllerAdditions

  load_and_authorize_resource
  before_action :set_course, only: [:create]
  before_action :set_topic, only: [:update, :destroy]

  # POST /courses/course_id/topics
  def create
    @topic = @course.topics.create!(topic_params)
    json_response(@topic, :created)
  end

  # PUT /topics/:id
  # PATCH /topics/:id
  def update
    @topic.update_attributes!(topic_params)
    json_response(@topic)
  end

  # DELETE /topics/:id
  def destroy
    @topic.destroy!
    head :no_content
  end

  private

  def topic_params
    # whitelist params
    params.permit(:title, :url)
  end

  def set_course
    @course = Course.find_by!(id: params[:course_id])
  end

  def set_topic
    @topic = Topic.find_by!(id: params[:id])
  end

end
