class AddSessionIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :session_id, :integer
  end
end
