class FrontendController < ApplicationController
  skip_before_action :authorize_request, only: :index

  def index
  end
end
