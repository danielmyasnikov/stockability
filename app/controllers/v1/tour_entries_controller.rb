class V1::TourEntriesController < V1::BaseController
  load_and_authorize_resource except: :create

  def index
    @tour_entries = TourEntry.accessible_by(current_ability).since(since_params)
    render json: @tour_entries
  end

  def show
    render json: @tour_entry
  end

  def create
    @tour_entry = TourEntry.create!(tour_entry_params.merge(company_params))
    render json: @tour_entry
  end

  def update
    @tour_entry.update_attributes!(tour_entry_params)
    render json: @tour_entry
  end

  def destroy
    @tour_entry.destroy
    render json: @tour_entry
  end

private

  def tour_entry_params
    params.require(:tour_entry).permit(
      :tour_id, :sku, :batch_code, :quantity, :location_id, :bin_id, :barcode,
      :active)
  end

  def since_params
    params.permit(:since)
  end

  def company_params
    { company_id: current_admin.company_id }
  end
end
