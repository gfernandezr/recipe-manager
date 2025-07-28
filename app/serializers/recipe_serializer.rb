# == Schema Information
#
# Table name: recipes
#
#  id           :integer          not null, primary key
#  cook_time    :integer          default(0)
#  description  :text
#  difficulty   :string           default("medium"), not null
#  ingredients  :text             not null
#  instructions :text             not null
#  prep_time    :integer          default(0)
#  rating       :integer
#  servings     :integer          default(4)
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_recipes_on_cook_time   (cook_time)
#  index_recipes_on_difficulty  (difficulty)
#  index_recipes_on_title       (title)
#
class RecipeSerializer < BaseSerializer
  attributes :id, :title, :description, :prep_time, :cook_time, :servings, 
             :difficulty, :rating, :total_time, :image_url, :created_at, :updated_at
  
  has_many :categories, serializer: CategorySerializer
  
  def total_time
    object.prep_time.to_i + object.cook_time.to_i
  end
  
  def image_url
    return unless object.image.attached?
    Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
  end
end
