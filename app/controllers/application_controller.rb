class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from StandardError, with: :handle_internal_server_error

  
  private
  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def handle_internal_server_error(exception)
    render json: { error: 'Internal Server Error', message: exception.message }, status: :internal_server_error
  end
end
