import { ref, computed } from 'vue'
import axios from 'axios'

// Простое состояние без Pinia
const user = ref(null)
const sessionId = ref(localStorage.getItem('admin_session_id'))

export function useAdminStore() {
  const isAuthenticated = computed(() => !!user.value)
  
  const login = async (username, password) => {
    try {
      const response = await axios.post('/api/auth.php', {
        action: 'login',
        username,
        password
      })
      
      if (response.data.success) {
        user.value = response.data.user
        sessionId.value = response.data.session_id
        localStorage.setItem('admin_session_id', response.data.session_id)
        
        // Настраиваем axios для автоматической отправки токена
        axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.session_id}`
        
        return response.data
      } else {
        throw new Error(response.data.error || 'Ошибка входа')
      }
    } catch (error) {
      if (error.response?.data?.error) {
        throw new Error(error.response.data.error)
      }
      throw new Error('Ошибка соединения с сервером')
    }
  }
  
  const logout = async () => {
    try {
      if (sessionId.value) {
        await axios.post('/api/auth.php', {
          action: 'logout',
          session_id: sessionId.value
        })
      }
    } catch (error) {
      console.error('Ошибка при выходе:', error)
    } finally {
      user.value = null
      sessionId.value = null
      localStorage.removeItem('admin_session_id')
      delete axios.defaults.headers.common['Authorization']
    }
  }
  
  const checkAuth = async () => {
    const storedSessionId = localStorage.getItem('admin_session_id')
    if (!storedSessionId) {
      return false
    }
    
    try {
      const response = await axios.post('/api/auth.php', {
        action: 'check',
        session_id: storedSessionId
      })
      
      if (response.data.success) {
        user.value = response.data.user
        sessionId.value = storedSessionId
        axios.defaults.headers.common['Authorization'] = `Bearer ${storedSessionId}`
        return true
      } else {
        localStorage.removeItem('admin_session_id')
        return false
      }
    } catch (error) {
      localStorage.removeItem('admin_session_id')
      return false
    }
  }
  
  // Инициализация axios interceptor для автоматической установки токена
  if (sessionId.value) {
    axios.defaults.headers.common['Authorization'] = `Bearer ${sessionId.value}`
  }
  
  return {
    user: computed(() => user.value),
    isAuthenticated,
    login,
    logout,
    checkAuth
  }
}
