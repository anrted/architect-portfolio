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
        // Получить список пользователей
        $user = checkAdminAuth(['admin_users' => ['read']]);
        
        $page = intval($_GET['page'] ?? 1);
        $limit = intval($_GET['limit'] ?? 10);
        $search = $_GET['search'] ?? '';
        $offset = ($page - 1) * $limit;
        
        $whereClause = '';
        $params = [];
        
        if ($search) {
            $whereClause = 'WHERE username LIKE ? OR email LIKE ? OR full_name LIKE ?';
            $params = ["%$search%", "%$search%", "%$search%"];
        }
        
        // Получаем общее количество
        $countStmt = $pdo->prepare("SELECT COUNT(*) as total FROM admin_users $whereClause");
        $countStmt->execute($params);
        $total = $countStmt->fetch()['total'];
        
        // Получаем пользователей с пагинацией
        $stmt = $pdo->prepare("SELECT id, username, email, full_name, role, permissions, is_active, last_login, created_at, updated_at FROM admin_users $whereClause ORDER BY created_at DESC LIMIT ? OFFSET ?");
        $stmt->execute(array_merge($params, [$limit, $offset]));
        $users = $stmt->fetchAll();
        
        // Декодируем permissions для каждого пользователя
        foreach ($users as &$user) {
            $user['permissions'] = json_decode($user['permissions'], true) ?: [];
        }
        
        echo json_encode([
            'success' => true,
            'users' => $users,
            'pagination' => [
                'current_page' => $page,
                'per_page' => $limit,
                'total_items' => $total,
                'total_pages' => ceil($total / $limit)
            ]
        ]);
        break;
        
    case 'POST':
        // Создать нового пользователя
        $user = checkAdminAuth(['admin_users' => ['create']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        
        $username = $data['username'] ?? '';
        $email = $data['email'] ?? '';
        $password = $data['password'] ?? '';
        $fullName = $data['full_name'] ?? '';
        $role = $data['role'] ?? 'editor';
        $permissions = $data['permissions'] ?? [];
        $isActive = $data['is_active'] ?? true;
        
        if (!$username || !$email || !$password || !$fullName) {
            http_response_code(400);
            echo json_encode(['error' => 'Все обязательные поля должны быть заполнены']);
            exit;
        }
        
        // Проверяем уникальность username и email
        $stmt = $pdo->prepare('SELECT id FROM admin_users WHERE username = ? OR email = ?');
        $stmt->execute([$username, $email]);
        if ($stmt->fetch()) {
            http_response_code(400);
            echo json_encode(['error' => 'Пользователь с таким логином или email уже существует']);
            exit;
        }
        
        // Хэшируем пароль
        $passwordHash = password_hash($password, PASSWORD_DEFAULT);
        
        // Подготавливаем permissions
        $permissionsJson = json_encode($permissions);
        
        $stmt = $pdo->prepare('INSERT INTO admin_users (username, email, password_hash, full_name, role, permissions, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)');
        
        if ($stmt->execute([$username, $email, $passwordHash, $fullName, $role, $permissionsJson, $isActive])) {
            $userId = $pdo->lastInsertId();
            
            // Получаем созданного пользователя
            $stmt = $pdo->prepare('SELECT id, username, email, full_name, role, permissions, is_active, last_login, created_at, updated_at FROM admin_users WHERE id = ?');
            $stmt->execute([$userId]);
            $newUser = $stmt->fetch();
            $newUser['permissions'] = json_decode($newUser['permissions'], true) ?: [];
            
            echo json_encode([
                'success' => true,
                'message' => 'Пользователь успешно создан',
                'user' => $newUser
            ]);
        } else {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка при создании пользователя']);
        }
        break;
        
    case 'PUT':
        // Обновить пользователя
        $user = checkAdminAuth(['admin_users' => ['update']]);
        
        $data = json_decode(file_get_contents('php://input'), true);
        $userId = $data['id'] ?? null;
        
        if (!$userId) {
            http_response_code(400);
            echo json_encode(['error' => 'ID пользователя обязателен']);
            exit;
        }
        
        // Получаем текущего пользователя
        $stmt = $pdo->prepare('SELECT * FROM admin_users WHERE id = ?');
        $stmt->execute([$userId]);
        $currentUser = $stmt->fetch();
        
        if (!$currentUser) {
            http_response_code(404);
            echo json_encode(['error' => 'Пользователь не найден']);
            exit;
        }
        
        // Обновляем поля
        $username = $data['username'] ?? $currentUser['username'];
        $email = $data['email'] ?? $currentUser['email'];
        $fullName = $data['full_name'] ?? $currentUser['full_name'];
        $role = $data['role'] ?? $currentUser['role'];
        $permissions = $data['permissions'] ?? json_decode($currentUser['permissions'], true);
        $isActive = $data['is_active'] ?? $currentUser['is_active'];
        
        // Проверяем уникальность username и email (исключая текущего пользователя)
        $stmt = $pdo->prepare('SELECT id FROM admin_users WHERE (username = ? OR email = ?) AND id != ?');
        $stmt->execute([$username, $email, $userId]);
        if ($stmt->fetch()) {
            http_response_code(400);
            echo json_encode(['error' => 'Пользователь с таким логином или email уже существует']);
            exit;
        }
        
        // Подготавливаем permissions
        $permissionsJson = json_encode($permissions);
        
        // Обновляем пароль только если он предоставлен
        if (!empty($data['password'])) {
            $passwordHash = password_hash($data['password'], PASSWORD_DEFAULT);
            $stmt = $pdo->prepare('UPDATE admin_users SET username = ?, email = ?, password_hash = ?, full_name = ?, role = ?, permissions = ?, is_active = ? WHERE id = ?');
            $stmt->execute([$username, $email, $passwordHash, $fullName, $role, $permissionsJson, $isActive, $userId]);
        } else {
            $stmt = $pdo->prepare('UPDATE admin_users SET username = ?, email = ?, full_name = ?, role = ?, permissions = ?, is_active = ? WHERE id = ?');
            $stmt->execute([$username, $email, $fullName, $role, $permissionsJson, $isActive, $userId]);
        }
        
        // Получаем обновленного пользователя
        $stmt = $pdo->prepare('SELECT id, username, email, full_name, role, permissions, is_active, last_login, created_at, updated_at FROM admin_users WHERE id = ?');
        $stmt->execute([$userId]);
        $updatedUser = $stmt->fetch();
        $updatedUser['permissions'] = json_decode($updatedUser['permissions'], true) ?: [];
        
        echo json_encode([
            'success' => true,
            'message' => 'Пользователь успешно обновлен',
            'user' => $updatedUser
        ]);
        break;
        
    case 'DELETE':
        // Удалить пользователя
        $user = checkAdminAuth(['admin_users' => ['delete']]);
        
        $userId = $_GET['id'] ?? null;
        
        if (!$userId) {
            http_response_code(400);
            echo json_encode(['error' => 'ID пользователя обязателен']);
            exit;
        }
        
        // Проверяем, что пользователь существует
        $stmt = $pdo->prepare('SELECT id FROM admin_users WHERE id = ?');
        $stmt->execute([$userId]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'Пользователь не найден']);
            exit;
        }
        
        // Проверяем, что не удаляем самого себя
        if ($userId == $user['id']) {
            http_response_code(400);
            echo json_encode(['error' => 'Нельзя удалить самого себя']);
            exit;
        }
        
        // Удаляем пользователя
        $stmt = $pdo->prepare('DELETE FROM admin_users WHERE id = ?');
        if ($stmt->execute([$userId])) {
            echo json_encode([
                'success' => true,
                'message' => 'Пользователь успешно удален'
            ]);
        } else {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка при удалении пользователя']);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
        break;
}
?>
