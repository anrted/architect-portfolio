<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'db.php';

// Получение полной информации по проекту с блоками
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if (!$id) {
    http_response_code(400);
    echo json_encode(['error' => 'ID is required']);
    exit;
}
// Получаем сам проект
$stmt = $pdo->prepare('SELECT * FROM projects WHERE id = ?');
$stmt->execute([$id]);
$project = $stmt->fetch();
if (!$project) {
    http_response_code(404);
    echo json_encode(['error' => 'Project not found']);
    exit;
}
// Получаем блоки проекта
$stmt = $pdo->prepare('SELECT type, content FROM project_blocks WHERE project_id = ? ORDER BY sort_order ASC, id ASC');
$stmt->execute([$id]);
$blocks = $stmt->fetchAll();
$project['blocks'] = $blocks;
echo json_encode($project, JSON_UNESCAPED_UNICODE);
