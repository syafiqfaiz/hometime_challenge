class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordNotSaved, with: :render_422

  def render_404
    render json: {error: "Record not found"}
  end

  def render_422
    render json: {error: "Unprocessable Entity"}
  end
end
