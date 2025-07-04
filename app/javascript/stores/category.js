import { defineStore } from 'pinia'
import axios from 'axios'

export const useCategoryStore = defineStore('category', {
  state: () => ({
    categories: [],
    currentCategory: null,
    loading: false,
    error: null
  }),

  getters: {
    getCategoryById: (state) => (id) => {
      return state.categories.find(category => category.id === id) || null
    },
    
    getCategoriesForSelect: (state) => {
      return state.categories.map(category => ({
        id: category.id,
        name: category.attributes.name,
        color: category.attributes.color
      }))
    }
  },

  actions: {
    async fetchCategories() {
      if (this.categories.length > 0) return // Avoid refetching if already loaded
      
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.get('/api/v1/categories')
        this.categories = response.data.data || []
      } catch (error) {
        console.error('Error fetching categories:', error)
        this.error = 'Failed to load categories. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchCategory(id) {
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.get(`/api/v1/categories/${id}`)
        this.currentCategory = response.data.data
        return this.currentCategory
      } catch (error) {
        console.error(`Error fetching category ${id}:`, error)
        this.error = 'Failed to load category. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async createCategory(categoryData) {
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.post('/api/v1/categories', {
          category: categoryData
        })
        
        this.categories.push(response.data.data)
        return response.data.data
      } catch (error) {
        console.error('Error creating category:', error)
        this.error = error.response?.data?.error || 'Failed to create category. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateCategory({ id, ...categoryData }) {
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.patch(`/api/v1/categories/${id}`, {
          category: categoryData
        })
        
        const index = this.categories.findIndex(c => c.id === id)
        if (index !== -1) {
          this.categories[index] = response.data.data
        }
        
        if (this.currentCategory?.id === id) {
          this.currentCategory = response.data.data
        }
        
        return response.data.data
      } catch (error) {
        console.error(`Error updating category ${id}:`, error)
        this.error = error.response?.data?.error || 'Failed to update category. Please try again.'
        throw error
      } finally {
        this.loading = false
      }
    },

    async deleteCategory(id) {
      this.loading = true
      this.error = null
      
      try {
        await axios.delete(`/api/v1/categories/${id}`)
        this.categories = this.categories.filter(category => category.id !== id)
        
        if (this.currentCategory?.id === id) {
          this.currentCategory = null
        }
      } catch (error) {
        console.error(`Error deleting category ${id}:`, error)
        this.error = error.response?.data?.error || 'Failed to delete category. It may be in use by recipes.'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
