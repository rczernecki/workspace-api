class RemoveSlugFromPlaces < ActiveRecord::Migration[6.1]
  def change
    remove_column :places, :slug, :string
  end
end
