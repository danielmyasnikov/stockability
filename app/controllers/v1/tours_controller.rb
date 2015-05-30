class V1::ToursController < V1::BaseController
  before_filter :build_tour

  def create
    @tour.save!
    if tour_params[:tour][:products].present?
      @tour.create_or_update_products(tour_params[:tour][:products])
    end
    render json: { status: 'Ok', tour: @tour }
  end

protected
  def build_tour
    @tour = Tour.new(:admin => @client)
  end

  def tour_params
    params.permit(:tour => { :products => [:barcode, :quantity] })
  end
end
