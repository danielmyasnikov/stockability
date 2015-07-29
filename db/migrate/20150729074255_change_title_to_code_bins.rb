class ChangeTitleToCodeBins < ActiveRecord::Migration
  def change
    rename_column :bins, :title, :code
    rename_column :stock_levels, :bin_id, :bin_code
    change_column :stock_levels, :bin_code, :string
    rename_column :stock_levels, :location_id, :location_code
    change_column :stock_levels, :location_code, :string
  end
end
