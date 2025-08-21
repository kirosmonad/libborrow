class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Authentication
  include Pundit::Authorization

  before_action :set_default_response_format
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: "You are not authorized to perform this action" }, status: :forbidden
  end

  def set_default_response_format
    request.format = :json
  end
end
