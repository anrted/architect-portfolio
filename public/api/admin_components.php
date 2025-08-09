<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

require_once 'admin_middleware.php';

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        // Получить настройки компонентов главной страницы
        $user = checkAdminAuth(['about_content' => ['read']]);
        
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
        
    case 'POST':
    case 'PUT':
        // Обновить настройки компонентов
        $user = checkAdminAuth(['about_content' => ['update']]);
        
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!$input || !is_array($input)) {
            http_response_code(400);
            echo json_encode(['error' => 'Неверный формат данных']);
            exit;
        }
        
        try {
            // Валидация данных
            foreach ($input as $component) {
                if (!isset($component['id']) || !isset($component['name']) || !isset($component['component'])) {
                    http_response_code(400);
                    echo json_encode(['error' => 'Отсутствуют обязательные поля в компоненте']);
                    exit;
                }
            }
            
            // Сохраняем в базу данных
            $stmt = $pdo->prepare("INSERT INTO site_settings (setting_key, setting_value, setting_type, description) 
                                  VALUES ('home_components', ?, 'json', 'Настройки компонентов главной страницы') 
                                  ON DUPLICATE KEY UPDATE 
                                  setting_value = VALUES(setting_value), 
                                  updated_at = CURRENT_TIMESTAMP");
            
            $stmt->execute([json_encode($input, JSON_UNESCAPED_UNICODE)]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Настройки компонентов успешно сохранены',
                'components' => $input
            ]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка сохранения компонентов: ' . $e->getMessage()]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Метод не поддерживается']);
        break;
}
?>
