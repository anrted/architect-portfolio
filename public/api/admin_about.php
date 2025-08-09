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
        // Получить контент главной страницы
        $user = checkAdminAuth(['about_content' => ['read']]);
        
        $sectionName = $_GET['section'] ?? 'hero';
        
        $stmt = $pdo->prepare('SELECT * FROM about_content WHERE section_name = ? AND is_active = TRUE');
        $stmt->execute([$sectionName]);
        $content = $stmt->fetch();
        
        if (!$content) {
            http_response_code(404);
            echo json_encode(['error' => 'Content not found']);
            exit;
        }
        
        // Декодируем JSON поля
        $content['advantages'] = json_decode($content['advantages'], true) ?? [];
        $content['statistics'] = json_decode($content['statistics'], true) ?? [];
        
        echo json_encode($content, JSON_UNESCAPED_UNICODE);
        break;
        
    case 'PUT':
        // Обновить контент главной страницы
        $user = checkAdminAuth(['about_content' => ['update']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        $sectionName = $data['section_name'] ?? 'hero';
        
        if (!isset($data['title']) || !$data['title']) {
            http_response_code(400);
            echo json_encode(['error' => 'Title is required']);
            exit;
        }
        
        try {
            // Проверяем, существует ли запись
            $checkStmt = $pdo->prepare('SELECT id FROM about_content WHERE section_name = ?');
            $checkStmt->execute([$sectionName]);
            $existing = $checkStmt->fetch();
            
            if ($existing) {
                // Обновляем существующую запись
                $stmt = $pdo->prepare('UPDATE about_content SET title = ?, subtitle = ?, main_text = ?, advantages = ?, statistics = ? WHERE section_name = ?');
                $stmt->execute([
                    $data['title'],
                    $data['subtitle'] ?? '',
                    $data['main_text'] ?? '',
                    json_encode($data['advantages'] ?? []),
                    json_encode($data['statistics'] ?? []),
                    $sectionName
                ]);
            } else {
                // Создаем новую запись
                $stmt = $pdo->prepare('INSERT INTO about_content (section_name, title, subtitle, main_text, advantages, statistics) VALUES (?, ?, ?, ?, ?, ?)');
                $stmt->execute([
                    $sectionName,
                    $data['title'],
                    $data['subtitle'] ?? '',
                    $data['main_text'] ?? '',
                    json_encode($data['advantages'] ?? []),
                    json_encode($data['statistics'] ?? [])
                ]);
            }
            
            echo json_encode(['success' => true]);
            
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Failed to update content: ' . $e->getMessage()]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
}
?>
