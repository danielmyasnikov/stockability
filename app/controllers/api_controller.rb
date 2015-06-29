class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  rescue_from ActiveRecord::ActiveRecordError,
    with: :show_errors

  rescue_from Apipie::ParamMissing, ActionController::ParameterMissing,
    with: :missing_param

  def missing_param(_error)
    render json:
      { error: _error.message, data: 'missing param' }, status: 400
  end

  def show_errors(_error)
    render json:
      { error: _error.message }, status: 422
  end
end
