class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.string :slug
      t.integer :rating

      t.timestamps
    end
  end
end
