class CreateTours < ActiveRecord::Migration

  def change
    create_table :tours do |t|
      t.string :name
      t.references :admin
      t.boolean :active
      t.datetime :started
      t.datetime :completed
      t.timestamps
    end
  end

end