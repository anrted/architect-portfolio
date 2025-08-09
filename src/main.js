
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import { initializeColorPalette } from './utils/colorPalette.js'

// Инициализируем цветовую палитру перед созданием приложения
initializeColorPalette().then(() => {
  const app = createApp(App)
  app.use(router)
  app.mount('#app')
}).catch(error => {
  console.error('Ошибка инициализации цветовой палитры:', error)
  // Создаем приложение даже если не удалось загрузить палитру
  const app = createApp(App)
  app.use(router)
  app.mount('#app')
})
