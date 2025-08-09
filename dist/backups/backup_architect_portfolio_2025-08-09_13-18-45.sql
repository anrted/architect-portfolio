mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: architect_portfolio
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces

--
-- Table structure for table `about_content`
--

DROP TABLE IF EXISTS `about_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `about_content` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `main_text` text,
  `advantages` json DEFAULT NULL,
  `statistics` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `section_name` (`section_name`),
  KEY `idx_section_name` (`section_name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `about_content`
--

LOCK TABLES `about_content` WRITE;
/*!40000 ALTER TABLE `about_content` DISABLE KEYS */;
INSERT INTO `about_content` VALUES (1,'hero','Иван Иванов','Архитектор современности','Я — архитектор с опытом более 10 лет, специализирующийся на современных жилых и общественных зданиях. В каждом проекте стремлюсь найти баланс между эстетикой, функциональностью и устойчивостью.\r\n\r\nМой подход основан на глубоком понимании потребностей клиента, внимании к деталям и использовании передовых технологий в архитектуре.','[{\"icon\": \"check\", \"text\": \"10+ лет опыта\"}, {\"icon\": \"lightning\", \"text\": \"Инновационный подход\"}, {\"icon\": \"clock\", \"text\": \"Точность в сроках\"}, {\"icon\": \"heart\", \"text\": \"Индивидуальный подход\"}]','[{\"label\": \"Реализованных проектов\", \"value\": \"50+\"}, {\"label\": \"Лет опыта\", \"value\": \"10\"}, {\"label\": \"Довольных клиентов\", \"value\": \"100%\"}, {\"label\": \"Наград\", \"value\": \"5\"}]',1,'2025-08-09 05:35:17','2025-08-09 05:35:17');
/*!40000 ALTER TABLE `about_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_sessions`
--

DROP TABLE IF EXISTS `admin_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `admin_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `admin_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_sessions`
--

LOCK TABLES `admin_sessions` WRITE;
/*!40000 ALTER TABLE `admin_sessions` DISABLE KEYS */;
INSERT INTO `admin_sessions` VALUES ('2a72a62bfd81476bef2f2531cca2f9ce3f5d698e2913b4cb9020e189721e8443a9d01735bf8ca6a58638d85beef9fda128705bab7af47b9a2c8dcb72efa81176',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','2025-08-09 09:25:20','2025-08-10 09:25:20'),('35cd6a70292e02393bc4884334354af4e1c65dd228c54b103464254958e9ec61ae56fbf9854688f8706c0a58c032c5918400e279335e7ec4a4d9130b8ca12b68',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','2025-08-09 09:03:24','2025-08-10 09:03:24'),('79b692423633c1e00ee35f845e26d8402d7d3ed705eb331291dbf125e6193f1111617380c878d6089f1a97a7954e5146af7eaaecf218f9649b2325d3d3ec4b59',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','2025-08-09 04:53:10','2025-08-10 04:53:10'),('b85534f6ad35dea88d7b115020609c902b9b89f7abe3dd21dc435d585c7b5a52d02fb3ee07dbfcd613295347efcf2f381bf2659df0ea4ac6cf1423698c4a0644',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','2025-08-09 09:20:39','2025-08-10 09:20:39');
/*!40000 ALTER TABLE `admin_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `role` enum('admin','editor') DEFAULT 'admin',
  `permissions` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES (2,'admin','admin@architect-portfolio.local','$2y$10$I85dUbobw4UUwa7CvgpZmOWWBJUql0TXRdflpcxSXXDFN/bMpbD7W','Администратор','admin','{\"blocks\": {\"read\": true, \"create\": true, \"delete\": true, \"update\": true}, \"projects\": {\"read\": true, \"create\": true, \"delete\": true, \"update\": true}, \"admin_users\": {\"read\": true, \"create\": true, \"delete\": true, \"update\": true}, \"about_content\": {\"read\": true, \"create\": true, \"delete\": true, \"update\": true}, \"header_content\": {\"read\": true, \"create\": true, \"delete\": true, \"update\": true}, \"contacts_content\": {\"read\": true, \"create\": true, \"delete\": true, \"update\": true}}',1,'2025-08-09 09:03:24','2025-08-09 04:41:36','2025-08-09 09:03:24'),(3,'test','test@test','$2y$10$4k9p0B9zQUb/VfjUvAV8oO54U2BcteG4Dy/SzO.z63.C1.fBYKkaK','testt','editor','{\"projects\": {\"read\": true, \"create\": true, \"delete\": false, \"update\": true}, \"admin_users\": {\"read\": false, \"create\": false, \"delete\": false, \"update\": false}, \"admin_backup\": {\"read\": false, \"create\": false}, \"about_content\": {\"read\": false, \"update\": false}, \"header_content\": {\"read\": false, \"update\": false}, \"contacts_content\": {\"read\": false, \"update\": false}}',1,'2025-08-09 09:25:20','2025-08-09 09:20:27','2025-08-09 09:25:20');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts_content`
--

DROP TABLE IF EXISTS `contacts_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts_content` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `contact_info` json DEFAULT NULL,
  `social_links` json DEFAULT NULL,
  `working_hours` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `section_name` (`section_name`),
  KEY `idx_section_name` (`section_name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_content`
--

LOCK TABLES `contacts_content` WRITE;
/*!40000 ALTER TABLE `contacts_content` DISABLE KEYS */;
INSERT INTO `contacts_content` VALUES (1,'contacts','Свяжитесь со мной','Готов обсудить ваш проект и воплотить архитектурные идеи в реальность','[{\"icon\": \"email\", \"type\": \"email\", \"label\": \"Email\", \"value\": \"ivan.architect@email.com\"}, {\"icon\": \"phone\", \"type\": \"phone\", \"label\": \"Телефон\", \"value\": \"+7 (999) 123-45-67\"}, {\"icon\": \"location\", \"type\": \"address\", \"label\": \"Офис\", \"value\": \"г. Москва, ул. Архитектурная, 12\\nБЦ \\\"Современность\\\", офис 305\"}]','[{\"url\": \"#\", \"icon\": \"twitter\", \"platform\": \"twitter\"}, {\"url\": \"#\", \"icon\": \"facebook\", \"platform\": \"facebook\"}, {\"url\": \"#\", \"icon\": \"linkedin\", \"platform\": \"linkedin\"}, {\"url\": \"#\", \"icon\": \"instagram\", \"platform\": \"instagram\"}]','[{\"days\": \"Пн-Пт\", \"hours\": \"9:00 - 18:00\"}, {\"days\": \"Сб-Вс\", \"hours\": \"по договоренности\"}]',1,'2025-08-09 05:42:59','2025-08-09 05:42:59');
/*!40000 ALTER TABLE `contacts_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `header_content`
--

DROP TABLE IF EXISTS `header_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `header_content` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `navigation_links` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `section_name` (`section_name`),
  KEY `idx_section_name` (`section_name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `header_content`
--

LOCK TABLES `header_content` WRITE;
/*!40000 ALTER TABLE `header_content` DISABLE KEYS */;
INSERT INTO `header_content` VALUES (1,'header','Архитектор Иван Иванов','Современная архитектура','[{\"url\": \"/\", \"text\": \"Обо мне\", \"type\": \"router-link\"}, {\"url\": \"/projects\", \"text\": \"Проекты\", \"type\": \"router-link\"}, {\"url\": \"#contacts\", \"text\": \"Контакты\", \"type\": \"anchor\"}]',1,'2025-08-09 06:31:16','2025-08-09 06:31:16');
/*!40000 ALTER TABLE `header_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_blocks`
--

DROP TABLE IF EXISTS `project_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_blocks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `type` enum('image','text') NOT NULL,
  `content` text NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_blocks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_blocks`
--

LOCK TABLES `project_blocks` WRITE;
/*!40000 ALTER TABLE `project_blocks` DISABLE KEYS */;
INSERT INTO `project_blocks` VALUES (9,1,'image','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZOm7aZE0EbfWuS_tpez-3F9bflZxepISvAQ&s',0),(10,1,'text','Какой-то текст в первом блоке',1),(11,1,'image','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn7LXpnu4WTqaR1dxsuLsd7NG3PkXdvmzeMg&s',2),(12,1,'text','Еще текст',3);
/*!40000 ALTER TABLE `project_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `image_url` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Новый проект','Описание проекта','https://s3.stroi-news.ru/img/krasivii-zagorodnii-dom-krasivo-1.jpg','2025-08-08 18:24:55','2025-08-09 07:32:19'),(2,'тест','домик вот','','2025-08-09 09:27:59','2025-08-09 09:27:59');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author` varchar(100) NOT NULL,
  `text` text NOT NULL,
  `avatar_url` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_type` enum('string','json','boolean','number') COLLATE utf8mb4_unicode_ci DEFAULT 'string',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
INSERT INTO `site_settings` VALUES (19,'color_palette','{\"primary\":{\"main\":\"#1d873c\",\"light\":\"#38d465\",\"dark\":\"#145f2a\",\"contrast\":\"#ffffff\"},\"secondary\":{\"main\":\"#64748b\",\"light\":\"#94a3b8\",\"dark\":\"#475569\",\"contrast\":\"#ffffff\"},\"accent\":{\"main\":\"#f59e0b\",\"light\":\"#fbbf24\",\"dark\":\"#d97706\",\"contrast\":\"#000000\"},\"background\":{\"primary\":\"#ffffff\",\"secondary\":\"#f8fafc\",\"tertiary\":\"#f1f5f9\"},\"text\":{\"primary\":\"#1e293b\",\"secondary\":\"#64748b\",\"muted\":\"#94a3b8\"},\"border\":{\"primary\":\"#e2e8f0\",\"secondary\":\"#cbd5e1\"},\"success\":{\"main\":\"#10b981\",\"light\":\"#34d399\",\"dark\":\"#059669\"},\"error\":{\"main\":\"#ef4444\",\"light\":\"#f87171\",\"dark\":\"#dc2626\"},\"warning\":{\"main\":\"#f59e0b\",\"light\":\"#fbbf24\",\"dark\":\"#d97706\"},\"info\":{\"main\":\"#3b82f6\",\"light\":\"#60a5fa\",\"dark\":\"#2563eb\"}}','json','Настройки цветовой палитры сайта для админки','2025-08-09 09:49:35','2025-08-09 10:06:21'),(20,'theme_mode','light','string','Режим темы: light, dark, auto','2025-08-09 09:49:35','2025-08-09 09:50:32'),(21,'custom_css','','string','Пользовательские CSS стили','2025-08-09 09:49:35','2025-08-09 09:50:32'),(22,'site_title_color','#1e293b','string','Цвет заголовка сайта','2025-08-09 09:49:35','2025-08-09 09:50:32'),(23,'site_description_color','#64748b','string','Цвет описания сайта','2025-08-09 09:49:35','2025-08-09 09:50:32'),(24,'button_primary_color','#2563eb','string','Основной цвет кнопок','2025-08-09 09:49:35','2025-08-09 09:50:32'),(25,'button_secondary_color','#64748b','string','Вторичный цвет кнопок','2025-08-09 09:49:35','2025-08-09 09:50:32'),(26,'link_color','#2563eb','string','Цвет ссылок','2025-08-09 09:49:35','2025-08-09 09:50:32'),(27,'link_hover_color','#1d4ed8','string','Цвет ссылок при наведении','2025-08-09 09:49:35','2025-08-09 09:50:32');
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'architect_portfolio'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-09 17:18:45
