<template>
  <section id="reviews" class="mb-8 sm:mb-12 md:mb-16 lg:mb-20">
    <!-- Заголовок -->
    <div class="text-center mb-8 sm:mb-12 md:mb-16">
      <h2 class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold mb-4 sm:mb-6" :style="{ color: 'var(--text-color-main)' }">Отзывы клиентов</h2>
      <p class="text-base sm:text-lg md:text-xl max-w-2xl mx-auto px-4 sm:px-6" :style="{ color: 'var(--text-color-light)' }">
        Мнения тех, кто доверил мне создание своих проектов
      </p>
    </div>

    <!-- Отзывы -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 md:gap-8">
      <!-- Отзыв 1 -->
      <div class="group bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 md:p-8 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 sm:hover:-translate-y-2" :style="{ borderColor: 'var(--border-primary)' }">
        <!-- Звезды -->
        <div class="flex items-center mb-4 sm:mb-6">
          <div class="flex space-x-1">
            <svg v-for="n in 5" :key="n" class="w-4 h-4 sm:w-5 sm:h-5" fill="currentColor" viewBox="0 0 20 20" :style="{ color: '#fbbf24' }">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
          </div>
        </div>

        <!-- Цитата -->
        <blockquote class="text-sm sm:text-base md:text-lg leading-relaxed mb-4 sm:mb-6 relative pl-6 sm:pl-8" :style="{ color: 'var(--text-color-main)' }">
          <svg class="absolute top-0 left-0 w-4 h-4 sm:w-6 sm:h-6" fill="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color-light)' }">
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
          </svg>
          "Работа выполнена на высшем уровне! Иван не просто создал проект дома моей мечты, но и учел все мои пожелания. Результат превзошел ожидания."
        </blockquote>

        <!-- Автор -->
        <div class="flex items-center">
          <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="Анна Петрова" class="w-10 h-10 sm:w-12 sm:h-12 md:w-14 md:h-14 rounded-full shadow-lg border-2 border-white">
          <div class="ml-3 sm:ml-4">
            <div class="font-bold text-sm sm:text-base" :style="{ color: 'var(--text-color-main)' }">Анна Петрова</div>
            <div class="text-xs sm:text-sm" :style="{ color: 'var(--text-color-light)' }">Частный дом, 250 м²</div>
          </div>
        </div>
      </div>

      <!-- Отзыв 2 -->
      <div class="group bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 md:p-8 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 sm:hover:-translate-y-2" :style="{ borderColor: 'var(--border-primary)' }">
        <!-- Звезды -->
        <div class="flex items-center mb-4 sm:mb-6">
          <div class="flex space-x-1">
            <svg v-for="n in 5" :key="n" class="w-4 h-4 sm:w-5 sm:h-5" fill="currentColor" viewBox="0 0 20 20" :style="{ color: '#fbbf24' }">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
          </div>
        </div>

        <!-- Цитата -->
        <blockquote class="text-sm sm:text-base md:text-lg leading-relaxed mb-4 sm:mb-6 relative pl-6 sm:pl-8" :style="{ color: 'var(--text-color-main)' }">
          <svg class="absolute top-0 left-0 w-4 h-4 sm:w-6 sm:h-6" fill="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color-light)' }">
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
          </svg>
          "Потрясающий проект офиса! Пространство стало функциональным и современным. Команда работает в комфорте. Рекомендую всем!"
        </blockquote>

        <!-- Автор -->
        <div class="flex items-center">
          <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Сергей Иванов" class="w-10 h-10 sm:w-12 sm:h-12 md:w-14 md:h-14 rounded-full shadow-lg border-2 border-white">
          <div class="ml-3 sm:ml-4">
            <div class="font-bold text-sm sm:text-base" :style="{ color: 'var(--text-color-main)' }">Сергей Иванов</div>
            <div class="text-xs sm:text-sm" :style="{ color: 'var(--text-color-light)' }">Офис IT-компании, 180 м²</div>
          </div>
        </div>
      </div>

      <!-- Отзыв 3 -->
      <div class="group bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 md:p-8 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 sm:hover:-translate-y-2 sm:col-span-2 lg:col-span-1" :style="{ borderColor: 'var(--border-primary)' }">
        <!-- Звезды -->
        <div class="flex items-center mb-4 sm:mb-6">
          <div class="flex space-x-1">
            <svg v-for="n in 5" :key="n" class="w-4 h-4 sm:w-5 sm:h-5" fill="currentColor" viewBox="0 0 20 20" :style="{ color: '#fbbf24' }">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
          </div>
        </div>

        <!-- Цитата -->
        <blockquote class="text-sm sm:text-base md:text-lg leading-relaxed mb-4 sm:mb-6 relative pl-6 sm:pl-8" :style="{ color: 'var(--text-color-main)' }">
          <svg class="absolute top-0 left-0 w-4 h-4 sm:w-6 sm:h-6" fill="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color-light)' }">
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
          </svg>
          "Переделка квартиры прошла без проблем. Иван продумал каждый сантиметр. Теперь у нас уютное и стильное пространство для всей семьи."
        </blockquote>

        <!-- Автор -->
        <div class="flex items-center">
          <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="Марина Козлова" class="w-10 h-10 sm:w-12 sm:h-12 md:w-14 md:h-14 rounded-full shadow-lg border-2 border-white">
          <div class="ml-3 sm:ml-4">
            <div class="font-bold text-sm sm:text-base" :style="{ color: 'var(--text-color-main)' }">Марина Козлова</div>
            <div class="text-xs sm:text-sm" :style="{ color: 'var(--text-color-light)' }">Квартира, 95 м²</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Статистика доверия -->
    <div class="mt-16">
      <div class="rounded-2xl p-8 md:p-12" :style="{ background: `linear-gradient(135deg, var(--primary-color-light)10, var(--background-secondary), var(--primary-color-light)10)` }">
        <div class="text-center mb-8">
          <h3 class="text-2xl md:text-3xl font-bold mb-4" :style="{ color: 'var(--text-color-main)' }">Цифры, которые говорят сами за себя</h3>
          <p :style="{ color: 'var(--text-color-light)' }">Результаты нашей совместной работы</p>
        </div>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold mb-2" :style="{ color: 'var(--primary-color)' }">98%</div>
            <div class="text-sm font-medium" :style="{ color: 'var(--text-color-light)' }">Довольных клиентов</div>
          </div>
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold mb-2" :style="{ color: 'var(--primary-color)' }">4.9</div>
            <div class="text-sm font-medium" :style="{ color: 'var(--text-color-light)' }">Средний рейтинг</div>
          </div>
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold mb-2" :style="{ color: 'var(--primary-color)' }">45</div>
            <div class="text-sm font-medium" :style="{ color: 'var(--text-color-light)' }">Дней средний срок</div>
          </div>
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold mb-2" :style="{ color: 'var(--primary-color)' }">67%</div>
            <div class="text-sm font-medium" :style="{ color: 'var(--text-color-light)' }">Повторных клиентов</div>
          </div>
        </div>
      </div>
    </div>

    <!-- CTA для отзывов -->
    <div class="mt-12 text-center">
      <p class="mb-6" :style="{ color: 'var(--text-color-light)' }">Хотите присоединиться к довольным клиентам?</p>
      <a href="#contacts" class="inline-flex items-center px-8 py-4 font-medium rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1" :style="{ backgroundColor: 'var(--primary-color)', color: 'var(--primary-color-contrast)' }">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-3.582 8-8 8a8.13 8.13 0 01-2.906-.515L7 21l1.515-3.094A8.002 8.002 0 013 12c0-4.418 3.582-8 8-8s8 3.582 8 8z"></path>
        </svg>
        Обсудить ваш проект
      </a>
    </div>
  </section>
</template>
