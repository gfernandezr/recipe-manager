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
require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
