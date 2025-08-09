import { createRouter, createWebHistory } from 'vue-router'
import Home from './components/Home.vue'

import Projects from './components/Projects.vue'
import ProjectView from './components/ProjectView.vue'

// Admin components
import AdminLogin from './components/admin/AdminLogin.vue'
import AdminLayout from './components/admin/AdminLayout.vue'
import AdminDashboard from './components/admin/AdminDashboard.vue'
import AdminProjectsList from './components/admin/AdminProjectsList.vue'
import AdminProjectForm from './components/admin/AdminProjectForm.vue'
import AdminAboutEdit from './components/admin/AdminAboutEdit.vue'
import AdminContactsEdit from './components/admin/AdminContactsEdit.vue'
import AdminBackup from './components/admin/AdminBackup.vue'
import AdminHeaderEdit from './components/admin/AdminHeaderEdit.vue'
import AdminUsersList from './components/admin/AdminUsersList.vue'

import { useAdminStore } from './stores/admin.js'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/projects',
    name: 'Projects',
    component: Projects
  },
  {
    path: '/projects/:id',
    name: 'ProjectView',
    component: ProjectView
  },
  // Admin routes
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: AdminLogin,
    meta: { requiresGuest: true }
  },
  {
    path: '/admin',
    component: AdminLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'AdminDashboard',
        component: AdminDashboard
      },
      {
        path: 'about',
        name: 'AdminAboutEdit',
        component: AdminAboutEdit
      },
      {
        path: 'header',
        name: 'AdminHeaderEdit',
        component: AdminHeaderEdit
      },
      {
        path: 'contacts',
        name: 'AdminContactsEdit',
        component: AdminContactsEdit
      },
      {
        path: 'backup',
        name: 'AdminBackup',
        component: AdminBackup
      },
      {
        path: 'projects',
        name: 'AdminProjectsList',
        component: AdminProjectsList
      },
      {
        path: 'projects/create',
        name: 'AdminProjectCreate',
        component: AdminProjectForm
      },
      {
        path: 'projects/edit/:id',
        name: 'AdminProjectEdit',
        component: AdminProjectForm
      },
      {
        path: 'users',
        name: 'AdminUsersList',
        component: AdminUsersList
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Navigation guards
router.beforeEach(async (to, from, next) => {
  const adminStore = useAdminStore()
  
  if (to.meta.requiresAuth) {
    // Проверяем авторизацию для админ маршрутов
    const isAuthenticated = await adminStore.checkAuth()
    
    if (!isAuthenticated) {
      next('/admin/login')
      return
    }
  }
  
  if (to.meta.requiresGuest && adminStore.isAuthenticated.value) {
    // Если пользователь уже авторизован и пытается попасть на страницу логина
    next('/admin')
    return
  }
  
  next()
})

export default router
