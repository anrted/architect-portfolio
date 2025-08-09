<template>
  <section id="reviews" class="mb-20">
    <!-- Заголовок -->
    <div class="text-center mb-16">
      <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">Отзывы клиентов</h2>
      <p class="text-xl text-gray-600 max-w-2xl mx-auto">
        Мнения тех, кто доверил мне создание своих проектов
      </p>
    </div>

    <!-- Отзывы -->
    <div class="grid lg:grid-cols-3 md:grid-cols-2 gap-8">
      <!-- Отзыв 1 -->
      <div class="group bg-white rounded-2xl shadow-lg p-8 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 border border-gray-100">
        <!-- Звезды -->
        <div class="flex items-center mb-6">
          <div class="flex space-x-1">
            <svg v-for="n in 5" :key="n" class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
          </div>
        </div>

        <!-- Цитата -->
        <blockquote class="text-gray-700 text-lg leading-relaxed mb-6 relative">
          <svg class="absolute -top-2 -left-2 w-8 h-8 text-blue-200" fill="currentColor" viewBox="0 0 24 24">
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
          </svg>
          "Работа выполнена на высшем уровне! Иван не просто создал проект дома моей мечты, но и учел все мои пожелания. Результат превзошел ожидания."
        </blockquote>

        <!-- Автор -->
        <div class="flex items-center">
          <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="Анна Петрова" class="w-14 h-14 rounded-full shadow-lg border-2 border-white">
          <div class="ml-4">
            <div class="font-bold text-gray-900">Анна Петрова</div>
            <div class="text-sm text-gray-500">Частный дом, 250 м²</div>
          </div>
        </div>
      </div>

      <!-- Отзыв 2 -->
      <div class="group bg-white rounded-2xl shadow-lg p-8 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 border border-gray-100">
        <!-- Звезды -->
        <div class="flex items-center mb-6">
          <div class="flex space-x-1">
            <svg v-for="n in 5" :key="n" class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
          </div>
        </div>

        <!-- Цитата -->
        <blockquote class="text-gray-700 text-lg leading-relaxed mb-6 relative">
          <svg class="absolute -top-2 -left-2 w-8 h-8 text-blue-200" fill="currentColor" viewBox="0 0 24 24">
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
          </svg>
          "Потрясающий проект офиса! Пространство стало функциональным и современным. Команда работает в комфорте. Рекомендую всем!"
        </blockquote>

        <!-- Автор -->
        <div class="flex items-center">
          <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Сергей Иванов" class="w-14 h-14 rounded-full shadow-lg border-2 border-white">
          <div class="ml-4">
            <div class="font-bold text-gray-900">Сергей Иванов</div>
            <div class="text-sm text-gray-500">Офис IT-компании, 180 м²</div>
          </div>
        </div>
      </div>

      <!-- Отзыв 3 -->
      <div class="group bg-white rounded-2xl shadow-lg p-8 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2 border border-gray-100">
        <!-- Звезды -->
        <div class="flex items-center mb-6">
          <div class="flex space-x-1">
            <svg v-for="n in 5" :key="n" class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
          </div>
        </div>

        <!-- Цитата -->
        <blockquote class="text-gray-700 text-lg leading-relaxed mb-6 relative">
          <svg class="absolute -top-2 -left-2 w-8 h-8 text-blue-200" fill="currentColor" viewBox="0 0 24 24">
            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
          </svg>
          "Переделка квартиры прошла без проблем. Иван продумал каждый сантиметр. Теперь у нас уютное и стильное пространство для всей семьи."
        </blockquote>

        <!-- Автор -->
        <div class="flex items-center">
          <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="Марина Козлова" class="w-14 h-14 rounded-full shadow-lg border-2 border-white">
          <div class="ml-4">
            <div class="font-bold text-gray-900">Марина Козлова</div>
            <div class="text-sm text-gray-500">Квартира, 95 м²</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Статистика доверия -->
    <div class="mt-16">
      <div class="bg-gradient-to-r from-blue-50 to-blue-100 rounded-2xl p-8 md:p-12">
        <div class="text-center mb-8">
          <h3 class="text-2xl md:text-3xl font-bold text-gray-900 mb-4">Цифры, которые говорят сами за себя</h3>
          <p class="text-gray-600">Результаты нашей совместной работы</p>
        </div>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold text-blue-600 mb-2">98%</div>
            <div class="text-sm text-gray-600 font-medium">Довольных клиентов</div>
          </div>
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold text-blue-600 mb-2">4.9</div>
            <div class="text-sm text-gray-600 font-medium">Средний рейтинг</div>
          </div>
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold text-blue-600 mb-2">45</div>
            <div class="text-sm text-gray-600 font-medium">Дней средний срок</div>
          </div>
          <div class="text-center">
            <div class="text-3xl md:text-4xl font-bold text-blue-600 mb-2">67%</div>
            <div class="text-sm text-gray-600 font-medium">Повторных клиентов</div>
          </div>
      </div>
      </div>
    </div>

    <!-- CTA для отзывов -->
    <div class="mt-12 text-center">
      <p class="text-gray-600 mb-6">Хотите присоединиться к довольным клиентам?</p>
      <a href="#contacts" class="inline-flex items-center px-8 py-4 bg-blue-600 text-white font-medium rounded-xl shadow-lg hover:bg-blue-700 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-3.582 8-8 8a8.13 8.13 0 01-2.906-.515L7 21l1.515-3.094A8.002 8.002 0 013 12c0-4.418 3.582-8 8-8s8 3.582 8 8z"></path>
        </svg>
        Обсудить ваш проект
      </a>
    </div>
  </section>
</template>
