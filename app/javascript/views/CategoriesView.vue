<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Recipe Categories</h1>
      <button
        @click="showCategoryForm = true"
        class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 transition-colors"
      >
        Add Category
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-600"></div>
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
          <div class="mt-4">
            <button
              @click="fetchCategories"
              class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded text-red-700 bg-red-100 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
              Try Again
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else-if="!categories.length" class="text-center py-12">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
      </svg>
      <h3 class="mt-2 text-sm font-medium text-gray-900">No categories</h3>
      <p class="mt-1 text-sm text-gray-500">Get started by creating a new category.</p>
      <div class="mt-6">
        <button
          @click="showCategoryForm = true"
          class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
          New Category
        </button>
      </div>
    </div>

    <!-- Categories Grid -->
    <div v-else class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
      <div 
        v-for="category in categories" 
        :key="category.id"
        class="bg-white overflow-hidden shadow rounded-lg"
      >
        <div class="px-4 py-5 sm:p-6">
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <span 
                class="h-10 w-10 rounded-full flex items-center justify-center text-white font-medium"
                :style="{ backgroundColor: category.attributes.color }"
              >
                {{ category.attributes.name.charAt(0).toUpperCase() }}
              </span>
              <div class="ml-4">
                <h3 class="text-lg leading-6 font-medium text-gray-900">{{ category.attributes.name }}</h3>
                <p class="mt-1 text-sm text-gray-500">
                  {{ recipeCounts[category.id] || 0 }} recipes
                </p>
              </div>
            </div>
            <div class="flex space-x-2">
              <button
                @click="editCategory(category)"
                class="text-indigo-600 hover:text-indigo-900"
                title="Edit category"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
              </button>
              <button
                @click="confirmDelete(category)"
                class="text-red-600 hover:text-red-900"
                title="Delete category"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Category Form Modal -->
    <div v-if="showCategoryForm" class="fixed z-10 inset-0 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
          <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
          <div>
            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                {{ editingCategory ? 'Edit Category' : 'Add New Category' }}
              </h3>
              <div class="mt-5">
                <div class="mb-4">
                  <label for="category-name" class="block text-sm font-medium text-gray-700">Name</label>
                  <input
                    type="text"
                    id="category-name"
                    v-model="formData.attributes.name"
                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                    placeholder="e.g. Italian, Desserts, Vegan"
                  />
                  <p v-if="formErrors.attributes?.name" class="mt-1 text-sm text-red-600">
                    {{ formErrors.attributes.name.join(', ') }}
                  </p>
                </div>
                <div class="mb-4">
                  <label for="category-color" class="block text-sm font-medium text-gray-700">Color</label>
                  <div class="mt-1 flex items-center">
                    <input
                      type="color"
                      id="category-color"
                      v-model="formData.attributes.color"
                      class="h-10 w-16 rounded border border-gray-300"
                    />
                    <span class="ml-2 text-sm text-gray-500">{{ formData.attributes.color.toUpperCase() }}</span>
                  </div>
                  <p v-if="formErrors.attributes?.color" class="mt-1 text-sm text-red-600">
                    {{ formErrors.attributes.color.join(', ') }}
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div class="mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense">
            <button
              type="button"
              @click="saveCategory"
              :disabled="isSaving"
              class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:col-start-2 sm:text-sm disabled:opacity-50"
            >
              <span v-if="isSaving" class="flex items-center">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Saving...
              </span>
              <span v-else>{{ editingCategory ? 'Update' : 'Create' }}</span>
            </button>
            <button
              type="button"
              @click="cancelEdit"
              :disabled="isSaving"
              class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:col-start-1 sm:text-sm"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteConfirm" class="fixed z-10 inset-0 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
          <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
          <div class="sm:flex sm:items-start">
            <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
              <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
              <h3 class="text-lg leading-6 font-medium text-gray-900">Delete Category</h3>
              <div class="mt-2">
                <p class="text-sm text-gray-500">
                  Are you sure you want to delete the category "{{ categoryToDelete?.attributes?.name }}"? This action cannot be undone.
                </p>
                <p v-if="recipeCounts[categoryToDelete?.id]" class="mt-2 text-sm text-red-600">
                  Warning: This category is used by {{ recipeCounts[categoryToDelete.id] }} recipe(s).
                </p>
              </div>
            </div>
          </div>
          <div class="mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense">
            <button
              type="button"
              @click="deleteCategory"
              :disabled="isDeleting"
              class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:col-start-2 sm:text-sm disabled:opacity-50"
            >
              <span v-if="isDeleting" class="flex items-center">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Deleting...
              </span>
              <span v-else>Delete</span>
            </button>
            <button
              type="button"
              @click="showDeleteConfirm = false"
              :disabled="isDeleting"
              class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:col-start-1 sm:text-sm"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useCategoryStore } from '../stores/category'
