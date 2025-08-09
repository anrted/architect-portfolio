<?php
header('Content-Type: application/json; charset=utf-8');
require_once 'db.php';

// Получение контактной информации
$sectionName = $_GET['section'] ?? 'contacts';

$stmt = $pdo->prepare('SELECT * FROM contacts_content WHERE section_name = ? AND is_active = TRUE');
$stmt->execute([$sectionName]);
$content = $stmt->fetch();

if (!$content) {
    // Возвращаем значения по умолчанию если контент не найден
    $content = [
        'title' => 'Свяжитесь со мной',
        'subtitle' => 'Готов обсудить ваш проект и воплотить архитектурные идеи в реальность',
        'contact_info' => json_encode([
            ['type' => 'email', 'label' => 'Email', 'value' => 'ivan.architect@email.com', 'icon' => 'email'],
            ['type' => 'phone', 'label' => 'Телефон', 'value' => '+7 (999) 123-45-67', 'icon' => 'phone'],
            ['type' => 'address', 'label' => 'Офис', 'value' => "г. Москва, ул. Архитектурная, 12\nБЦ \"Современность\", офис 305", 'icon' => 'location']
        ]),
        'social_links' => json_encode([
            ['platform' => 'twitter', 'url' => '#', 'icon' => 'twitter'],
            ['platform' => 'facebook', 'url' => '#', 'icon' => 'facebook'],
            ['platform' => 'linkedin', 'url' => '#', 'icon' => 'linkedin'],
            ['platform' => 'instagram', 'url' => '#', 'icon' => 'instagram']
        ]),
        'working_hours' => json_encode([
            ['days' => 'Пн-Пт', 'hours' => '9:00 - 18:00'],
            ['days' => 'Сб-Вс', 'hours' => 'по договоренности']
        ])
    ];
}

// Декодируем JSON поля
$content['contact_info'] = json_decode($content['contact_info'], true) ?? [];
$content['social_links'] = json_decode($content['social_links'], true) ?? [];
$content['working_hours'] = json_decode($content['working_hours'], true) ?? [];

echo json_encode($content, JSON_UNESCAPED_UNICODE);
?>
