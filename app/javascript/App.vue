<template>
  <div class="min-h-screen bg-gray-50">
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="flex-shrink-0 flex items-center">
              <router-link to="/" class="text-xl font-bold text-indigo-600">
                Recipe Manager
              </router-link>
            </div>
            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
              <router-link 
                to="/" 
                class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                active-class="border-indigo-500 text-gray-900"
                exact
              >
                Recipes
              </router-link>
              <router-link 
                to="/categories" 
                class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                active-class="border-indigo-500 text-gray-900"
              >
                Categories
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRecipeStore } from './stores/recipe'
import { useCategoryStore } from './stores/category'

const recipeStore = useRecipeStore()
const categoryStore = useCategoryStore()

onMounted(async () => {
  await categoryStore.fetchCategories()
  await recipeStore.fetchRecipes()
})
</script>
