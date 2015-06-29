class V1::TokensController < V1::BaseController
  skip_before_action :token_presence
  skip_before_action :token_authorize!

  api!
  desc 'Creates token for further authentication'
  param :admin, Hash, required: true  do
    param :login, String
    param :email, String
    param :password, String
  end

  def create
    admin = Admin.find_by_email(authetication_params[:email])
    admin ||= Admin.find_by_email(authetication_params[:login])

    if admin.nil?
      failed
      return
    end

    if admin.valid_password?(authetication_params[:password])
      render json: { token: admin.token }, :message => 'Wrong Password'
    else
      failed('Wrong Password')
    end
  end

private

  def authetication_params
    params.require(:admin).permit(:email, :password)
  end

  def failed(message = 'Wrong Email')
    render json: { text: message }, status: 401
  end
end
