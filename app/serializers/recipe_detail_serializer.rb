class RecipeDetailSerializer < RecipeSerializer
  attributes :ingredients, :instructions, :rating
  
  def ingredients
    return [] unless object.ingredients.present?
    object.ingredients.split("\n").reject(&:blank?).map(&:strip)
  end
  
  def instructions
    return [] unless object.instructions.present?
    object.instructions.split("\n").reject(&:blank?).map(&:strip)
  end
end
