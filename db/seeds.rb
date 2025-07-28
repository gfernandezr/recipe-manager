# Clear existing data
Recipe.destroy_all
Category.destroy_all

# Create categories
categories = [
  { name: 'Breakfast', color: '#FFA07A' },
  { name: 'Lunch', color: '#98FB98' },
  { name: 'Dinner', color: '#87CEEB' },
  { name: 'Dessert', color: '#DDA0DD' },
  { name: 'Vegetarian', color: '#90EE90' },
  { name: 'Vegan', color: '#20B2AA' },
  { name: 'Gluten-Free', color: '#F0E68C' },
  { name: 'Quick & Easy', color: '#FFD700' }
]

categories.each do |category_attrs|
  Category.find_or_create_by!(name: category_attrs[:name]) do |category|
    category.color = category_attrs[:color]
  end
end

# Create sample recipes
recipes = [
  {
    title: 'Classic Pancakes',
    description: 'Fluffy and delicious breakfast pancakes that everyone will love!',
    ingredients: "1 1/2 cups all-purpose flour\n3 1/2 teaspoons baking powder\n1 teaspoon salt\n1 tablespoon white sugar\n1 1/4 cups milk\n1 egg\n3 tablespoons butter, melted",
    instructions: "1. In a large bowl, sift together the flour, baking powder, salt and sugar.\n2. Make a well in the center and pour in the milk, egg and melted butter; mix until smooth.\n3. Heat a lightly oiled griddle or frying pan over medium-high heat.\n4. Pour or scoop the batter onto the griddle, using approximately 1/4 cup for each pancake.\n5. Brown on both sides and serve hot.",
    prep_time: 10,
    cook_time: 15,
    servings: 4,
    difficulty: 'easy',
    categories: ['Breakfast', 'Quick & Easy'],
    rating: 5
  },
  {
    title: 'Vegetable Stir Fry',
    description: 'A quick and healthy vegetable stir fry that is packed with flavor and nutrients.',
    ingredients: "2 tablespoons vegetable oil\n4 cups mixed vegetables (bell peppers, broccoli, carrots, snap peas)\n2 cloves garlic, minced\n1 tablespoon ginger, grated\n3 tablespoons soy sauce\n1 tablespoon honey\n1 teaspoon sesame oil\n2 green onions, sliced\n1 tablespoon sesame seeds",
    instructions: "1. Heat oil in a large wok or skillet over high heat.\n2. Add garlic and ginger, stir for 30 seconds until fragrant.\n3. Add the vegetables and stir-fry for 5-7 minutes until crisp-tender.\n4. In a small bowl, whisk together soy sauce, honey, and sesame oil.\n5. Pour the sauce over the vegetables and toss to coat.\n6. Cook for another 2 minutes until the sauce thickens slightly.\n7. Garnish with green onions and sesame seeds before serving.",
    prep_time: 15,
    cook_time: 10,
    servings: 4,
    difficulty: 'easy',
    categories: ['Lunch', 'Dinner', 'Vegetarian', 'Quick & Easy'],
    rating: 4
  },
  {
    title: 'Chocolate Chip Cookies',
    description: 'Classic chocolate chip cookies that are soft in the middle and crispy on the edges.',
    ingredients: "2 1/4 cups all-purpose flour\n1 teaspoon baking soda\n1 teaspoon salt\n1 cup (2 sticks) butter, softened\n3/4 cup granulated sugar\n3/4 cup packed brown sugar\n1 teaspoon vanilla extract\n2 large eggs\n2 cups (12-oz. pkg.) semi-sweet chocolate chips\n1 cup chopped nuts (optional)",
    instructions: "1. Preheat oven to 375°F (190°C).\n2. Combine flour, baking soda and salt in small bowl.\n3. Beat butter, granulated sugar, brown sugar and vanilla extract in large mixer bowl until creamy.\n4. Add eggs one at a time, beating well after each addition.\n5. Gradually beat in flour mixture.\n6. Stir in chocolate chips and nuts.\n7. Drop by rounded tablespoon onto ungreased baking sheets.\n8. Bake for 9 to 11 minutes or until golden brown.\n9. Cool on baking sheets for 2 minutes; remove to wire racks to cool completely.",
    prep_time: 20,
    cook_time: 10,
    servings: 48,
    difficulty: 'medium',
    categories: ['Dessert'],
    rating: 3
  }
]

recipes.each do |recipe_attrs|
  categories = recipe_attrs.delete(:categories)
  recipe = Recipe.create!(recipe_attrs)
  
  categories.each do |category_name|
    category = Category.find_by!(name: category_name)
    recipe.categories << category unless recipe.categories.include?(category)
  end
end

puts "Created #{Category.count} categories and #{Recipe.count} recipes!"
