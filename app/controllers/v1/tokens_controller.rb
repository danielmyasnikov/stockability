class V1::TokensController < V1::BaseController
  skip_before_action :token_presence
  skip_before_action :token_authorize!

  api!
  desc "Creates token for further authentication.
    POST: /api/v1/tokens.json?client[email]=my.email@mail.com&client[password]=pass
  "
  param :client, Hash, required: true  do
    param :login, String
    param :email, String
    param :password, String
  end
  def create
    email = authetication_params[:email].presence
    admin = Admin.find_by_email(email) if email

    login = authetication_params[:login].presence
    admin ||= Admin.find_by_login(login) if login

    if admin.nil?
      failed
      return
    end

    if admin.valid_password?(authetication_params[:password])
      render json: { client: admin }
    else
      failed('Wrong Password')
    end
  end

private

  def authetication_params
    params.require(:client).permit(:email, :login, :password)
  end

  def failed(message = 'Wrong Email or Login')
    render json: { text: message }, status: 401
  end
end
