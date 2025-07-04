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
class Category < ApplicationRecord
  # Associations
  has_and_belongs_to_many :recipes
  
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   length: { maximum: 50 }
  validates :color, format: { with: /\A#?(?:[A-F0-9]{3}){1,2}\z/i, message: 'must be a valid hex color code' },
                    allow_blank: true
  
  # Scopes
  scope :alphabetical, -> { order(:name) }
  
  # Callbacks
  before_validation :normalize_name
  
  # Instance methods
  def recipes_count
    recipes.count
  end
  
  private
  
  def normalize_name
    self.name = name.to_s.strip.titleize
  end
end
