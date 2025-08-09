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
        // Получить контактную информацию
        $user = checkAdminAuth(['contacts_content' => ['read']]);
        
        $sectionName = $_GET['section'] ?? 'contacts';
        
        $stmt = $pdo->prepare('SELECT * FROM contacts_content WHERE section_name = ? AND is_active = TRUE');
        $stmt->execute([$sectionName]);
        $content = $stmt->fetch();
        
        if (!$content) {
            http_response_code(404);
            echo json_encode(['error' => 'Content not found']);
            exit;
        }
        
        // Декодируем JSON поля
        $content['contact_info'] = json_decode($content['contact_info'], true) ?? [];
        $content['social_links'] = json_decode($content['social_links'], true) ?? [];
        $content['working_hours'] = json_decode($content['working_hours'], true) ?? [];
        
        echo json_encode($content, JSON_UNESCAPED_UNICODE);
        break;
        
    case 'PUT':
        // Обновить контактную информацию
        $user = checkAdminAuth(['contacts_content' => ['update']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        $sectionName = $data['section_name'] ?? 'contacts';
        
        if (!isset($data['title']) || !$data['title']) {
            http_response_code(400);
            echo json_encode(['error' => 'Title is required']);
            exit;
        }
        
        try {
            // Проверяем, существует ли запись
            $checkStmt = $pdo->prepare('SELECT id FROM contacts_content WHERE section_name = ?');
            $checkStmt->execute([$sectionName]);
            $existing = $checkStmt->fetch();
            
            if ($existing) {
                // Обновляем существующую запись
                $stmt = $pdo->prepare('UPDATE contacts_content SET title = ?, subtitle = ?, contact_info = ?, social_links = ?, working_hours = ? WHERE section_name = ?');
                $stmt->execute([
                    $data['title'],
                    $data['subtitle'] ?? '',
                    json_encode($data['contact_info'] ?? []),
                    json_encode($data['social_links'] ?? []),
                    json_encode($data['working_hours'] ?? []),
                    $sectionName
                ]);
            } else {
                // Создаем новую запись
                $stmt = $pdo->prepare('INSERT INTO contacts_content (section_name, title, subtitle, contact_info, social_links, working_hours) VALUES (?, ?, ?, ?, ?, ?)');
                $stmt->execute([
                    $sectionName,
                    $data['title'],
                    $data['subtitle'] ?? '',
                    json_encode($data['contact_info'] ?? []),
                    json_encode($data['social_links'] ?? []),
                    json_encode($data['working_hours'] ?? [])
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
