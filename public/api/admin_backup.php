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
    case 'POST':
        // Создать резервную копию базы данных
        $user = checkAdminAuth(['admin_users' => ['read']]);
        
        try {
            // Получаем параметры подключения к БД
            $host = 'localhost';
            $db   = 'architect_portfolio';
            $user_db = 'arch_user';
            $pass = 'arch_pass_2025';
            $charset = 'utf8mb4';
            
            // Создаем имя файла с текущей датой и временем
            $timestamp = date('Y-m-d_H-i-s');
            $backup_filename = "backup_architect_portfolio_{$timestamp}.sql";
            $backup_path = "../backups/";
            
            // Создаем директорию для бэкапов если её нет
            if (!is_dir($backup_path)) {
                mkdir($backup_path, 0755, true);
            }
            
            // Полный путь к файлу бэкапа
            $full_backup_path = $backup_path . $backup_filename;
            
            // Команда для создания бэкапа
            $command = "mysqldump --host={$host} --user={$user_db} --password={$pass} --single-transaction --routines --triggers {$db} > {$full_backup_path} 2>&1";
            
            // Выполняем команду
            $output = [];
            $return_var = 0;
            exec($command, $output, $return_var);
            
            if ($return_var !== 0) {
                // Если mysqldump не работает, создаем бэкап через PHP
                $backup_content = createBackupViaPHP($host, $db, $user_db, $pass);
                if ($backup_content === false) {
                    throw new Exception('Не удалось создать резервную копию');
                }
                file_put_contents($full_backup_path, $backup_content);
            }
            
            // Проверяем, что файл создался и не пустой
            if (!file_exists($full_backup_path) || filesize($full_backup_path) === 0) {
                throw new Exception('Файл резервной копии не создан или пустой');
            }
            
            // Получаем размер файла
            $file_size = filesize($full_backup_path);
            $file_size_formatted = formatFileSize($file_size);
            
            echo json_encode([
                'success' => true,
                'message' => 'Резервная копия успешно создана',
                'filename' => $backup_filename,
                'file_size' => $file_size_formatted,
                'created_at' => date('Y-m-d H:i:s'),
                'download_url' => "/api/download_backup.php?file=" . urlencode($backup_filename)
            ], JSON_UNESCAPED_UNICODE);
            
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка создания резервной копии: ' . $e->getMessage()]);
        }
        break;
        
    case 'GET':
        // Получить список резервных копий
        $user = checkAdminAuth(['admin_users' => ['read']]);
        
        try {
            $backup_path = "../backups/";
            $backups = [];
            
            if (is_dir($backup_path)) {
                $files = glob($backup_path . "backup_*.sql");
                
                foreach ($files as $file) {
                    $filename = basename($file);
                    $file_size = filesize($file);
                    $file_time = filemtime($file);
                    
                    $backups[] = [
                        'filename' => $filename,
                        'file_size' => formatFileSize($file_size),
                        'created_at' => date('Y-m-d H:i:s', $file_time),
                        'download_url' => "/api/download_backup.php?file=" . urlencode($filename)
                    ];
                }
                
                // Сортируем по дате создания (новые сначала)
                usort($backups, function($a, $b) {
                    return strtotime($b['created_at']) - strtotime($a['created_at']);
                });
            }
            
            echo json_encode([
                'success' => true,
                'backups' => $backups
            ], JSON_UNESCAPED_UNICODE);
            
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка получения списка резервных копий: ' . $e->getMessage()]);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
}

/**
 * Создает резервную копию через PHP (если mysqldump недоступен)
 */
function createBackupViaPHP($host, $db, $user, $pass) {
    try {
        $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $backup = "-- Резервная копия базы данных {$db}\n";
        $backup .= "-- Создано: " . date('Y-m-d H:i:s') . "\n\n";
        
        // Получаем список всех таблиц
        $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
        
        foreach ($tables as $table) {
            $backup .= "-- Структура таблицы `{$table}`\n";
            
            // Получаем CREATE TABLE
            $create_table = $pdo->query("SHOW CREATE TABLE `{$table}`")->fetch();
            $backup .= $create_table[1] . ";\n\n";
            
            // Получаем данные
            $rows = $pdo->query("SELECT * FROM `{$table}`")->fetchAll(PDO::FETCH_ASSOC);
            
            if (!empty($rows)) {
                $backup .= "-- Данные таблицы `{$table}`\n";
                
                foreach ($rows as $row) {
                    $values = [];
                    foreach ($row as $value) {
                        if ($value === null) {
                            $values[] = 'NULL';
                        } else {
                            $values[] = $pdo->quote($value);
                        }
                    }
                    $backup .= "INSERT INTO `{$table}` VALUES (" . implode(', ', $values) . ");\n";
                }
                $backup .= "\n";
            }
        }
        
        return $backup;
        
    } catch (Exception $e) {
        return false;
    }
}

/**
 * Форматирует размер файла в читаемый вид
 */
function formatFileSize($bytes) {
    $units = ['B', 'KB', 'MB', 'GB'];
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    
    $bytes /= pow(1024, $pow);
    
    return round($bytes, 2) . ' ' . $units[$pow];
}
?>
