<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Recipes</h1>
      <router-link 
        to="/recipes/new" 
        class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 transition-colors"
      >
        Add Recipe
      </router-link>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-6 mb-8">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
        <div class="md:col-span-2">
          <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Search</label>
          <input
            type="text"
            id="search"
            v-model="filters.search"
            placeholder="Search recipes..."
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
        </div>
        <div>
          <label for="difficulty" class="block text-sm font-medium text-gray-700 mb-1">Difficulty</label>
          <select
            id="difficulty"
            v-model="filters.difficulty"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="">All</option>
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </select>
        </div>
        <div>
          <label for="category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
          <select
            id="category"
            v-model="filters.categoryId"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="">All Categories</option>
            <option v-for="category in categories" :key="category.id" :value="category.id">
              {{ category.attributes.name }}
            </option>
          </select>
        </div>
        <div>
          <label for="rating" class="block text-sm font-medium text-gray-700 mb-1">Minimum Rating</label>
          <select
            id="rating"
            v-model="filters.rating"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="">Any Rating</option>
            <option value="5">5 stars</option>
            <option value="4">4+ stars</option>
            <option value="3">3+ stars</option>
            <option value="2">2+ stars</option>
            <option value="1">1+ star</option>
          </select>
        </div>
      </div>
      <div class="mt-4 flex justify-end">
        <button
          @click="resetFilters"
          class="text-sm text-indigo-600 hover:text-indigo-800"
        >
          Reset filters
        </button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading && !recipes.length" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-indigo-600"></div>
      <p class="mt-2 text-gray-600">Loading recipes...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
      <div class="flex">
        <div class="flex-shrink-0">
          <svg class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="ml-3">
          <p class="text-sm text-red-700">{{ error }}</p>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else-if="!filteredRecipes.length" class="text-center py-12 bg-white rounded-lg shadow">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <h3 class="mt-2 text-lg font-medium text-gray-900">No recipes found</h3>
      <p class="mt-1 text-sm text-gray-500">
        {{ hasActiveFilters ? 'Try adjusting your search or filter' : 'Get started by creating a new recipe' }}
      </p>
      <div class="mt-6">
        <router-link
          to="/recipes/new"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
          New Recipe
        </router-link>
      </div>
    </div>

    <!-- Recipe Grid -->
    <div v-else class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
      <div v-for="recipe in filteredRecipes" :key="recipe.id" class="bg-white rounded-lg shadow overflow-hidden hover:shadow-md transition-shadow">
        <div class="h-48 bg-gray-200 relative">
          <img 
            v-if="recipe.attributes.imageUrl" 
            :src="recipe.attributes.imageUrl" 
            :alt="recipe.attributes.title"
            class="w-full h-full object-cover"
          />
          <div v-else class="w-full h-full flex items-center justify-center text-gray-400">
            <svg class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
          <div class="absolute top-2 right-2">
            <span 
              class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
              :class="getDifficultyClass(recipe.attributes.difficulty)"
            >
              {{ recipe.attributes.difficulty }}
            </span>
          </div>
        </div>
        <div class="p-4">
          <h3 class="text-lg font-semibold text-gray-900 mb-1">
            <router-link 
              :to="{ name: 'recipe', params: { id: recipe.id } }"
              class="hover:text-indigo-600 transition-colors"
            >
              {{ recipe.attributes.title }}
            </router-link>
          </h3>
          <p class="text-sm text-gray-600 line-clamp-2 mb-3">{{ recipe.attributes.description }}</p>
          
          <div class="flex items-center text-sm text-gray-500 space-x-4">
            <div class="flex items-center">
              <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              {{ recipe.attributes.totalTime }} min
            </div>
            <div class="flex items-center">
              <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              {{ recipe.attributes.servings }} servings
            </div>
          </div>
          
          <!-- Rating -->
          <div class="mt-2">
            <RecipeRating 
              :rating="recipe.attributes.rating" 
              :editable="false" 
              :show-text="false"
            />
          </div>
          
          <div v-if="recipe.relationships.categories.data.length" class="mt-3 pt-3 border-t border-gray-100">
            <div class="flex flex-wrap gap-1">
              <span 
                v-for="category in getRecipeCategories(recipe.relationships.categories.data)" 
                :key="category.id"
                class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
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
      </div>
    </div>

    <!-- Pagination -->
    <div v-if="!loading && pagination.totalPages > 1" class="mt-8 flex justify-center">
      <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
        <button
          @click="changePage(pagination.currentPage - 1)"
          :disabled="pagination.currentPage === 1"
          class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
          :class="{ 'opacity-50 cursor-not-allowed': pagination.currentPage === 1 }"
        >
          <span class="sr-only">Previous</span>
          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
        </button>
        
        <button
          v-for="page in visiblePages"
          :key="page"
          @click="changePage(page)"
          :class="{
            'z-10 bg-indigo-50 border-indigo-500 text-indigo-600': page === pagination.currentPage,
            'bg-white border-gray-300 text-gray-500 hover:bg-gray-50': page !== pagination.currentPage
          }"
          class="relative inline-flex items-center px-4 py-2 border text-sm font-medium"
        >
          {{ page }}
        </button>
        
        <button
          @click="changePage(pagination.currentPage + 1)"
          :disabled="pagination.currentPage === pagination.totalPages"
          class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
          :class="{ 'opacity-50 cursor-not-allowed': pagination.currentPage === pagination.totalPages }"
        >
          <span class="sr-only">Next</span>
          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
        </button>
      </nav>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRecipeStore } from '../stores/recipe'
