<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once 'db.php';

// Проверяем, что подключение к базе данных успешно
if (!$pdo) {
    http_response_code(500);
    echo json_encode(['error' => 'Ошибка подключения к базе данных']);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        // Получение настроек
        $setting_key = $_GET['key'] ?? null;
        
        if ($setting_key) {
            // Получить конкретную настройку
            $stmt = $pdo->prepare("SELECT setting_key, setting_value, setting_type, description FROM site_settings WHERE setting_key = ?");
            $stmt->execute([$setting_key]);
            $setting = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($setting) {
                // Преобразовать JSON в объект если нужно
                if ($setting['setting_type'] === 'json') {
                    $setting['setting_value'] = json_decode($setting['setting_value'], true);
                } elseif ($setting['setting_type'] === 'boolean') {
                    $setting['setting_value'] = (bool)$setting['setting_value'];
                } elseif ($setting['setting_type'] === 'number') {
                    $setting['setting_value'] = is_numeric($setting['setting_value']) ? (float)$setting['setting_value'] : $setting['setting_value'];
                }
                
                echo json_encode($setting);
            } else {
                http_response_code(404);
                echo json_encode(['error' => 'Настройка не найдена']);
            }
        } else {
            // Получить все настройки
            $stmt = $pdo->query("SELECT setting_key, setting_value, setting_type, description FROM site_settings ORDER BY setting_key");
            $settings = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Преобразовать JSON значения
            foreach ($settings as &$setting) {
                if ($setting['setting_type'] === 'json') {
                    $setting['setting_value'] = json_decode($setting['setting_value'], true);
                } elseif ($setting['setting_type'] === 'boolean') {
                    $setting['setting_value'] = (bool)$setting['setting_value'];
                } elseif ($setting['setting_type'] === 'number') {
                    $setting['setting_value'] = is_numeric($setting['setting_value']) ? (float)$setting['setting_value'] : $setting['setting_value'];
                }
            }
            
            echo json_encode($settings);
        }
        break;
        
    case 'POST':
    case 'PUT':
        // Обновление или создание настроек
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!$input) {
            http_response_code(400);
            echo json_encode(['error' => 'Неверный формат данных']);
            exit;
        }
        
        $setting_key = $input['setting_key'] ?? null;
        $setting_value = $input['setting_value'] ?? null;
        $setting_type = $input['setting_type'] ?? 'string';
        $description = $input['description'] ?? '';
        
        if (!$setting_key || $setting_value === null) {
            http_response_code(400);
            echo json_encode(['error' => 'Отсутствуют обязательные поля: setting_key, setting_value']);
            exit;
        }
        
        // Преобразовать значение в строку для сохранения
        if ($setting_type === 'json' && is_array($setting_value)) {
            $setting_value = json_encode($setting_value, JSON_UNESCAPED_UNICODE);
        } elseif ($setting_type === 'boolean') {
            $setting_value = $setting_value ? '1' : '0';
        }
        
        try {
            $stmt = $pdo->prepare("INSERT INTO site_settings (setting_key, setting_value, setting_type, description) 
                                  VALUES (?, ?, ?, ?) 
                                  ON DUPLICATE KEY UPDATE 
                                  setting_value = VALUES(setting_value), 
                                  setting_type = VALUES(setting_type), 
                                  description = VALUES(description),
                                  updated_at = CURRENT_TIMESTAMP");
            
            $stmt->execute([$setting_key, $setting_value, $setting_type, $description]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Настройка успешно сохранена',
                'setting_key' => $setting_key
            ]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка сохранения: ' . $e->getMessage()]);
        }
        break;
        
    case 'DELETE':
        // Удаление настройки
        $setting_key = $_GET['key'] ?? null;
        
        if (!$setting_key) {
            http_response_code(400);
            echo json_encode(['error' => 'Не указан ключ настройки для удаления']);
            exit;
        }
        
        try {
            $stmt = $pdo->prepare("DELETE FROM site_settings WHERE setting_key = ?");
            $stmt->execute([$setting_key]);
            
            if ($stmt->rowCount() > 0) {
                echo json_encode([
                    'success' => true,
                    'message' => 'Настройка успешно удалена',
                    'setting_key' => $setting_key
                ]);
            } else {
                http_response_code(404);
                echo json_encode(['error' => 'Настройка не найдена']);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка удаления: ' . $e->getMessage()]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Метод не поддерживается']);
        break;
}
?>
