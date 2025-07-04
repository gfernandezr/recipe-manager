module Api
  module V1
    class BaseController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      
      # Skip CSRF protection for API requests
      skip_before_action :verify_authenticity_token
      
      # Handle record not found errors
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      
      private
      
      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end
      
      def render_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
