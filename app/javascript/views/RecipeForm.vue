<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <h1 class="text-2xl font-bold text-gray-900 mb-6">
      {{ isEditing ? 'Edit Recipe' : 'Add New Recipe' }}
    </h1>

    <form @submit.prevent="handleSubmit" class="space-y-8">
      <!-- Recipe Details Card -->
      <div class="bg-white shadow rounded-lg overflow-hidden">
        <div class="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Recipe Details</h2>
        </div>
        <div class="px-4 py-5 sm:p-6 space-y-6">
          <!-- Title -->
          <div>
            <label for="title" class="block text-sm font-medium text-gray-700">
              Title <span class="text-red-500">*</span>
            </label>
            <input
              type="text"
              id="title"
              v-model="formData.title"
              required
              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
              :class="{ 'border-red-300': errors.title }"
            />
            <p v-if="errors.title" class="mt-1 text-sm text-red-600">{{ errors.title }}</p>
          </div>

          <!-- Description -->
          <div>
            <label for="description" class="block text-sm font-medium text-gray-700">
              Description
            </label>
            <textarea
              id="description"
              v-model="formData.description"
              rows="3"
              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
            ></textarea>
          </div>

          <!-- Image Upload -->
          <div>
            <label class="block text-sm font-medium text-gray-700">Recipe Image</label>
            <div class="mt-2 flex items-center">
              <div v-if="!imagePreview && !formData.imageUrl" class="flex items-center justify-center h-32 w-32 rounded-md bg-gray-100">
                <svg class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <img v-else :src="imagePreview || formData.imageUrl" alt="Recipe preview" class="h-32 w-32 rounded-md object-cover" />
              
              <div class="ml-4">
                <label class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 cursor-pointer">
                  {{ formData.image ? 'Change Image' : 'Upload Image' }}
                  <input type="file" class="hidden" accept="image/*" @change="handleImageUpload" />
                </label>
                <button 
                  v-if="imagePreview || formData.imageUrl"
                  type="button"
                  @click="removeImage"
                  class="ml-3 inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  Remove
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Ingredients Card -->
      <div class="bg-white shadow rounded-lg overflow-hidden">
        <div class="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Ingredients</h2>
          <p class="mt-1 text-sm text-gray-500">Enter each ingredient on a new line</p>
        </div>
        <div class="px-4 py-5 sm:p-6">
          <div>
            <label for="ingredients" class="block text-sm font-medium text-gray-700">
              Ingredients <span class="text-red-500">*</span>
            </label>
            <div class="mt-1">
              <textarea
                id="ingredients"
                v-model="ingredientsText"
                rows="8"
                required
                class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                :class="{ 'border-red-300': errors.ingredients }"
                placeholder="2 cups all-purpose flour\n1/2 teaspoon salt\n3 large eggs\n..."
              ></textarea>
              <p v-if="errors.ingredients" class="mt-1 text-sm text-red-600">{{ errors.ingredients }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Instructions Card -->
      <div class="bg-white shadow rounded-lg overflow-hidden">
        <div class="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Instructions</h2>
          <p class="mt-1 text-sm text-gray-500">Enter each step on a new line</p>
        </div>
        <div class="px-4 py-5 sm:p-6">
          <div>
            <label for="instructions" class="block text-sm font-medium text-gray-700">
              Instructions <span class="text-red-500">*</span>
            </label>
            <div class="mt-1">
              <textarea
                id="instructions"
                v-model="instructionsText"
                rows="8"
                required
                class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                :class="{ 'border-red-300': errors.instructions }"
                placeholder="Preheat oven to 350°F (175°C)...\nIn a large bowl, mix dry ingredients...\n..."
              ></textarea>
              <p v-if="errors.instructions" class="mt-1 text-sm text-red-600">{{ errors.instructions }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Additional Info Card -->
      <div class="bg-white shadow rounded-lg overflow-hidden">
        <div class="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Additional Information</h2>
        </div>
        <div class="px-4 py-5 sm:p-6 grid grid-cols-1 gap-6 sm:grid-cols-2">
          <!-- Prep Time -->
          <div>
            <label for="prep_time" class="block text-sm font-medium text-gray-700">Prep Time (minutes)</label>
            <input
              type="number"
              id="prep_time"
              v-model.number="formData.prepTime"
              min="0"
              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
            />
          </div>

          <!-- Cook Time -->
          <div>
            <label for="cook_time" class="block text-sm font-medium text-gray-700">Cook Time (minutes)</label>
            <input
              type="number"
              id="cook_time"
              v-model.number="formData.cookTime"
              min="0"
              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
            />
          </div>

          <!-- Servings -->
          <div>
            <label for="servings" class="block text-sm font-medium text-gray-700">Servings</label>
            <input
              type="number"
              id="servings"
              v-model.number="formData.servings"
              min="1"
              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
            />
          </div>

          <!-- Difficulty -->
          <div>
            <label for="difficulty" class="block text-sm font-medium text-gray-700">Difficulty</label>
            <select
              id="difficulty"
              v-model="formData.difficulty"
              class="mt-1 block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
            >
              <option value="">Select difficulty</option>
              <option value="easy">Easy</option>
              <option value="medium">Medium</option>
              <option value="hard">Hard</option>
            </select>
          </div>

          <!-- Categories -->
          <div class="sm:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">Categories</label>
            <div v-if="categoryStore.loading" class="text-sm text-gray-500">Loading categories...</div>
            <div v-else class="flex flex-wrap gap-2">
              <label 
                v-for="category in categoryStore.getCategoriesForSelect" 
                :key="category.id"
                class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium cursor-pointer"
                :style="{ 
                  backgroundColor: formData.categoryIds.includes(category.id) ? `${category.color}20` : '#f3f4f6',
                  color: formData.categoryIds.includes(category.id) ? category.color : '#374151',
                  border: `1px solid ${formData.categoryIds.includes(category.id) ? category.color : '#e5e7eb'}`
                }"
              >
                <input
                  type="checkbox"
                  :value="category.id"
                  v-model="formData.categoryIds"
                  class="hidden"
                >
                {{ category.name }}
              </label>
            </div>
          </div>
        </div>
      </div>

      <!-- Form Actions -->
      <div class="flex justify-end space-x-3 pt-4">
        <router-link
          :to="isEditing ? { name: 'recipe', params: { id: recipeId } } : '/'"
          class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          Cancel
        </router-link>
        <button
          type="submit"
          :disabled="loading"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          {{ isEditing ? 'Update Recipe' : 'Create Recipe' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecipeStore } from '../stores/recipe'
import { useCategoryStore } from '../stores/category'

const route = useRoute()
const router = useRouter()
const recipeStore = useRecipeStore()
const categoryStore = useCategoryStore()

const recipeId = route.params.id
const isEditing = !!recipeId
const loading = ref(false)
const imagePreview = ref(null)
const errors = ref({})

// Initialize form data
const formData = ref({
  title: '',
  description: '',
  ingredients: [],
  instructions: [],
  prepTime: null,
  cookTime: null,
  servings: 4,
  difficulty: '',
  categoryIds: [],
  image: null,
  imageUrl: ''
})

// Textarea bindings for ingredients and instructions
const ingredientsText = computed({
  get: () => formData.value.ingredients.join('\n'),
  set: (value) => {
    formData.value.ingredients = value.split('\n').filter(line => line.trim() !== '')
  }
})

const instructionsText = computed({
  get: () => formData.value.instructions.join('\n'),
  set: (value) => {
    formData.value.instructions = value.split('\n').filter(line => line.trim() !== '')
  }
})

// Load recipe data when editing
const loadRecipe = async () => {
  if (!isEditing) return
  
  try {
    loading.value = true
    const recipe = await recipeStore.fetchRecipe(recipeId)
    
    if (recipe) {
      formData.value = {
        ...formData.value,
        title: recipe.attributes.title,
        description: recipe.attributes.description || '',
        ingredients: recipe.attributes.ingredients || [],
        instructions: recipe.attributes.instructions || [],
        prepTime: recipe.attributes.prepTime,
        cookTime: recipe.attributes.cookTime,
        servings: recipe.attributes.servings || 4,
        difficulty: recipe.attributes.difficulty || '',
        categoryIds: (recipe.relationships?.categories?.data || []).map(cat => cat.id),
        imageUrl: recipe.attributes.imageUrl || ''
      }
    }
  } catch (error) {
    console.error('Error loading recipe:', error)
  } finally {
    loading.value = false
  }
}

// Handle image upload
const handleImageUpload = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  // Reset file input to allow selecting the same file again
  event.target.value = null
  
  // Validate file type
  if (!file.type.startsWith('image/')) {
    errors.value.image = 'Please upload an image file'
    return
  }
  
  // Validate file size (5MB max)
  if (file.size > 5 * 1024 * 1024) {
    errors.value.image = 'Image size should be less than 5MB'
    return
  }
  
  // Create preview
  const reader = new FileReader()
  reader.onload = (e) => {
    imagePreview.value = e.target.result
  }
  reader.readAsDataURL(file)
  
  // Set the file for upload
  formData.value.image = file
  delete errors.value.image
}

// Remove image
const removeImage = () => {
  imagePreview.value = null
  formData.value.image = null
  formData.value.imageUrl = ''
  delete errors.value.image
}

// Validate form
const validateForm = () => {
  const newErrors = {}
  
  if (!formData.value.title?.trim()) {
    newErrors.title = 'Title is required'
  }
  
  if (formData.value.ingredients.length === 0) {
    newErrors.ingredients = 'At least one ingredient is required'
  }
  
  if (formData.value.instructions.length === 0) {
    newErrors.instructions = 'At least one instruction step is required'
  }
  
  errors.value = newErrors
  return Object.keys(newErrors).length === 0
}

// Handle form submission
const handleSubmit = async () => {
  if (!validateForm()) return
  
  try {
    loading.value = true
    
    const recipeData = {
      ...formData.value,
      // Convert empty strings to null for API
      description: formData.value.description || null,
      prepTime: formData.value.prepTime || null,
      cookTime: formData.value.cookTime || null,
      difficulty: formData.value.difficulty || null,
      // Remove imageUrl if we have a new image
      ...(formData.value.image && { imageUrl: undefined })
    }
    
    if (isEditing) {
      await recipeStore.updateRecipe({ id: recipeId, ...recipeData })
    } else {
      await recipeStore.createRecipe(recipeData)
    }
    
    // Redirect to the recipe view or home page
    if (isEditing) {
      router.push({ name: 'recipe', params: { id: recipeId } })
    } else {
      router.push('/')
    }
  } catch (error) {
    console.error('Error saving recipe:', error)
    // Handle API validation errors
    if (error.response?.data?.errors) {
      errors.value = { ...errors.value, ...error.response.data.errors }
    }
  } finally {
    loading.value = false
  }
}

// Load initial data
onMounted(async () => {
  await categoryStore.fetchCategories()
  if (isEditing) {
    await loadRecipe()
  }
})

// Watch for route changes to handle direct navigation between edit and new forms
watch(() => route.params.id, (newId) => {
  if (newId) {
    loadRecipe()
  } else {
    // Reset form when navigating to new recipe
    formData.value = {
      title: '',
      description: '',
      ingredients: [],
      instructions: [],
      prepTime: null,
      cookTime: null,
      servings: 4,
      difficulty: '',
      categoryIds: [],
      image: null,
      imageUrl: ''
    }
    imagePreview.value = null
    errors.value = {}
  }
}, { immediate: true })
</script>
