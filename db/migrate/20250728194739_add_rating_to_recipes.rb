class AddRatingToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :rating, :integer
  end
end
