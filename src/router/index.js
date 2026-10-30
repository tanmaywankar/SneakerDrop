import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '../lib/supabase'

import HomeView from '../views/HomeView.vue'
import AdminLoginView from '../views/AdminLoginView.vue'
import AdminDashboardView from '../views/AdminDashboardView.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: HomeView,
  },
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: AdminLoginView,
  },
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: AdminDashboardView,
    meta: { requiresAuth: true },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})


router.beforeEach(async (to, from, next) => {
  const { data: { session } } = await supabase.auth.getSession()

  // 1. Trying to access protected route without a session
  if (to.meta.requiresAuth && !session) {
    return next({ name: 'AdminLogin' })
  }

  // 2. Already logged in and visiting login page
  if (to.name === 'AdminLogin' && session) {
    return next({ name: 'AdminDashboard' })
  }

  next()
})

export default router