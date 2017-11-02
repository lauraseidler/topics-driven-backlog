class BacklogsController < ApplicationController
  before_action :set_backlog, only: [:show, :update, :destroy]

  # POST /backlogs
  def create
    @backlog = Backlog.create!(backlog_params)
    json_response(@backlog, :created)
  end

  # GET /backlogs/:id
  def show
    json_response(@backlog)
  end

  # PUT /backlogs/:id
  # PATCH /backlogs/:id
  def update
    @backlog.update(backlog_params)
    head :no_content
  end

  # DELETE /backlogs/:id
  def destroy
    @backlog.destroy
    head :no_content
  end

  private

  def backlog_params
    # whitelist params
    params.permit
  end

  def set_backlog
    @backlog = Backlog.find(params[:id])
  end

end
