class CreateCompanies < ActiveRecord::Migration

  def change
    create_table :companies do |t|
      t.string :title
      t.string :description
      t.string :address
      t.string :suburb
      t.string :postcode
      t.string :state
      t.string :phone
      t.string :abn
      t.string :acn
      t.timestamps
    end
  end

end