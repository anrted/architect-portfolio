<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'db.php';

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        // Получить все проекты
        $stmt = $pdo->query('SELECT * FROM projects ORDER BY created_at DESC');
        echo json_encode($stmt->fetchAll());
        break;
    case 'POST':
        // Добавить проект
        $data = json_decode(file_get_contents('php://input'), true);
        if (!isset($data['title']) || !$data['title']) {
            http_response_code(400);
            echo json_encode(['error' => 'Title is required']);
            exit;
        }
        $desc = $data['description'] ?? '';
        $img = $data['image_url'] ?? '';
        $stmt = $pdo->prepare('INSERT INTO projects (title, description, image_url) VALUES (?, ?, ?)');
        $stmt->execute([$data['title'], $desc, $img]);
        echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
        break;
    case 'DELETE':
        // Удалить проект по id
        parse_str(file_get_contents('php://input'), $delVars);
        $id = $delVars['id'] ?? null;
        if (!$id) {
            http_response_code(400);
            echo json_encode(['error' => 'ID is required']);
            exit;
        }
        $stmt = $pdo->prepare('DELETE FROM projects WHERE id = ?');
        $stmt->execute([$id]);
        echo json_encode(['success' => true]);
        break;
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
}
