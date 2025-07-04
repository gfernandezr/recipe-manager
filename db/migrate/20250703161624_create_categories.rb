class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :color, default: '#6c757d'  # Bootstrap secondary color as default

      t.timestamps
    end
    
    add_index :categories, :name, unique: true
  end
end
