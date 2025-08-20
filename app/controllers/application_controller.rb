class ApplicationController < ActionController::API
  include Authentication
  
  before_action :set_default_response_format

  private

  def set_default_response_format
    request.format = :json
  end
end
