class V1::BaseController < ApiController
  before_action :token_presence
  before_action :token_authorize!
  respond_to :json

private
  def token_presence
    if token_params[:token].blank?
      render json: { text: 'Forbidden access. Please authenticate' }, status: 403 if @client.nil?
      return
    end
  end

  def token_authorize!
    @client = Admin.find_by_token(token_params[:token])
    render json: { text: 'Forbidden access. Please authenticate' }, status: 403 if @client.nil?
    return
  end

  def token_params
    params.require(:auth).permit(:token)
  end
end
