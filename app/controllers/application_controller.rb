class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Set JSON as the default response format for API requests
  before_action :set_default_format
  
  # Skip CSRF protection for API requests
  protect_from_forgery with: :exception, unless: :api_request?
  
  # Handle 404 Not Found errors
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  private
  
  def set_default_format
    request.format = :json if api_request?
  end
  
  def api_request?
    request.path.start_with?('/api/')
  end
  
  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
  
  def render_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
