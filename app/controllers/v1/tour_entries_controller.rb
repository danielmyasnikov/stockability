class V1::TourEntriesController < V1::BaseController
  load_and_authorize_resource except: :create

  api!
  desc 'Returns ALL accessible by a admin/manager/operator tour entires'
  param :since, String, desc: 'Displays tour entries since the date, eg "2015-08-04T10:24:35.729Z"'
  def index
    @tour_entries = TourEntry.accessible_by(current_ability).since(since_params)
    render json: @tour_entries
  end

  api!
  desc 'Returns a SINGLE tour entry accessible by a admin/manager products'
  def show
    render json: @tour_entry
  end

  api!
  desc 'Creates tour entry item'
  param :tour_entry, Hash, required: true do
    param :tour_id,       String, required: true
    param :sku,           String, required: true
    param :batch_code,    String
    param :quantity,      String
    param :location_code, String, required: true
    param :bin_code,      String
    param :barcode,       String, required: true
    param :active,        String
  end
  def create
    @tour_entry = TourEntry.create!(tour_entry_params.merge(company_params))
    render json: @tour_entry
  end

  api!
  desc 'Updates tour entry item'
  param :tour_entry, Hash, required: true do
    param :tour_id,       String, required: true
    param :sku,           String, required: true
    param :batch_code,    String
    param :quantity,      String
    param :location_code, String, required: true
    param :bin_code,      String
    param :barcode,       String, required: true
    param :active,        String
  end
  def update
    @tour_entry.update_attributes!(tour_entry_params)
    render json: @tour_entry
  end

  api!
  desc 'Deletes a tour entry (by database ID)'
  def destroy
    @tour_entry.destroy
    render json: @tour_entry
  end

private

  def tour_entry_params
    params.require(:tour_entry).permit(
      :tour_id, :sku, :batch_code, :quantity, :location_code, :bin_code, :barcode,
      :active)
  end

  def since_params
    params.permit(:since)
  end

  def company_params
    { company_id: current_admin.company_id }
  end
end
