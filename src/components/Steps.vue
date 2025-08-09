<template>
  <section id="steps" class="mb-8 sm:mb-12 md:mb-16 lg:mb-20">
    <!-- Заголовок -->
    <div class="text-center mb-8 sm:mb-12 md:mb-16">
      <h2 class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold mb-4 sm:mb-6" :style="{ color: 'var(--text-color-main)' }">Этапы работы</h2>
      <p class="text-base sm:text-lg md:text-xl max-w-3xl mx-auto px-4 sm:px-6" :style="{ color: 'var(--text-color-light)' }">
        Пошаговый процесс создания вашего идеального проекта от идеи до воплощения
      </p>
    </div>

    <!-- Этапы для десктопа -->
    <div class="hidden lg:block relative">
      <!-- Соединительная линия -->
      <div class="absolute top-20 left-0 right-0 h-0.5 z-0" :style="{ background: `linear-gradient(to right, var(--primary-color-light), var(--primary-color), var(--primary-color-light))` }"></div>
      
      <div class="grid grid-cols-5 gap-8 relative z-10">
        <div v-for="(step, index) in steps" :key="index" class="flex flex-col items-center group">
          <!-- Номер этапа -->
          <div class="w-16 h-16 text-white rounded-full flex items-center justify-center text-xl font-bold mb-6 shadow-lg transform group-hover:scale-110 transition-all duration-300 relative z-10" :style="{ backgroundColor: 'var(--primary-color)' }">
            {{ index + 1 }}
          </div>
          
          <!-- Карточка этапа -->
          <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 w-full h-full flex flex-col" :style="{ borderColor: 'var(--border-primary)' }">
            <!-- Иконка -->
            <div class="flex justify-center mb-4">
              <div class="w-16 h-16 rounded-2xl flex items-center justify-center transition-colors" :style="{ backgroundColor: 'var(--primary-color-light)20' }">
                <component :is="step.icon" class="w-8 h-8" :style="{ color: 'var(--primary-color)' }"/>
              </div>
            </div>
            
            <!-- Содержимое -->
            <div class="text-center flex-1 flex flex-col">
              <h3 class="text-xl font-bold mb-3" :style="{ color: 'var(--text-color-main)' }">{{ step.title }}</h3>
              <p class="text-sm leading-relaxed flex-1" :style="{ color: 'var(--text-color-light)' }">{{ step.description }}</p>
              
              <!-- Временные рамки -->
              <div class="mt-4 inline-block px-3 py-1 rounded-full text-xs font-medium self-center" :style="{ backgroundColor: 'var(--primary-color-light)20', color: 'var(--primary-color)' }">
                {{ step.duration }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Этапы для мобильных -->
    <div class="lg:hidden space-y-6 sm:space-y-8">
      <div v-for="(step, index) in steps" :key="index" class="flex items-start space-x-4 sm:space-x-6">
        <!-- Линия и номер -->
        <div class="flex flex-col items-center">
          <div class="w-10 h-10 sm:w-12 sm:h-12 text-white rounded-full flex items-center justify-center text-sm sm:text-lg font-bold shadow-lg" :style="{ backgroundColor: 'var(--primary-color)' }">
            {{ index + 1 }}
          </div>
          <div v-if="index < steps.length - 1" class="w-0.5 h-12 sm:h-16 mt-3 sm:mt-4" :style="{ backgroundColor: 'var(--primary-color-light)' }"></div>
        </div>
        
        <!-- Карточка -->
        <div class="flex-1 bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 h-full flex flex-col" :style="{ borderColor: 'var(--border-primary)' }">
          <div class="flex items-center mb-3 sm:mb-4">
            <div class="w-10 h-10 sm:w-12 sm:h-12 rounded-xl flex items-center justify-center mr-3 sm:mr-4" :style="{ backgroundColor: 'var(--primary-color-light)20' }">
              <component :is="step.icon" class="w-5 h-5 sm:w-6 sm:h-6" :style="{ color: 'var(--primary-color)' }"/>
            </div>
            <div>
              <h3 class="text-base sm:text-lg font-bold" :style="{ color: 'var(--text-color-main)' }">{{ step.title }}</h3>
              <span class="text-xs px-2 py-1 rounded-full font-medium" :style="{ backgroundColor: 'var(--primary-color-light)20', color: 'var(--primary-color)' }">{{ step.duration }}</span>
            </div>
          </div>
          <p class="text-sm leading-relaxed flex-1" :style="{ color: 'var(--text-color-light)' }">{{ step.description }}</p>
        </div>
      </div>
    </div>

    <!-- Дополнительная информация -->
    <div class="mt-8 sm:mt-12 md:mt-16 rounded-xl sm:rounded-2xl p-6 sm:p-8 md:p-12" :style="{ background: `linear-gradient(135deg, var(--primary-color-light)10, var(--background-secondary), var(--primary-color-light)10)` }">
      <div class="text-center">
        <h3 class="text-xl sm:text-2xl md:text-3xl font-bold mb-3 sm:mb-4" :style="{ color: 'var(--text-color-main)' }">Прозрачность процесса</h3>
        <p class="mb-6 sm:mb-8 max-w-3xl mx-auto text-sm sm:text-base" :style="{ color: 'var(--text-color-light)' }">
          На каждом этапе вы получаете детальные отчеты о ходе работ, промежуточные результаты и возможность внести корректировки. Никаких сюрпризов — только качественная работа в срок.
        </p>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 sm:gap-8">
          <div class="text-center">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-white rounded-xl sm:rounded-2xl shadow-lg flex items-center justify-center mx-auto mb-3 sm:mb-4">
              <svg class="w-6 h-6 sm:w-8 sm:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color)' }">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
            </div>
            <h4 class="font-bold mb-2 text-sm sm:text-base" :style="{ color: 'var(--text-color-main)' }">Фиксированные сроки</h4>
            <p class="text-xs sm:text-sm" :style="{ color: 'var(--text-color-light)' }">Четкий план работ с конкретными датами</p>
          </div>
          
          <div class="text-center">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-white rounded-xl sm:rounded-2xl shadow-lg flex items-center justify-center mx-auto mb-3 sm:mb-4">
              <svg class="w-6 h-6 sm:w-8 sm:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color)' }">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </div>
            <h4 class="font-bold mb-2 text-sm sm:text-base" :style="{ color: 'var(--text-color-main)' }">Полная прозрачность</h4>
            <p class="text-xs sm:text-sm" :style="{ color: 'var(--text-color-light)' }">Детальные отчеты на каждом этапе</p>
          </div>
          
          <div class="text-center">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-white rounded-xl sm:rounded-2xl shadow-lg flex items-center justify-center mx-auto mb-3 sm:mb-4">
              <svg class="w-6 h-6 sm:w-8 sm:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color)' }">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
            </div>
            <h4 class="font-bold mb-2 text-sm sm:text-base" :style="{ color: 'var(--text-color-main)' }">Регулярные обновления</h4>
            <p class="text-xs sm:text-sm" :style="{ color: 'var(--text-color-light)' }">Еженедельные отчеты о прогрессе</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { defineComponent, h } from 'vue'

// Создаем компоненты для иконок
const ConsultationIcon = defineComponent({
  render: () => h('svg', { 
    width: 32, 
    height: 32, 
    fill: 'none', 
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    'stroke-width': 2
  }, [
    h('path', { 
      'stroke-linecap': 'round', 
      'stroke-linejoin': 'round', 
      d: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-3.582 8-8 8a8.13 8.13 0 01-2.906-.515L7 21l1.515-3.094A8.002 8.002 0 013 12c0-4.418 3.582-8 8-8s8 3.582 8 8z' 
    })
  ])
})

const ConceptIcon = defineComponent({
  render: () => h('svg', { 
    width: 32, 
    height: 32, 
    fill: 'none', 
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    'stroke-width': 2
  }, [
    h('path', { 
      'stroke-linecap': 'round', 
      'stroke-linejoin': 'round', 
      d: 'M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z' 
    })
  ])
})

const AgreementIcon = defineComponent({
  render: () => h('svg', { 
    width: 32, 
    height: 32, 
    fill: 'none', 
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    'stroke-width': 2
  }, [
    h('path', { 
      'stroke-linecap': 'round', 
      'stroke-linejoin': 'round', 
      d: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z' 
    })
  ])
})

const DocumentationIcon = defineComponent({
  render: () => h('svg', { 
    width: 32, 
    height: 32, 
    fill: 'none', 
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    'stroke-width': 2
  }, [
    h('path', { 
      'stroke-linecap': 'round', 
      'stroke-linejoin': 'round', 
      d: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z' 
    })
  ])
})

const SupportIcon = defineComponent({
  render: () => h('svg', { 
    width: 32, 
    height: 32, 
    fill: 'none', 
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    'stroke-width': 2
  }, [
    h('path', { 
      'stroke-linecap': 'round', 
      'stroke-linejoin': 'round', 
      d: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z' 
    })
  ])
})

const steps = [
  {
    title: 'Консультация',
    description: 'Детальное обсуждение ваших потребностей, пожеланий и бюджета. Анализ участка и технических требований.',
    duration: '1-2 дня',
    icon: ConsultationIcon
  },
  {
    title: 'Концепция',
    description: 'Разработка архитектурной концепции, эскизных чертежей и 3D-визуализаций для понимания общей идеи.',
    duration: '1-2 недели',
    icon: ConceptIcon
  },
  {
    title: 'Согласование',
    description: 'Презентация концепции, внесение корректировок по вашим замечаниям и финальное утверждение проекта.',
    duration: '3-5 дней',
    icon: AgreementIcon
  },
  {
    title: 'Документация',
    description: 'Подготовка полного комплекта рабочих чертежей, спецификаций и технических решений для строительства.',
    duration: '2-4 недели',
    icon: DocumentationIcon
  },
  {
    title: 'Сопровождение',
    description: 'Авторский надзор на этапе строительства, консультации подрядчиков и контроль качества выполнения работ.',
    duration: 'весь период',
    icon: SupportIcon
  }
]
</script>
