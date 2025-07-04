import { createRouter, createWebHistory } from 'vue-router'

// Lazy load route components
const HomeView = () => import('../views/HomeView.vue')
const RecipeView = () => import('../views/RecipeView.vue')
const RecipeForm = () => import('../views/RecipeForm.vue')
const CategoriesView = () => import('../views/CategoriesView.vue')

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/recipes/new',
    name: 'new-recipe',
    component: RecipeForm
  },
  {
    path: '/recipes/:id/edit',
    name: 'edit-recipe',
    component: RecipeForm,
    props: true
  },
  {
    path: '/recipes/:id',
    name: 'recipe',
    component: RecipeView,
    props: true
  },
  {
    path: '/categories',
    name: 'categories',
    component: CategoriesView
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
