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
class Recipe < ApplicationRecord
  # Associations
  has_and_belongs_to_many :categories
  has_one_attached :image
  
  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :ingredients, :instructions, presence: true
  validates :prep_time, :cook_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :servings, numericality: { only_integer: true, greater_than: 0 }
  validates :difficulty, inclusion: { in: %w[easy medium hard], message: "must be easy, medium, or hard" }
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  
  # Scopes
  scope :search, ->(query) {
    where("title LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") if query.present?
  }
  
  scope :by_difficulty, ->(level) { where(difficulty: level) if level.present? }
  scope :by_cook_time, ->(max_time) { where("cook_time <= ?", max_time) if max_time.present? }
  scope :by_category, ->(category_id) { joins(:categories).where(categories: { id: category_id }) if category_id.present? }
  scope :by_rating, ->(min_rating) { where("rating >= ?", min_rating) if min_rating.present? }
  
  # Instance methods
  def total_time
    prep_time.to_i + cook_time.to_i
  end
  
  def category_names
    categories.pluck(:name).join(', ')
  end
  
  def image_url
    return unless image.attached?
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
  end
end
