class CreateLocations < ActiveRecord::Migration

  def change
    create_table :locations do |t|
      t.string :code
      t.string :name
      t.string :phone
      t.string :email
      t.string :address
      t.string :address2
      t.string :address3
      t.string :suburb
      t.string :state
      t.string :postcode
      t.string :country
      t.string :description
      t.timestamps
    end
  end

end