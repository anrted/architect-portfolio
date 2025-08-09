<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'db.php';

// Получение контента главной страницы
$sectionName = $_GET['section'] ?? 'hero';

$stmt = $pdo->prepare('SELECT * FROM about_content WHERE section_name = ? AND is_active = TRUE');
$stmt->execute([$sectionName]);
$content = $stmt->fetch();

if (!$content) {
    // Возвращаем значения по умолчанию если контент не найден
    $content = [
        'title' => 'Иван Иванов',
        'subtitle' => 'Архитектор современности',
        'main_text' => 'Я — архитектор с опытом более 10 лет, специализирующийся на современных жилых и общественных зданиях. В каждом проекте стремлюсь найти баланс между эстетикой, функциональностью и устойчивостью.',
        'advantages' => json_encode([
            ['text' => '10+ лет опыта', 'icon' => 'check'],
            ['text' => 'Инновационный подход', 'icon' => 'lightning'],
            ['text' => 'Точность в сроках', 'icon' => 'clock'],
            ['text' => 'Индивидуальный подход', 'icon' => 'heart']
        ]),
        'statistics' => json_encode([
            ['value' => '50+', 'label' => 'Реализованных проектов'],
            ['value' => '10', 'label' => 'Лет опыта'],
            ['value' => '100%', 'label' => 'Довольных клиентов'],
            ['value' => '5', 'label' => 'Наград']
        ])
    ];
}

// Декодируем JSON поля
$content['advantages'] = json_decode($content['advantages'], true) ?? [];
$content['statistics'] = json_decode($content['statistics'], true) ?? [];

echo json_encode($content, JSON_UNESCAPED_UNICODE);
?>
