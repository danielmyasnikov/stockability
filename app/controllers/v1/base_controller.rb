class V1::BaseController < ApiController
  # before_action :token_authorize!
  respond_to :json

private
  def token_authorize!
    @client = params[:token]
  end

  def json_client_params
    params.require(:client).permit(:token)
  end
end
