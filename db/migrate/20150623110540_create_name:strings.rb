class CreateName:strings < ActiveRecord::Migration

  def change
    create_table :name:strings do |t|
      t.references :admin
      t.boolean :active
      t.datetime :started
      t.datetime :completed
      t.timestamps
    end
  end

end