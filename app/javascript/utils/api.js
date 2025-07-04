import axios from 'axios'

// Create axios instance with base URL
const api = axios.create({
  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
})

// Request interceptor
api.interceptors.request.use(
  (config) => {
    // You can add auth token here if needed
    // const token = localStorage.getItem('token')
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`
    // }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor
api.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    // Handle common errors
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      const { status, data } = error.response
      
      switch (status) {
        case 401:
          // Handle unauthorized
          console.error('Unauthorized')
          break
        case 403:
          // Handle forbidden
          console.error('Forbidden')
          break
        case 404:
          // Handle not found
          console.error('Resource not found')
          break
        case 422:
          // Handle validation errors
          console.error('Validation error:', data.errors)
          break
        case 500:
          // Handle server error
          console.error('Server error')
          break
        default:
          console.error('An error occurred')
      }
    } else if (error.request) {
      // The request was made but no response was received
      console.error('No response from server')
    } else {
      // Something happened in setting up the request that triggered an Error
      console.error('Request error:', error.message)
    }
    
    return Promise.reject(error)
  }
)

export default api
