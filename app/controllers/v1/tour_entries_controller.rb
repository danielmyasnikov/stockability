class V1::TourEntriesController < V1::BaseController
  api!
  desc "Returns ALL accessible by a admin/manager/operator tour entires
    GET /api/v1/tour_entries.json?auth[token]=c4c7-7e32&since=2015-08-04T10:24:35.729Z
  "
  param :since, String, desc: 'Displays tour entries since the date, eg "2015-08-04T10:24:35.729Z"'
  def index
    @tour_entries = TourEntry.accessible_by(current_ability).since(since_params[:since])
    render json: @tour_entries
  end

  api!
  desc "Returns a SINGLE tour entry accessible by a admin/manager products
    GET /api/v1/tour_entries/1.json?auth[token]=c4c7-7e32
  "
  def show
    render json: @tour_entry
  end

  api!
  desc "Creates tour entry item
    POST /api/v1/tour_entries.json?auth[token]=c4c7-7e32&tour_entry[tour_id]=1&tour_entry[sku]=SKU001&tour_entry[quantity]=1&tour_entry[location_code]=LOC001&tour_entry[barcode]=BAR001
  "
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
  desc "Updates tour entry item
    PUT /api/v1/tour_entries/1.json?auth[token]=c4c7-7e32&tour_entry[tour_id]=1&tour_entry[sku]=SKU001&tour_entry[quantity]=1&tour_entry[location_code]=LOC001&tour_entry[barcode]=BAR001
  "
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
  desc "Deletes a tour entry (by database ID)
    DELETE /api/v1/tour_entries/1.json?auth[token]=c4c7-7e32
  "
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
    { company_id: current_user.company_id }
  end
end
