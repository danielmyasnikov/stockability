class AddCompanyIdToTourEntries < ActiveRecord::Migration
  def change
    add_column :tour_entries, :company_id, :integer
  end
end