import { useRecipeStore } from '../stores/recipe'

const categoryStore = useCategoryStore()
const recipeStore = useRecipeStore()

// State
const loading = ref(false)
const error = ref(null)
const showCategoryForm = ref(false)
const showDeleteConfirm = ref(false)
const isSaving = ref(false)
const isDeleting = ref(false)
const editingCategory = ref(null)
const categoryToDelete = ref(null)
const formErrors = ref({})

// Form data
const formData = ref({
  attributes: {
    name: '',
    color: '#3B82F6' // Default blue color
  }
})

// Computed
const categories = computed(() => categoryStore.categories)

// Get recipe counts for each category
const recipeCounts = computed(() => {
  const counts = {}
  recipeStore.recipes.forEach(recipe => {
    if (recipe.relationships?.categories?.data) {
      recipe.relationships.categories.data.forEach(category => {
        counts[category.id] = (counts[category.id] || 0) + 1
      })
    }
  })
  return counts
})

// Methods
const fetchCategories = async () => {
  loading.value = true
  error.value = null
  try {
    await categoryStore.fetchCategories()
  } catch (err) {
    console.error('Error fetching categories:', err)
    error.value = 'Failed to load categories. Please try again.'
  } finally {
    loading.value = false
  }
}

const editCategory = (category) => {
  editingCategory.value = category
  formData.value = {
    id: category.id,
    attributes: {
      name: category.attributes.name,
      color: category.attributes.color || '#3B82F6'
    }
  }
  showCategoryForm.value = true
}

const saveCategory = async () => {
  isSaving.value = true
  formErrors.value = {}
  
  try {
    if (editingCategory.value) {
      await categoryStore.updateCategory(formData.value.id, formData.value.attributes)
    } else {
      await categoryStore.createCategory(formData.value.attributes)
    }
    
    showCategoryForm.value = false
    resetForm()
  } catch (err) {
    if (err.response?.data?.errors) {
      formErrors.value = err.response.data.errors
    } else {
      console.error('Error saving category:', err)
      error.value = 'Failed to save category. Please try again.'
    }
  } finally {
    isSaving.value = false
  }
}

const confirmDelete = (category) => {
  categoryToDelete.value = category
  showDeleteConfirm.value = true
}

const deleteCategory = async () => {
  if (!categoryToDelete.value) return
  
  isDeleting.value = true
  
  try {
    await categoryStore.deleteCategory(categoryToDelete.value.id)
    showDeleteConfirm.value = false
    categoryToDelete.value = null
  } catch (err) {
    console.error('Error deleting category:', err)
    error.value = 'Failed to delete category. Please try again.'
  } finally {
    isDeleting.value = false
  }
}

const cancelEdit = () => {
  showCategoryForm.value = false
  resetForm()
}

const resetForm = () => {
  formData.value = {
    attributes: {
      name: '',
      color: '#3B82F6'
    }
  }
  editingCategory.value = null
  formErrors.value = {}
}

// Lifecycle hooks
onMounted(async () => {
  if (categoryStore.categories.length === 0) {
    await fetchCategories()
  }
  
  // Load recipes to get category counts
  if (recipeStore.recipes.length === 0) {
    await recipeStore.fetchRecipes()
  }
})
</script>

<style scoped>
/* Add any custom styles here */
</style>
