import { defineStore } from 'pinia'
import axios from 'axios'

export const useRecipeStore = defineStore('recipe', {
  state: () => ({
    recipes: [],
    currentRecipe: null,
    loading: false,
    error: null,
    pagination: {
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      perPage: 10
    },
    filters: {
      search: '',
      difficulty: '',
      categoryId: '',
      rating: ''
    }
  }),

  getters: {
    getRecipeById: (state) => (id) => {
      return state.recipes.find(recipe => recipe.id === id) || null
    },
    
    filteredRecipes: (state) => {
      return state.recipes.filter(recipe => {
        const matchesSearch = !state.filters.search || 
          recipe.attributes.title.toLowerCase().includes(state.filters.search.toLowerCase()) ||
          recipe.attributes.description.toLowerCase().includes(state.filters.search.toLowerCase())
        
        const matchesDifficulty = !state.filters.difficulty || 
          recipe.attributes.difficulty === state.filters.difficulty
        
        const matchesCategory = !state.filters.categoryId || 
          (recipe.relationships.categories.data || []).some(cat => cat.id === state.filters.categoryId)
        
        const matchesRating = !state.filters.rating || 
          (recipe.attributes.rating && recipe.attributes.rating >= parseInt(state.filters.rating))
        
        return matchesSearch && matchesDifficulty && matchesCategory && matchesRating
      })
    }
  },

  actions: {
    async fetchRecipes(page = 1) {
      this.loading = true
      this.error = null
      
      try {
        const params = new URLSearchParams()
        params.append('page', page)
        params.append('per_page', this.pagination.perPage)
        
        if (this.filters.search) params.append('q', this.filters.search)
        if (this.filters.difficulty) params.append('difficulty', this.filters.difficulty)
        if (this.filters.categoryId) params.append('category_id', this.filters.categoryId)
        if (this.filters.rating) params.append('rating', this.filters.rating)
        
        const response = await axios.get(`/api/v1/recipes?${params.toString()}`)
        
        this.recipes = response.data.data || []
        this.pagination = {
          currentPage: page,
          totalPages: response.data.meta?.totalPages || 1,
          totalItems: response.data.meta?.totalCount || 0,
          perPage: this.pagination.perPage
        }
      } catch (error) {
        console.error('Error fetching recipes:', error)
        this.error = 'Failed to load recipes. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchRecipe(id) {
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.get(`/api/v1/recipes/${id}`)
        this.currentRecipe = response.data.data
        return this.currentRecipe
      } catch (error) {
        console.error(`Error fetching recipe ${id}:`, error)
        this.error = 'Failed to load recipe. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async createRecipe(recipeData) {
      this.loading = true
      this.error = null
      
      try {
        // Create a clean copy of the recipe data
        const payload = { ...recipeData }
        
        // Handle image separately if it exists
        const imageFile = payload.image
        delete payload.image
        
        // Send the recipe data as JSON
        const response = await axios.post('/api/v1/recipes', {
          recipe: payload
        }, {
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        })
        
        // If there's an image, upload it separately
        if (imageFile) {
          const formData = new FormData()
          formData.append('image', imageFile)
          
          await axios.patch(`/api/v1/recipes/${response.data.data.id}/image`, formData, {
            headers: {
              'Content-Type': 'multipart/form-data'
            }
          })
          
          // Refresh the recipe to get the updated image URL
          const updatedResponse = await axios.get(`/api/v1/recipes/${response.data.data.id}`)
          this.recipes.unshift(updatedResponse.data.data)
          return updatedResponse.data.data
        }
        
        this.recipes.unshift(response.data.data)
        return response.data.data
      } catch (error) {
        console.error('Error creating recipe:', error)
        this.error = error.response?.data?.error || 'Failed to create recipe. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateRecipe({ id, ...recipeData }) {
      this.loading = true
      this.error = null
      
      try {
        // Create a clean copy of the recipe data
        const payload = { ...recipeData }
        
        // Handle image separately if it exists
        const imageFile = payload.image
        delete payload.image
        
        // Send the recipe data as JSON
        const response = await axios.patch(`/api/v1/recipes/${id}`, {
          recipe: payload
        }, {
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        })
        
        // If there's an image, upload it separately
        if (imageFile) {
          const formData = new FormData()
          formData.append('image', imageFile)
          
          await axios.patch(`/api/v1/recipes/${id}/image`, formData, {
            headers: {
              'Content-Type': 'multipart/form-data'
            }
          })
          
          // Refresh the recipe to get the updated image URL
          const updatedResponse = await axios.get(`/api/v1/recipes/${id}`)
          const updatedRecipe = updatedResponse.data.data
          
          // Update the recipes array
          const index = this.recipes.findIndex(r => r.id === id)
          if (index !== -1) {
            this.recipes[index] = updatedRecipe
          }
          
          // Update current recipe if it's the one being edited
          if (this.currentRecipe?.id === id) {
            this.currentRecipe = updatedRecipe
          }
          
          return updatedRecipe
        }
        
        // Update the recipes array
        const index = this.recipes.findIndex(r => r.id === id)
        if (index !== -1) {
          this.recipes[index] = response.data.data
        }
        
        // Update current recipe if it's the one being edited
        if (this.currentRecipe?.id === id) {
          this.currentRecipe = response.data.data
        }
        
        return response.data.data
      } catch (error) {
        console.error(`Error updating recipe ${id}:`, error)
        this.error = error.response?.data?.error || 'Failed to update recipe. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async deleteRecipe(id) {
      this.loading = true
      this.error = null
      
      try {
        await axios.delete(`/api/v1/recipes/${id}`)
        this.recipes = this.recipes.filter(recipe => recipe.id !== id)
        
        if (this.currentRecipe?.id === id) {
          this.currentRecipe = null
        }
      } catch (error) {
        console.error(`Error deleting recipe ${id}:`, error)
        this.error = 'Failed to delete recipe. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    setFilters(filters) {
      this.filters = { ...this.filters, ...filters }
      this.fetchRecipes(1)
    },

    resetFilters() {
      this.filters = {
        search: '',
        difficulty: '',
        categoryId: '',
        rating: ''
      }
      this.fetchRecipes(1)
    }
  }
})
