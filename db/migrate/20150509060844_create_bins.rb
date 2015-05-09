class CreateBins < ActiveRecord::Migration

  def change
    create_table :bins do |t|
      t.string :title
      t.string :location
      t.references :company
      t.timestamps
    end
  end

end