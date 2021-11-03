class CreateUser < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :username
      t.integer :auth_role

      t.timestamps
    end
  end
end
