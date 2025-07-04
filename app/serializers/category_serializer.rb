# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  color      :string           default("#6c757d")
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
class CategorySerializer < BaseSerializer
  attributes :id, :name, :color, :recipes_count, :created_at, :updated_at
  
  def recipes_count
    object.recipes.count
  end
end
