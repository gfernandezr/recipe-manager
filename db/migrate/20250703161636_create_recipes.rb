class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :description
      t.text :ingredients, null: false
      t.text :instructions, null: false
      t.integer :prep_time, default: 0, comment: 'in minutes'
      t.integer :cook_time, default: 0, comment: 'in minutes'
      t.integer :servings, default: 4
      t.string :difficulty, default: 'medium', null: false

      t.timestamps
    end
    
    add_index :recipes, :title
    add_index :recipes, :difficulty
    add_index :recipes, :cook_time
  end
end
