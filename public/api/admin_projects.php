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
        // Получить все проекты с блоками для админки
        $user = checkAdminAuth(['projects' => ['read']]);
        
        $page = intval($_GET['page'] ?? 1);
        $limit = intval($_GET['limit'] ?? 10);
        $search = $_GET['search'] ?? '';
        $offset = ($page - 1) * $limit;
        
        $whereClause = '';
        $params = [];
        
        if ($search) {
            $whereClause = 'WHERE title LIKE ? OR description LIKE ?';
            $params = ["%$search%", "%$search%"];
        }
        
        // Получаем общее количество
        $countStmt = $pdo->prepare("SELECT COUNT(*) as total FROM projects $whereClause");
        $countStmt->execute($params);
        $total = $countStmt->fetch()['total'];
        
        // Получаем проекты с пагинацией
        $stmt = $pdo->prepare("SELECT * FROM projects $whereClause ORDER BY created_at DESC LIMIT ? OFFSET ?");
        $stmt->execute(array_merge($params, [$limit, $offset]));
        $projects = $stmt->fetchAll();
        
        // Получаем блоки для каждого проекта
        foreach ($projects as &$project) {
            $blockStmt = $pdo->prepare('SELECT * FROM project_blocks WHERE project_id = ? ORDER BY sort_order ASC, id ASC');
            $blockStmt->execute([$project['id']]);
            $project['blocks'] = $blockStmt->fetchAll();
        }
        
        echo json_encode([
            'projects' => $projects,
            'pagination' => [
                'current_page' => $page,
                'total_pages' => ceil($total / $limit),
                'total_items' => $total,
                'per_page' => $limit
            ]
        ]);
        break;
        
    case 'POST':
        // Создать новый проект
        $user = checkAdminAuth(['projects' => ['create']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        if (!isset($data['title']) || !$data['title']) {
            http_response_code(400);
            echo json_encode(['error' => 'Title is required']);
            exit;
        }
        
        $pdo->beginTransaction();
        
        try {
            // Создаем проект
            $stmt = $pdo->prepare('INSERT INTO projects (title, description, image_url) VALUES (?, ?, ?)');
            $stmt->execute([
                $data['title'],
                $data['description'] ?? '',
                $data['image_url'] ?? ''
            ]);
            
            $projectId = $pdo->lastInsertId();
            
            // Добавляем блоки если они есть
            if (isset($data['blocks']) && is_array($data['blocks'])) {
                $blockStmt = $pdo->prepare('INSERT INTO project_blocks (project_id, type, content, sort_order) VALUES (?, ?, ?, ?)');
                
                foreach ($data['blocks'] as $index => $block) {
                    $blockStmt->execute([
                        $projectId,
                        $block['type'] ?? 'text',
                        $block['content'] ?? '',
                        $index
                    ]);
                }
            }
            
            $pdo->commit();
            echo json_encode(['success' => true, 'id' => $projectId]);
            
        } catch (Exception $e) {
            $pdo->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Failed to create project: ' . $e->getMessage()]);
        }
        break;
        
    case 'PUT':
        // Обновить проект
        $user = checkAdminAuth(['projects' => ['update']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        $projectId = $data['id'] ?? null;
        
        if (!$projectId) {
            http_response_code(400);
            echo json_encode(['error' => 'Project ID is required']);
            exit;
        }
        
        $pdo->beginTransaction();
        
        try {
            // Обновляем проект
            $stmt = $pdo->prepare('UPDATE projects SET title = ?, description = ?, image_url = ? WHERE id = ?');
            $stmt->execute([
                $data['title'] ?? '',
                $data['description'] ?? '',
                $data['image_url'] ?? '',
                $projectId
            ]);
            
            // Удаляем старые блоки
            $deleteStmt = $pdo->prepare('DELETE FROM project_blocks WHERE project_id = ?');
            $deleteStmt->execute([$projectId]);
            
            // Добавляем новые блоки
            if (isset($data['blocks']) && is_array($data['blocks'])) {
                $blockStmt = $pdo->prepare('INSERT INTO project_blocks (project_id, type, content, sort_order) VALUES (?, ?, ?, ?)');
                
                foreach ($data['blocks'] as $index => $block) {
                    $blockStmt->execute([
                        $projectId,
                        $block['type'] ?? 'text',
                        $block['content'] ?? '',
                        $index
                    ]);
                }
            }
            
            $pdo->commit();
            echo json_encode(['success' => true]);
            
        } catch (Exception $e) {
            $pdo->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Failed to update project: ' . $e->getMessage()]);
        }
        break;
        
    case 'DELETE':
        // Удалить проект
        $user = checkAdminAuth(['projects' => ['delete']]);
        
        $projectId = $_GET['id'] ?? null;
        if (!$projectId) {
            http_response_code(400);
            echo json_encode(['error' => 'Project ID is required']);
            exit;
        }
        
        $pdo->beginTransaction();
        
        try {
            // Удаляем блоки проекта
            $deleteBlocksStmt = $pdo->prepare('DELETE FROM project_blocks WHERE project_id = ?');
            $deleteBlocksStmt->execute([$projectId]);
            
            // Удаляем проект
            $deleteProjectStmt = $pdo->prepare('DELETE FROM projects WHERE id = ?');
            $deleteProjectStmt->execute([$projectId]);
            
            $pdo->commit();
            echo json_encode(['success' => true]);
            
        } catch (Exception $e) {
            $pdo->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Failed to delete project: ' . $e->getMessage()]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
}
?>