import { useCategoryStore } from '../stores/category'
import RecipeRating from '../components/RecipeRating.vue'

const recipeStore = useRecipeStore()
const categoryStore = useCategoryStore()

// Local filters
const filters = ref({
  search: '',
  difficulty: '',
  categoryId: '',
  rating: ''
})

// Computed properties
const loading = computed(() => recipeStore.loading || categoryStore.loading)
const error = computed(() => recipeStore.error || categoryStore.error)
const recipes = computed(() => recipeStore.recipes)
const categories = computed(() => categoryStore.categories)
const filteredRecipes = computed(() => recipeStore.filteredRecipes)
const pagination = computed(() => recipeStore.pagination)
const hasActiveFilters = computed(() => {
  return filters.value.search || filters.value.difficulty || filters.value.categoryId || filters.value.rating
})

// Get visible pages for pagination
const visiblePages = computed(() => {
  const pages = []
  const maxVisible = 5
  const half = Math.floor(maxVisible / 2)
  let start = Math.max(1, pagination.value.currentPage - half)
  let end = Math.min(pagination.value.totalPages, start + maxVisible - 1)
  
  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1)
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  
  return pages
})

// Methods
const getDifficultyClass = (difficulty) => {
  const classes = {
    easy: 'bg-green-100 text-green-800',
    medium: 'bg-yellow-100 text-yellow-800',
    hard: 'bg-red-100 text-red-800'
  }
  return classes[difficulty] || 'bg-gray-100 text-gray-800'
}

const getRecipeCategories = (categoryRefs) => {
  return categoryRefs
    .map(ref => categoryStore.getCategoryById(ref.id))
    .filter(Boolean)
}

const applyFilters = () => {
  recipeStore.setFilters({
    search: filters.value.search,
    difficulty: filters.value.difficulty,
    categoryId: filters.value.categoryId,
    rating: filters.value.rating
  })
}

const resetFilters = () => {
  filters.value = {
    search: '',
    difficulty: '',
    categoryId: '',
    rating: ''
  }
  recipeStore.resetFilters()
}

const changePage = (page) => {
  if (page >= 1 && page <= pagination.value.totalPages) {
    recipeStore.fetchRecipes(page)
  }
}

// Watch for filter changes with debounce
let filterTimeout = null
watch(
  () => [filters.value.search, filters.value.difficulty, filters.value.categoryId, filters.value.rating],
  () => {
    clearTimeout(filterTimeout)
    filterTimeout = setTimeout(() => {
      applyFilters()
    }, 300)
  },
  { deep: true }
)

// Lifecycle hooks
onMounted(async () => {
  await categoryStore.fetchCategories()
  await recipeStore.fetchRecipes()
})
</script>
