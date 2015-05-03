class V1::SessionsController < V1::BaseController
  before_filter :build_session

  def create
    @session.save!
    @session.create_or_update_products(session_products_params[:products])
    render json: { status: 'Ok' }
  end

protected
  def build_session
    @session = Session.new
  end

  def session_products_params
    params.permit(:format, :products => [:barcode, :quantity])
  end
end
