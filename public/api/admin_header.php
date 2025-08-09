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
        // Получить контент шапки
        $user = checkAdminAuth(['header_content' => ['read']]);
        
        $sectionName = $_GET['section'] ?? 'header';
        
        $stmt = $pdo->prepare('SELECT * FROM header_content WHERE section_name = ? AND is_active = TRUE');
        $stmt->execute([$sectionName]);
        $content = $stmt->fetch();
        
        if (!$content) {
            http_response_code(404);
            echo json_encode(['error' => 'Content not found']);
            exit;
        }
        
        // Декодируем JSON поля
        $content['navigation_links'] = json_decode($content['navigation_links'], true) ?? [];
        
        echo json_encode($content, JSON_UNESCAPED_UNICODE);
        break;
        
    case 'PUT':
        // Обновить контент шапки
        $user = checkAdminAuth(['header_content' => ['update']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        $sectionName = $data['section_name'] ?? 'header';
        
        if (!isset($data['title']) || !$data['title']) {
            http_response_code(400);
            echo json_encode(['error' => 'Title is required']);
            exit;
        }
        
        try {
            // Проверяем, существует ли запись
            $checkStmt = $pdo->prepare('SELECT id FROM header_content WHERE section_name = ?');
            $checkStmt->execute([$sectionName]);
            $existing = $checkStmt->fetch();
            
            if ($existing) {
                // Обновляем существующую запись
                $stmt = $pdo->prepare('UPDATE header_content SET title = ?, subtitle = ?, navigation_links = ? WHERE section_name = ?');
                $stmt->execute([
                    $data['title'],
                    $data['subtitle'] ?? '',
                    json_encode($data['navigation_links'] ?? []),
                    $sectionName
                ]);
            } else {
                // Создаем новую запись
                $stmt = $pdo->prepare('INSERT INTO header_content (section_name, title, subtitle, navigation_links) VALUES (?, ?, ?, ?)');
                $stmt->execute([
                    $sectionName,
                    $data['title'],
                    $data['subtitle'] ?? '',
                    json_encode($data['navigation_links'] ?? [])
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
