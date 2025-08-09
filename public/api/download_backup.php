<?php
require_once 'admin_middleware.php';

// Проверяем авторизацию
try {
    $user = checkAdminAuth(['admin_users' => ['read']]);
} catch (Exception $e) {
    http_response_code(401);
    echo 'Unauthorized';
    exit;
}

// Получаем имя файла
$filename = $_GET['file'] ?? '';

if (empty($filename)) {
    http_response_code(400);
    echo 'Filename is required';
    exit;
}

// Проверяем, что файл существует и находится в папке backups
$backup_path = "../backups/";
$full_path = $backup_path . $filename;

// Проверяем безопасность пути
if (!file_exists($full_path) || !is_file($full_path) || strpos(realpath($full_path), realpath($backup_path)) !== 0) {
    http_response_code(404);
    echo 'File not found';
    exit;
}

// Проверяем расширение файла
if (pathinfo($filename, PATHINFO_EXTENSION) !== 'sql') {
    http_response_code(400);
    echo 'Invalid file type';
    exit;
}

// Устанавливаем заголовки для скачивания
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Content-Length: ' . filesize($full_path));
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Sat, 26 Jul 1997 05:00:00 GMT');

// Отправляем файл
readfile($full_path);
exit;
?>
