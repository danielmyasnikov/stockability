class V1::BaseController < ApiController
  
  before_action :token_presence
  before_action :token_authorize!

  load_and_authorize_resource :except => [:create]
  respond_to :json

  rescue_from Apipie::ParamInvalid, Apipie::ParamMissing,
      with: :error_params

  api :GET, '/v1/my-awesome-request?auth[token]=my-awesome-token'
  desc 'Any request requires authentication token'
  param :auth, Hash, required: true  do
    param :token, String, required: true
  end
  def any_request; end

  def error_params(_error)
    render json: { error: _error.message }, status: 400
  end

private
  def token_presence
    if token_params[:token].blank?
      render json: { text: 'Forbidden access. Please supply token' }, status: 403
      return
    end
  end

  def token_authorize!
    @current_user = User.find_by_token(token_params[:token])
    render json: { text: 'Forbidden access. Admin / Manager / Operator were not found' }, status: 403 if current_user.nil?
    return
  end

  def token_params
    params.fetch(:auth, {}).permit(:token)
  end

  def company_params
    { company_id: current_user.company_id }
  end

  def since_params
    params.permit(:since)
  end
end
