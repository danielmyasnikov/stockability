class V1::BaseController < ApiController
  before_action :token_presence
  before_action :token_authorize!
  respond_to :json

  api :GET, '/v1/my-awesome-request?auth[token]=my-awesome-token'
  desc 'Any request requires authentication token'
  param :auth, Hash, required: true  do
    param :token, String, required: true
  end
  def any_request; end

private
  def token_presence
    if token_params[:token].blank?
      render json: { text: 'Forbidden access. Please authenticate' }, status: 403
      return
    end
  end

  def token_authorize!
    @current_admin = Admin.find_by_token(token_params[:token])
    render json: { text: 'Forbidden access. Please authenticate' }, status: 403 if current_admin.nil?
    return
  end

  def token_params
    params.fetch(:auth, {}).permit(:token)
  end
end
