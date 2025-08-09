<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

require_once 'db.php';

function generateSessionId() {
    return bin2hex(random_bytes(64));
}

function hashPassword($password) {
    return password_hash($password, PASSWORD_DEFAULT);
}

function verifyPassword($password, $hash) {
    return password_verify($password, $hash);
}

function createSession($userId, $pdo) {
    $sessionId = generateSessionId();
    $expiresAt = date('Y-m-d H:i:s', time() + (24 * 60 * 60)); // 24 часа
    $ipAddress = $_SERVER['REMOTE_ADDR'] ?? null;
    $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    
    $stmt = $pdo->prepare('INSERT INTO admin_sessions (id, user_id, ip_address, user_agent, expires_at) VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$sessionId, $userId, $ipAddress, $userAgent, $expiresAt]);
    
    return $sessionId;
}

function getSessionUser($sessionId, $pdo) {
    $stmt = $pdo->prepare('
        SELECT u.*, s.expires_at 
        FROM admin_users u 
        JOIN admin_sessions s ON u.id = s.user_id 
        WHERE s.id = ? AND s.expires_at > NOW() AND u.is_active = 1
    ');
    $stmt->execute([$sessionId]);
    return $stmt->fetch();
}

function deleteSession($sessionId, $pdo) {
    $stmt = $pdo->prepare('DELETE FROM admin_sessions WHERE id = ?');
    $stmt->execute([$sessionId]);
}

switch ($_SERVER['REQUEST_METHOD']) {
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $action = $data['action'] ?? '';
        
        switch ($action) {
            case 'login':
                $username = $data['username'] ?? '';
                $password = $data['password'] ?? '';
                
                if (!$username || !$password) {
                    http_response_code(400);
                    echo json_encode(['error' => 'Username and password are required']);
                    exit;
                }
                
                $stmt = $pdo->prepare('SELECT * FROM admin_users WHERE username = ? AND is_active = 1');
                $stmt->execute([$username]);
                $user = $stmt->fetch();
                
                if (!$user || !verifyPassword($password, $user['password_hash'])) {
                    http_response_code(401);
                    echo json_encode(['error' => 'Invalid credentials']);
                    exit;
                }
                
                // Обновляем последний вход
                $stmt = $pdo->prepare('UPDATE admin_users SET last_login = NOW() WHERE id = ?');
                $stmt->execute([$user['id']]);
                
                $sessionId = createSession($user['id'], $pdo);
                
                echo json_encode([
                    'success' => true,
                    'session_id' => $sessionId,
                    'user' => [
                        'id' => $user['id'],
                        'username' => $user['username'],
                        'email' => $user['email'],
                        'full_name' => $user['full_name'],
                        'role' => $user['role'],
                        'permissions' => json_decode($user['permissions'], true)
                    ]
                ]);
                break;
                
            case 'logout':
                $sessionId = $data['session_id'] ?? '';
                if ($sessionId) {
                    deleteSession($sessionId, $pdo);
                }
                echo json_encode(['success' => true]);
                break;
                
            case 'check':
                $sessionId = $data['session_id'] ?? '';
                if (!$sessionId) {
                    http_response_code(401);
                    echo json_encode(['error' => 'Session ID required']);
                    exit;
                }
                
                $user = getSessionUser($sessionId, $pdo);
                if (!$user) {
                    http_response_code(401);
                    echo json_encode(['error' => 'Invalid or expired session']);
                    exit;
                }
                
                echo json_encode([
                    'success' => true,
                    'user' => [
                        'id' => $user['id'],
                        'username' => $user['username'],
                        'email' => $user['email'],
                        'full_name' => $user['full_name'],
                        'role' => $user['role'],
                        'permissions' => json_decode($user['permissions'], true)
                    ]
                ]);
                break;
                
            default:
                http_response_code(400);
                echo json_encode(['error' => 'Invalid action']);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
}
?>
