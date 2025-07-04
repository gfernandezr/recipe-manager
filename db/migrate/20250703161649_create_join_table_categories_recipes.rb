class CreateJoinTableCategoriesRecipes < ActiveRecord::Migration[7.2]
  def change
    create_join_table :categories, :recipes do |t|
      t.index [:category_id, :recipe_id], unique: true
      t.index [:recipe_id, :category_id]
      
      t.timestamps
      
      t.foreign_key :categories, on_delete: :cascade
      t.foreign_key :recipes, on_delete: :cascade
    end
  end
end
