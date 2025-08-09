<template>
  <section id="steps" class="mb-8 sm:mb-12 md:mb-16 lg:mb-20">
    <!-- Заголовок -->
    <div class="text-center mb-8 sm:mb-12 md:mb-16">
      <h2 class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold text-gray-900 mb-4 sm:mb-6">Этапы работы</h2>
      <p class="text-base sm:text-lg md:text-xl text-gray-600 max-w-3xl mx-auto px-4 sm:px-6">
        Пошаговый процесс создания вашего идеального проекта от идеи до воплощения
      </p>
    </div>

    <!-- Этапы для десктопа -->
    <div class="hidden lg:block relative">
      <!-- Соединительная линия -->
      <div class="absolute top-20 left-0 right-0 h-0.5 bg-gradient-to-r from-blue-200 via-blue-400 to-blue-200 z-0"></div>
      
      <div class="grid grid-cols-5 gap-8 relative z-10">
        <div v-for="(step, index) in steps" :key="index" class="flex flex-col items-center group">
          <!-- Номер этапа -->
          <div class="w-16 h-16 bg-blue-600 text-white rounded-full flex items-center justify-center text-xl font-bold mb-6 shadow-lg transform group-hover:scale-110 transition-all duration-300 relative z-10">
            {{ index + 1 }}
          </div>
          
          <!-- Карточка этапа -->
          <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 border border-gray-100 w-full h-full flex flex-col">
            <!-- Иконка -->
            <div class="flex justify-center mb-4">
              <div class="w-16 h-16 bg-blue-100 rounded-2xl flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                <component :is="step.icon" class="w-8 h-8 text-blue-600"/>
              </div>
            </div>
            
            <!-- Содержимое -->
            <div class="text-center flex-1 flex flex-col">
              <h3 class="text-xl font-bold text-gray-900 mb-3">{{ step.title }}</h3>
              <p class="text-gray-600 text-sm leading-relaxed flex-1">{{ step.description }}</p>
              
              <!-- Временные рамки -->
              <div class="mt-4 inline-block px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-xs font-medium self-center">
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
          <div class="w-10 h-10 sm:w-12 sm:h-12 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm sm:text-lg font-bold shadow-lg">
            {{ index + 1 }}
          </div>
          <div v-if="index < steps.length - 1" class="w-0.5 h-12 sm:h-16 bg-blue-200 mt-3 sm:mt-4"></div>
        </div>
        
        <!-- Карточка -->
        <div class="flex-1 bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 border border-gray-100 h-full flex flex-col">
          <div class="flex items-center mb-3 sm:mb-4">
            <div class="w-10 h-10 sm:w-12 sm:h-12 bg-blue-100 rounded-xl flex items-center justify-center mr-3 sm:mr-4">
              <component :is="step.icon" class="w-5 h-5 sm:w-6 sm:h-6 text-blue-600"/>
            </div>
            <div>
              <h3 class="text-base sm:text-lg font-bold text-gray-900">{{ step.title }}</h3>
              <span class="text-xs px-2 py-1 bg-blue-50 text-blue-600 rounded-full font-medium">{{ step.duration }}</span>
            </div>
          </div>
          <p class="text-gray-600 text-sm leading-relaxed flex-1">{{ step.description }}</p>
        </div>
      </div>
    </div>

    <!-- Дополнительная информация -->
    <div class="mt-8 sm:mt-12 md:mt-16 bg-gradient-to-r from-blue-50 to-blue-100 rounded-xl sm:rounded-2xl p-6 sm:p-8 md:p-12">
      <div class="text-center">
        <h3 class="text-xl sm:text-2xl md:text-3xl font-bold text-gray-900 mb-3 sm:mb-4">Прозрачность процесса</h3>
        <p class="text-gray-600 mb-6 sm:mb-8 max-w-3xl mx-auto text-sm sm:text-base">
          На каждом этапе вы получаете детальные отчеты о ходе работ, промежуточные результаты и возможность внести корректировки. Никаких сюрпризов — только качественная работа в срок.
        </p>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 sm:gap-8">
          <div class="text-center">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-white rounded-xl sm:rounded-2xl shadow-lg flex items-center justify-center mx-auto mb-3 sm:mb-4">
              <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
            </div>
            <h4 class="font-bold text-gray-900 mb-2 text-sm sm:text-base">Фиксированные сроки</h4>
            <p class="text-gray-600 text-xs sm:text-sm">Четкий план работ с конкретными датами</p>
          </div>
          
          <div class="text-center">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-white rounded-xl sm:rounded-2xl shadow-lg flex items-center justify-center mx-auto mb-3 sm:mb-4">
              <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </div>
            <h4 class="font-bold text-gray-900 mb-2 text-sm sm:text-base">Полная прозрачность</h4>
            <p class="text-gray-600 text-xs sm:text-sm">Регулярные отчеты о ходе работ</p>
          </div>
          
          <div class="text-center sm:col-span-2 md:col-span-1">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-white rounded-xl sm:rounded-2xl shadow-lg flex items-center justify-center mx-auto mb-3 sm:mb-4">
              <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
              </svg>
            </div>
            <h4 class="font-bold text-gray-900 mb-2 text-sm sm:text-base">Индивидуальный подход</h4>
            <p class="text-gray-600 text-xs sm:text-sm">Учет всех ваших пожеланий</p>
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
