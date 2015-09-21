require 'rails_helper'

RSpec.describe Admin::StockLevelsController, type: :controller do
  describe "GET index" do
    it "assigns @stock_level_datatable" do
      get :admin_stock_levels_path, sku: 'SKU001'
      expect(ResultDatatable).to receive(:new).with_params(
        sku: 'SKU001', bin_code: nil, location_code: nil)
    end
  end
end
