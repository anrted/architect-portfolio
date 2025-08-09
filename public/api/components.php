<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

require_once 'db.php';

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        // Получить настройки компонентов главной страницы (публичный доступ)
        try {
            $stmt = $pdo->prepare("SELECT setting_value FROM site_settings WHERE setting_key = 'home_components'");
            $stmt->execute();
            $result = $stmt->fetch();
            
            if ($result) {
                $components = json_decode($result['setting_value'], true);
            } else {
                // Значения по умолчанию
                $components = [
                    [
                        'id' => 'about',
                        'name' => 'О себе',
                        'component' => 'About',
                        'visible' => true,
                        'order' => 1,
                        'description' => 'Секция с информацией о себе'
                    ],
                    [
                        'id' => 'gallery',
                        'name' => 'Галерея',
                        'component' => 'Gallery',
                        'visible' => true,
                        'order' => 2,
                        'description' => 'Галерея проектов'
                    ],
                    [
                        'id' => 'steps',
                        'name' => 'Этапы работы',
                        'component' => 'Steps',
                        'visible' => true,
                        'order' => 3,
                        'description' => 'Этапы работы над проектами'
                    ],
                    [
                        'id' => 'reviews',
                        'name' => 'Отзывы',
                        'component' => 'Reviews',
                        'visible' => true,
                        'order' => 4,
                        'description' => 'Отзывы клиентов'
                    ],
                    [
                        'id' => 'contacts',
                        'name' => 'Контакты',
                        'component' => 'Contacts',
                        'visible' => true,
                        'order' => 5,
                        'description' => 'Контактная информация'
                    ]
                ];
            }
            
            echo json_encode($components, JSON_UNESCAPED_UNICODE);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка получения компонентов: ' . $e->getMessage()]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Метод не поддерживается']);
        break;
}
?>
