<template>
  <div v-if="loading && !recipe" class="flex justify-center py-12">
    <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-600"></div>
  </div>

  <div v-else-if="error" class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
        </svg>
      </div>
      <div class="ml-3">
        <p class="text-sm text-red-700">{{ error }}</p>
        <div class="mt-4">
          <button
            @click="fetchRecipe"
            class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded text-red-700 bg-red-100 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
          >
            Try Again
          </button>
        </div>
      </div>
    </div>
  </div>

  <div v-else-if="recipe" class="max-w-4xl mx-auto px-4 py-8">
    <!-- Recipe Header -->
    <div class="mb-8">
      <div class="flex justify-between items-start">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">{{ recipe.attributes.title }}</h1>
          <p class="mt-2 text-lg text-gray-600">{{ recipe.attributes.description }}</p>
        </div>
        <div class="flex space-x-2">
          <router-link
            :to="{ name: 'edit-recipe', params: { id: recipe.id } }"
            class="inline-flex items-center px-3 py-1.5 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            <svg class="-ml-1 mr-1.5 h-4 w-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
            </svg>
            Edit
          </router-link>
          <button
            @click="confirmDelete"
            class="inline-flex items-center px-3 py-1.5 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
          >
            <svg class="-ml-1 mr-1.5 h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
            Delete
          </button>
        </div>
      </div>

      <div class="mt-4 flex flex-wrap items-center text-sm text-gray-500 gap-y-2">
        <div class="flex items-center mr-6">
          <svg class="h-5 w-5 mr-1 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span class="font-medium">{{ recipe.attributes.totalTime }} minutes</span>
          <span class="mx-1">•</span>
          <span>{{ recipe.attributes.difficulty }}</span>
        </div>
        <div class="flex items-center">
          <svg class="h-5 w-5 mr-1 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
          <span>Serves {{ recipe.attributes.servings }}</span>
        </div>
        
        <div v-if="recipe.relationships.categories.data.length" class="w-full flex flex-wrap gap-2 mt-2">
          <span 
            v-for="category in getRecipeCategories(recipe.relationships.categories.data)" 
            :key="category.id"
            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
            :style="{ 
              backgroundColor: `${category.attributes.color}20`,
              color: category.attributes.color
            }"
          >
            {{ category.attributes.name }}
          </span>
        </div>
      </div>
    </div>

    <!-- Recipe Image -->
    <div class="mb-8 rounded-lg overflow-hidden bg-gray-100">
      <img 
        v-if="recipe.attributes.imageUrl" 
        :src="recipe.attributes.imageUrl" 
        :alt="recipe.attributes.title"
        class="w-full h-96 object-cover"
      />
      <div v-else class="h-96 flex items-center justify-center text-gray-400">
        <svg class="h-24 w-24" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      </div>
    </div>

    <!-- Recipe Content -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Ingredients -->
      <div class="lg:col-span-1">
        <div class="bg-white rounded-lg shadow overflow-hidden">
          <div class="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">Ingredients</h2>
            <p class="mt-1 text-sm text-gray-500">For {{ recipe.attributes.servings }} servings</p>
          </div>
          <div class="px-4 py-5 sm:p-6">
            <ul class="space-y-3">
              <li v-for="(ingredient, index) in recipe.attributes.ingredients" :key="index" class="flex items-start">
                <span class="flex-shrink-0 h-5 flex items-center">
                  <svg class="h-4 w-4 text-indigo-500" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                  </svg>
                </span>
                <span class="ml-3 text-sm text-gray-700">{{ ingredient }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Instructions -->
      <div class="lg:col-span-2">
        <div class="bg-white rounded-lg shadow overflow-hidden">
          <div class="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">Instructions</h2>
          </div>
          <div class="px-4 py-5 sm:p-6">
            <ol class="space-y-6">
              <li v-for="(instruction, index) in recipe.attributes.instructions" :key="index" class="flex">
                <span class="flex-shrink-0 flex items-center justify-center h-8 w-8 rounded-full bg-indigo-100 text-indigo-800 text-sm font-medium mr-4">
                  {{ index + 1 }}
                </span>
                <p class="text-gray-700">{{ instruction }}</p>
              </li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <!-- Back to recipes link -->
    <div class="mt-8">
      <router-link 
        to="/" 
        class="inline-flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-900"
      >
        <svg class="mr-1 h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Back to recipes
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecipeStore } from '../stores/recipe'
import { useCategoryStore } from '../stores/category'

const route = useRoute()
const router = useRouter()
const recipeStore = useRecipeStore()
const categoryStore = useCategoryStore()

const loading = ref(true)
const error = ref(null)

// Computed properties
const recipe = computed(() => recipeStore.currentRecipe)

// Methods
const getRecipeCategories = (categoryRefs) => {
  return categoryRefs
    .map(ref => categoryStore.getCategoryById(ref.id))
    .filter(Boolean)
}

const fetchRecipe = async () => {
  if (!route.params.id) return
  
  try {
    loading.value = true
    error.value = null
    await recipeStore.fetchRecipe(route.params.id)
  } catch (err) {
    console.error('Error fetching recipe:', err)
    error.value = 'Failed to load recipe. Please try again.'
  } finally {
    loading.value = false
  }
}

const confirmDelete = () => {
  if (confirm('Are you sure you want to delete this recipe? This action cannot be undone.')) {
    deleteRecipe()
  }
}

const deleteRecipe = async () => {
  try {
    await recipeStore.deleteRecipe(recipe.value.id)
    router.push('/')
  } catch (err) {
    console.error('Error deleting recipe:', err)
    error.value = 'Failed to delete recipe. Please try again.'
  }
}

// Lifecycle hooks
onMounted(async () => {
  await categoryStore.fetchCategories()
  await fetchRecipe()
})

// Watch for route changes
watch(
  () => route.params.id,
  async (newId) => {
    if (newId) {
      await fetchRecipe()
    }
  }
)
</script>
