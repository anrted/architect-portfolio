import { ref, onMounted, readonly } from 'vue'
import { loadColorPalette, applyColorPalette, getCurrentColorPalette } from '../utils/colorPalette.js'

export function useColorPalette() {
  const palette = ref(null)
  const loading = ref(true)
  const error = ref(null)

  /**
   * Загружает цветовую палитру
   */
  const loadPalette = async () => {
    try {
      loading.value = true
      error.value = null
      const colorPalette = await loadColorPalette()
      palette.value = colorPalette
      applyColorPalette(colorPalette)
    } catch (err) {
      error.value = err.message
      console.error('Ошибка загрузки цветовой палитры:', err)
    } finally {
      loading.value = false
    }
  }

  /**
   * Получает текущую цветовую палитру
   */
  const getPalette = () => {
    if (!palette.value) {
      return getCurrentColorPalette()
    }
    return palette.value
  }

  /**
   * Получает основной цвет
   */
  const getPrimaryColor = () => {
    const currentPalette = getPalette()
    return currentPalette.primary?.main || '#2563eb'
  }

  /**
   * Получает цвет текста
   */
  const getTextColor = () => {
    const currentPalette = getPalette()
    return currentPalette.textColor?.main || '#1e293b'
  }

  /**
   * Получает светлый оттенок основного цвета
   */
  const getPrimaryLight = () => {
    const currentPalette = getPalette()
    return currentPalette.primary?.light || '#3b82f6'
  }

  /**
   * Получает темный оттенок основного цвета
   */
  const getPrimaryDark = () => {
    const currentPalette = getPalette()
    return currentPalette.primary?.dark || '#1d4ed8'
  }

  /**
   * Получает светлый цвет текста
   */
  const getTextLight = () => {
    const currentPalette = getPalette()
    return currentPalette.textColor?.light || '#64748b'
  }

  /**
   * Получает темный цвет текста
   */
  const getTextDark = () => {
    const currentPalette = getPalette()
    return currentPalette.textColor?.dark || '#0f172a'
  }

  onMounted(() => {
    loadPalette()
  })

  return {
    palette: readonly(palette),
    loading: readonly(loading),
    error: readonly(error),
    loadPalette,
    getPalette,
    getPrimaryColor,
    getTextColor,
    getPrimaryLight,
    getPrimaryDark,
    getTextLight,
    getTextDark
  }
}
