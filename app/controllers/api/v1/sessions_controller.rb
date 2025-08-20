class Api::V1::SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      head :ok
    else
      head :unauthorized
    end
  end

  def destroy
    terminate_session
    head :no_content
  end
end
