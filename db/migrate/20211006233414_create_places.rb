class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.string :name, :null => false
      t.float :lat, :null => false
      t.float :lon, :null => false
      t.string :slug, :null => false, unique: true
      t.integer :rating, :null => false

      t.timestamps
    end
  end
end
