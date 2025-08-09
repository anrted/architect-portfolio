<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'db.php';

// Получение контента шапки
$sectionName = $_GET['section'] ?? 'header';

$stmt = $pdo->prepare('SELECT * FROM header_content WHERE section_name = ? AND is_active = TRUE');
$stmt->execute([$sectionName]);
$content = $stmt->fetch();

if (!$content) {
    // Возвращаем значения по умолчанию если контент не найден
    $content = [
        'title' => 'Архитектор Иван Иванов',
        'subtitle' => 'Современная архитектура',
        'navigation_links' => json_encode([
            ['text' => 'Обо мне', 'url' => '/', 'type' => 'router-link'],
            ['text' => 'Проекты', 'url' => '/projects', 'type' => 'router-link'],
            ['text' => 'Контакты', 'url' => '#contacts', 'type' => 'anchor']
        ])
    ];
}

// Декодируем JSON поля
$content['navigation_links'] = json_decode($content['navigation_links'], true) ?? [];

echo json_encode($content, JSON_UNESCAPED_UNICODE);
?>
