<?php
// Middleware для проверки прав доступа к админке
require_once 'db.php';

function checkAdminAuth($requiredPermissions = null) {
    $headers = getallheaders();
    $sessionId = $headers['Authorization'] ?? $headers['authorization'] ?? null;
    
    if ($sessionId && strpos($sessionId, 'Bearer ') === 0) {
        $sessionId = substr($sessionId, 7);
    }
    
    if (!$sessionId) {
        http_response_code(401);
        echo json_encode(['error' => 'Authorization header required']);
        exit;
    }
    
    global $pdo;
    
    $stmt = $pdo->prepare('
        SELECT u.*, s.expires_at 
        FROM admin_users u 
        JOIN admin_sessions s ON u.id = s.user_id 
        WHERE s.id = ? AND s.expires_at > NOW() AND u.is_active = 1
    ');
    $stmt->execute([$sessionId]);
    $user = $stmt->fetch();
    
    if (!$user) {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid or expired session']);
        exit;
    }
    
    // Проверяем права доступа если они указаны
    if ($requiredPermissions) {
        $permissions = json_decode($user['permissions'], true);
        
        if (!checkPermissions($permissions, $requiredPermissions, $user['role'])) {
            http_response_code(403);
            echo json_encode(['error' => 'Insufficient permissions']);
            exit;
        }
    }
    
    return $user;
}

function checkPermissions($userPermissions, $requiredPermissions, $userRole = null) {
    // Если у пользователя роль admin, то у него есть все права
    if ($userRole === 'admin') {
        return true;
    }
    
    if ($userPermissions === null) {
        return false;
    }
    
    foreach ($requiredPermissions as $resource => $actions) {
        if (!isset($userPermissions[$resource])) {
            return false;
        }
        
        foreach ($actions as $action) {
            if (!isset($userPermissions[$resource][$action]) || !$userPermissions[$resource][$action]) {
                return false;
            }
        }
    }
    
    return true;
}

function hasPermission($user, $resource, $action) {
    $permissions = json_decode($user['permissions'], true);
    
    if ($permissions === null) {
        return false;
    }
    
    return isset($permissions[$resource][$action]) && $permissions[$resource][$action];
}
?>
