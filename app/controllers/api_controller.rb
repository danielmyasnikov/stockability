class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  # create custom error handler, so you can rise and catch exceptions inside v1 controller

  rescue_from ActiveRecord::RecordInvalid,
    with: :show_errors

  rescue_from CanCan::AccessDenied, with: :show_denied_access

  rescue_from ActionController::ParameterMissing,
    with: :missing_param

  def show_denied_access(_error)
    render json:
      { error: _error.message, data: '[UNAUTHORIZED] Forbidden access' }, status: 403
  end

  def missing_param(_error)
    render json:
      { error: _error.message, data: 'missing param' }, status: 400
  end

  def show_errors(_error)
    render json: { error: _error.message }, status: 422
  end
end
