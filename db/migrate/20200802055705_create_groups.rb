class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :key, unique: true
      t.text :detail
      t.timestamps
    end
  end
end
