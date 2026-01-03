/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: tantsaha_connect
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0+deb12u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agricultural_advices`
--

DROP TABLE IF EXISTS `agricultural_advices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agricultural_advices` (
  `id` char(36) NOT NULL,
  `region_id` char(36) DEFAULT NULL,
  `crop_type` text NOT NULL,
  `season` text NOT NULL,
  `title_mg` text NOT NULL,
  `content_mg` text NOT NULL,
  `icon` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `weather_condition` varchar(32) DEFAULT NULL,
  `min_temp` int(11) DEFAULT NULL,
  `max_temp` int(11) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `min_wind` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_agricultural_advices_region` (`region_id`),
  CONSTRAINT `fk_advices_region` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agricultural_advices`
--

LOCK TABLES `agricultural_advices` WRITE;
/*!40000 ALTER TABLE `agricultural_advices` DISABLE KEYS */;
INSERT INTO `agricultural_advices` VALUES
('5821c969-e5cc-11f0-9b22-58946b2ab360',NULL,'all','fambolena','Torohevitra rehefa orana','• Arotsaho fasika na bozaka amin’ny tany miolaka hisorohana ny fikorontanan’ny tany.\n• Aza asiana zezika manta mivantana rehefa avy orana be; miandrasa 3–5 andro.\n• Amboary lakandrano hanaraha-drano manodidina ny saha.\n• Aza mamafy amin\'ny lohasaha mitangoronan\'ny rano.\n• Ataovy lavaka famorian-drano (bassin) haka rano ho an\'ny fotoam-maina.','🌧️','2025-12-31 02:43:13','Rain',NULL,NULL,10,NULL),
('5821cf32-e5cc-11f0-9b22-58946b2ab360',NULL,'all','fambolena','Torohevitra rehefa orana','• Arotsaho fasika na bozaka amin’ny tany miolaka hisorohana ny fikorontanan’ny tany.\n• Aza asiana zezika manta mivantana rehefa avy orana be; miandrasa 3–5 andro.\n• Amboary lakandrano hanaraha-drano manodidina ny saha.\n• Aza mamafy amin\'ny lohasaha mitangoronan\'ny rano.\n• Ataovy lavaka famorian-drano (bassin) haka rano ho an\'ny fotoam-maina.','🌧️','2025-12-31 02:43:13','Rainy',NULL,NULL,10,NULL),
('5821d0df-e5cc-11f0-9b22-58946b2ab360',NULL,'all','fambolena','Torohevitra rehefa orana be','• Amboary lakandrano sy fivoahan-drano.\n• Miandrasa 3–5 andro vao asiana zezika manta.\n• Fadio ny famafazana amin\'ny toerana mitangoronan\'ny rano.','⛈️','2025-12-31 02:43:13','Thunderstorm',NULL,NULL,12,NULL),
('638af8d1-e5cc-11f0-9b22-58946b2ab360',NULL,'all','fambolena','Torohevitra rehefa mafana','• Afangaro zezika manta + komposta ary asiana rakotra bozaka ny tanimboly.\n• Alaivo rano maraina na hariva rehefa mitsimoka voly.\n• Aza mamafy amin’ny 10 ora – 3 ora.\n• Ampiasao kolontsaina mifangaro (maize + tsaramaso).\n• Arotsaho mololo sy ravina manodidina ny voly.','☀️','2025-12-31 02:43:32',NULL,30,NULL,8,NULL),
('b5b63260-e5cc-11f0-9b22-58946b2ab360',NULL,'all','fambolena','Torohevitra rehefa misy rivotra mahery','• Ataovy fefy bozaka na hazobe amin’ny sisin-tsaha.\n• Ahitsio ny voly mitsilamolamoka ary afangaroy tany maina hanamafisana azy.\n• Atsaharo ny famafazana zezika maina mandritra ny rivotra.','💨','2025-12-31 02:45:50',NULL,NULL,NULL,9,30),
('c214b48e-e5cc-11f0-9b22-58946b2ab360',NULL,'all','fambolena','Torohevitra rehefa mangatsiaka','• Ataovy lavaka kely mitazona hamandoana sy hafanana eo amin’ny fakany.\n• Sasao rano mafana indraindray ny voa vao mitsimoka.','❄️','2025-12-31 02:46:10',NULL,NULL,18,7,NULL);
/*!40000 ALTER TABLE `agricultural_advices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_templates`
--

DROP TABLE IF EXISTS `alert_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert_templates` (
  `id` char(36) NOT NULL,
  `alert_type` varchar(50) NOT NULL,
  `severity` varchar(20) NOT NULL,
  `title_mg` varchar(255) NOT NULL,
  `message_mg` text NOT NULL,
  `recommendation_mg` text DEFAULT NULL,
  `weather_condition` varchar(30) DEFAULT NULL,
  `min_temp` decimal(5,2) DEFAULT NULL,
  `max_temp` decimal(5,2) DEFAULT NULL,
  `min_wind` decimal(5,2) DEFAULT NULL,
  `max_wind` decimal(5,2) DEFAULT NULL,
  `min_humidity` decimal(5,2) DEFAULT NULL,
  `max_humidity` decimal(5,2) DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  `is_active` tinyint(4) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_templates`
--

LOCK TABLES `alert_templates` WRITE;
/*!40000 ALTER TABLE `alert_templates` DISABLE KEYS */;
INSERT INTO `alert_templates` VALUES
('cda91cfc-e66a-11f0-9d7e-2647efd973b1','storm','danger','Rivo-doza mety hitranga','Mety hisy tselatra sy rivotra mahery. Aza mijanona eny an-kampo rehefa misy tselatra.','Ataovy azo antoka ny fitaovana, mitadiava fialofana.','Thunderstorm',NULL,NULL,20.00,NULL,NULL,NULL,100,1),
('cda92107-e66a-11f0-9d7e-2647efd973b1','storm','warning','Fampitandremana tselatra','Mety hisy oram-baratra. Mitandrema amin’ny asa ivelany.','Atsaharo ny asa eny an-kampo raha manomboka tselatra.','Thunderstorm',NULL,NULL,NULL,NULL,NULL,NULL,90,1),
('cda9223c-e66a-11f0-9d7e-2647efd973b1','rain','warning','Orana mitohy','Orana mety hitohy ka mampitombo ny hamandoana sy ny loza amin’ny bibikely.','Hamarino ny lakandrano sy ny fanariana rano.','Rain',NULL,NULL,NULL,NULL,70.00,NULL,80,1),
('cda9232f-e66a-11f0-9d7e-2647efd973b1','rain','info','Orana maivana','Hisian’orana maivana. Mety tsara ho an’ny famafazana sasany, fa tandremo ny lalan-drano.','Ataovy madio ny lakandrano.','Rainy',NULL,NULL,NULL,NULL,NULL,NULL,40,1),
('cda92400-e66a-11f0-9d7e-2647efd973b1','heat','danger','Hafanana be','Hafanana avo dia mety hanimba ny zava-maniry sy hampitombo ny filàn-drano.','Ataovy maraina/hariva ny asa, omeo rano matetika ny voly.',NULL,35.00,NULL,NULL,NULL,NULL,NULL,100,1),
('cda924aa-e66a-11f0-9d7e-2647efd973b1','heat','warning','Hafanana miakatra','Miakatra ny hafanana, tandremo ny haintany sy ny fahasimban’ny ravina.','Ampitomboy ny fanondrahana raha azo atao.',NULL,32.00,NULL,NULL,NULL,NULL,NULL,70,1),
('cda92516-e66a-11f0-9d7e-2647efd973b1','cold','warning','Hatsiaka amin’ny maraina','Mety hisy hatsiaka amin’ny maraina ka manelingelina ny fitomboan’ny voly sasany.','Sarony ny zana-ketsa raha ilaina.',NULL,NULL,12.00,NULL,NULL,NULL,NULL,60,1),
('cda9257f-e66a-11f0-9d7e-2647efd973b1','cold','danger','Hatsiaka mahery','Hatsiaka be mety hanimba zana-ketsa.','Sarony tsara ny voly, aza manao famafazana alina.',NULL,NULL,8.00,NULL,NULL,NULL,NULL,90,1),
('cda925f9-e66a-11f0-9d7e-2647efd973b1','wind','warning','Rivotra mahery','Rivotra mahery mety hanapaka ravina na handrava “tuteur”.','Ampaherezo ny fanohanana ny voly (tuteur).',NULL,NULL,NULL,18.00,NULL,NULL,NULL,80,1),
('cda92661-e66a-11f0-9d7e-2647efd973b1','wind','info','Rivotra antonony','Rivotra mety hampihena hamandoana, tandremo ny voly mora maina.','Araho maso ny fanondrahana.',NULL,NULL,NULL,10.00,17.00,NULL,NULL,30,1),
('cda926c6-e66a-11f0-9d7e-2647efd973b1','work','info','Fotoana mety hiasana','Rahona/tsy dia mafana loatra: mety tsara hanaovana asa eny an-kampo.','Manararaotra manao famafazana/fiompiana amin’izao.','Cloudy',NULL,NULL,NULL,NULL,NULL,NULL,10,1),
('cda92729-e66a-11f0-9d7e-2647efd973b1','work','info','Rahona mavesatra','Rahona mavesatra mety hitarika orana any aoriana.','Hamarino ny fitaovana sy ny fitehirizana.','Overcast',NULL,NULL,NULL,NULL,NULL,NULL,15,1);
/*!40000 ALTER TABLE `alert_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crop_journal`
--

DROP TABLE IF EXISTS `crop_journal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `crop_journal` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `observation_date` date NOT NULL,
  `observation_type` text NOT NULL,
  `crop_type` text DEFAULT NULL,
  `notes_mg` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_crop_journal_user_date` (`user_id`,`observation_date`),
  CONSTRAINT `fk_journal_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crop_journal`
--

LOCK TABLES `crop_journal` WRITE;
/*!40000 ALTER TABLE `crop_journal` DISABLE KEYS */;
INSERT INTO `crop_journal` VALUES
('a5bee0a7-e4dd-11f0-8bfd-ab8fcb4c1ca7','89b5f95a-de6e-11f0-b690-92eff7073b14','2025-12-30','planting','wxcc','wsx','2025-12-29 21:38:08'),
('f58d03f6-e4cf-11f0-8bfd-ab8fcb4c1ca7','89b5f95a-de6e-11f0-b690-92eff7073b14','2025-12-29','rain','nb ','jb k','2025-12-29 16:03:47');
/*!40000 ALTER TABLE `crop_journal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manual_weather_alerts`
--

DROP TABLE IF EXISTS `manual_weather_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `manual_weather_alerts` (
  `id` char(36) NOT NULL,
  `region_id` int(11) NOT NULL,
  `title_mg` varchar(255) NOT NULL,
  `message_mg` text NOT NULL,
  `recommendation_mg` text DEFAULT NULL,
  `severity` enum('danger','warning','info') NOT NULL DEFAULT 'info',
  `weather_condition` enum('heat','frost','rain','any') DEFAULT 'any',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manual_weather_alerts`
--

LOCK TABLES `manual_weather_alerts` WRITE;
/*!40000 ALTER TABLE `manual_weather_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `manual_weather_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles` (
  `id` char(36) NOT NULL,
  `full_name` text NOT NULL,
  `region_id` char(36) DEFAULT NULL,
  `profile_photo_url` text DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_profiles_region` (`region_id`),
  CONSTRAINT `fk_profiles_region` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_profiles_user` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES
('2c9201cf-de9d-11f0-91ae-58946b2ab360','alvin','9856b6aa-d81f-11f0-bdbb-58946b2ab360',NULL,NULL,'2025-12-21 19:39:02','2025-12-21 19:39:02'),
('83d115b2-d82f-11f0-bdbb-58946b2ab360','Loic','9856c15b-d81f-11f0-bdbb-58946b2ab360',NULL,NULL,'2025-12-13 14:25:04','2025-12-13 14:25:04'),
('89b5f95a-de6e-11f0-b690-92eff7073b14','alvin','9856b6aa-d81f-11f0-bdbb-58946b2ab360',NULL,NULL,'2025-12-21 13:11:18','2025-12-21 13:11:18'),
('92799600-de64-11f0-b690-92eff7073b14','Alvin Deriaz','9856c15b-d81f-11f0-bdbb-58946b2ab360',NULL,NULL,'2025-12-21 11:59:58','2025-12-21 11:59:58'),
('df39bdc8-d8d7-11f0-ae70-c465ab2ee0dd','Heritiana','9856bf1c-d81f-11f0-bdbb-58946b2ab360',NULL,NULL,'2025-12-15 10:36:12','2025-12-15 10:36:12'),
('fa83153e-df56-11f0-8183-8d0c92bbf187','kevin','9856b6aa-d81f-11f0-bdbb-58946b2ab360',NULL,NULL,'2025-12-22 16:55:11','2025-12-22 16:55:11');
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `id` char(36) NOT NULL,
  `name` text NOT NULL,
  `name_fr` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES
('9856b6aa-d81f-11f0-bdbb-58946b2ab360','Antananarivo','Analamanga','2025-12-13 12:31:05'),
('9856bda6-d81f-11f0-bdbb-58946b2ab360','Diego','Diana','2025-12-13 12:31:05'),
('9856bdf4-d81f-11f0-bdbb-58946b2ab360','Mahajanga','Boeny','2025-12-13 12:31:05'),
('9856bf1c-d81f-11f0-bdbb-58946b2ab360','Fiananrantsoa','Haute Matsiatra','2025-12-13 12:31:05'),
('9856c15b-d81f-11f0-bdbb-58946b2ab360','Toliara','Atsimo-Andrefana','2025-12-13 12:31:05'),
('9856c1d0-d81f-11f0-bdbb-58946b2ab360','Toamasina','Atsinanana','2025-12-13 12:31:05');
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('2c9201cf-de9d-11f0-91ae-58946b2ab360','der@gmail.com','$2a$10$ylch/ulPkSVuPIe92Bv8DegAyd6cHQh03Ej2CyWHa2NuLx7U5SfBq','2025-12-21 19:39:02'),
('83d115b2-d82f-11f0-bdbb-58946b2ab360','loic@gmail.com','$2a$10$S.Wd5mVgndRNC92txEIBy.Nr8JR3YQTISdke8.oIhZXnxBwwgWgIu','2025-12-13 14:25:03'),
('89b5f95a-de6e-11f0-b690-92eff7073b14','deriaz@gmail.com','$2a$10$NBf3dby0yYFX8T5STaa3DOrcAJsurjpJFRiM4CvA0cIWrEgcI.6Gy','2025-12-21 13:11:18'),
('92799600-de64-11f0-b690-92eff7073b14','deriazalvin@gmail.com','$2a$10$8P6kPz9bf9pcJOYfV3BZxuikzJ32Lddc9VihpEYe110fNvErdSBzW','2025-12-21 11:59:58'),
('df39bdc8-d8d7-11f0-ae70-c465ab2ee0dd','heritiana@gmail.com','$2a$10$y8IvZKVEXSxRYqh.p6ebPu3tfK.5WXnH80DNxCY4/Tim.1Si2I6IS','2025-12-15 10:36:12'),
('fa83153e-df56-11f0-8183-8d0c92bbf187','kevin@gmail.com','$2a$10$/XTy7NLYaweLP74Mkt..pumuHZm7LGY0IWX8u9bhqPHUOtOQagXW6','2025-12-22 16:55:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weather_alerts`
--

DROP TABLE IF EXISTS `weather_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather_alerts` (
  `id` char(36) NOT NULL,
  `location_id` char(36) NOT NULL,
  `alert_type` varchar(50) NOT NULL,
  `severity` varchar(20) NOT NULL,
  `title_mg` varchar(255) NOT NULL,
  `message_mg` text NOT NULL,
  `recommendation_mg` text DEFAULT NULL,
  `alert_time` datetime NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_alert_dedup` (`location_id`,`alert_time`,`alert_type`,`title_mg`),
  KEY `idx_weather_alerts_location_time` (`location_id`,`alert_time`),
  KEY `idx_weather_alerts_severity` (`severity`),
  CONSTRAINT `fk_weather_alerts_location` FOREIGN KEY (`location_id`) REFERENCES `weather_locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather_alerts`
--

LOCK TABLES `weather_alerts` WRITE;
/*!40000 ALTER TABLE `weather_alerts` DISABLE KEYS */;
INSERT INTO `weather_alerts` VALUES
('22c13dd8-e67e-11f0-b2a4-d099900463e5','bdc3f461-4a54-4670-8966-39bb092a9ec8','wind','info','Rivotra antonony','Rivotra mety hampihena hamandoana, tandremo ny voly mora maina.','Araho maso ny fanondrahana.','2026-01-06 23:00:00',1,'2025-12-31 19:23:07'),
('63a649ee-e69a-11f0-8c64-1add06848615','bdc3f461-4a54-4670-8966-39bb092a9ec8','work','info','Rahona mavesatra','Rahona mavesatra mety hitarika orana any aoriana.','Hamarino ny fitaovana sy ny fitehirizana.','2026-01-06 23:00:00',1,'2025-12-31 22:50:59');
/*!40000 ALTER TABLE `weather_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weather_daily`
--

DROP TABLE IF EXISTS `weather_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather_daily` (
  `id` char(36) NOT NULL,
  `location_id` char(36) NOT NULL,
  `forecast_date` date NOT NULL,
  `temp_min` int(11) NOT NULL,
  `temp_max` int(11) NOT NULL,
  `weather_code` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_day` (`location_id`,`forecast_date`),
  CONSTRAINT `weather_daily_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `weather_locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather_daily`
--

LOCK TABLES `weather_daily` WRITE;
/*!40000 ALTER TABLE `weather_daily` DISABLE KEYS */;
INSERT INTO `weather_daily` VALUES
('0504e1b1-1390-4d7d-86dc-c09404b2664e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02',18,27,80,'2025-12-31 01:25:58'),
('16d4ccc2-bb4d-4962-8096-b82cde3a9f27','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05',18,27,96,'2025-12-31 01:25:58'),
('193312ae-bd54-4c06-996b-5cef3506fd81','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03',20,32,2,'2025-12-31 03:17:22'),
('19a35e67-ab0d-4025-98ab-a380d111308f','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01',20,33,1,'2025-12-31 03:17:22'),
('2ffd0be3-9de9-4af7-9ed5-f6bc83d176a9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02',22,32,2,'2025-12-31 03:17:22'),
('343dcbe3-bf77-4bb4-9812-829f75107ac3','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01',16,23,80,'2025-12-31 03:34:30'),
('3575ebb0-7913-4ad7-be2c-8945c91e3c5c','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03',18,27,45,'2025-12-31 01:25:58'),
('3f9fb05f-84a9-475d-a93c-0b08fdace58a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06',17,27,80,'2025-12-31 03:34:30'),
('46731d94-2755-4318-b3fe-4547cbecc9fa','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05',15,25,95,'2025-12-31 03:42:56'),
('4da96f40-1a17-4149-b9c8-5b04fb90b5eb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06',24,33,3,'2025-12-31 03:17:22'),
('4fc5f3d3-d550-497d-823c-0c0b6ec18138','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05',15,24,95,'2025-12-31 03:34:30'),
('5505989a-17fd-48e5-9ae6-abf6e5dfa7c1','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04',18,28,96,'2025-12-31 01:25:58'),
('578d8730-5000-4c71-a33f-bf8ab97baa83','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03',15,24,80,'2025-12-31 03:42:56'),
('60b8c2b6-2e61-46f6-b56e-97507b75126d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04',21,33,96,'2025-12-31 03:17:22'),
('63364257-4ca3-42f2-9296-12f62f2de9c5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31',12,24,80,'2025-12-31 03:42:56'),
('7c4bcf31-7906-4785-bfa7-456935a49db0','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01',15,23,95,'2025-12-31 03:42:56'),
('86e8296a-7809-40cd-b0f9-082941ba2897','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04',15,24,96,'2025-12-31 03:42:56'),
('95859a22-c261-4405-99dc-26674f3161c8','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31',18,28,96,'2025-12-31 01:25:57'),
('9ad61fc9-6ada-4fab-898a-9e9b44cfac37','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01',18,27,96,'2025-12-31 01:25:57'),
('9e1d0e5a-f525-4a49-b1d8-e78253b39ce5','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02',16,24,80,'2025-12-31 03:34:30'),
('b255ecf2-f200-4b00-81c3-b13ec9274bff','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31',20,32,1,'2025-12-31 03:17:22'),
('c05826b2-d7bf-4834-94b8-f51549e53940','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05',22,36,45,'2025-12-31 03:17:22'),
('c3c210dc-df12-4522-9b3c-8f29b6b62878','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04',15,24,95,'2025-12-31 03:34:30'),
('c8c148c3-516e-448a-b7fb-5599bc0bf8f5','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03',16,24,95,'2025-12-31 03:34:30'),
('f26ee456-6801-4df8-bee2-c84ce4a00ce6','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06',19,28,80,'2025-12-31 01:25:58'),
('f2cd0dc2-0f51-4a80-b012-69949be1b2bb','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02',14,24,45,'2025-12-31 03:42:56'),
('f5e5f66d-fe69-4727-803d-a7ba164632b7','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31',13,24,80,'2025-12-31 03:34:30'),
('fa2a83a1-f9eb-4327-ae59-8c9469c7b58c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06',17,26,3,'2025-12-31 03:42:56');
/*!40000 ALTER TABLE `weather_daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weather_hourly`
--

DROP TABLE IF EXISTS `weather_hourly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather_hourly` (
  `id` char(36) NOT NULL,
  `location_id` char(36) NOT NULL,
  `forecast_time` datetime NOT NULL,
  `temperature` int(11) NOT NULL,
  `humidity` int(11) DEFAULT NULL,
  `wind_speed` int(11) DEFAULT NULL,
  `weather_code` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_hour` (`location_id`,`forecast_time`),
  CONSTRAINT `weather_hourly_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `weather_locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather_hourly`
--

LOCK TABLES `weather_hourly` WRITE;
/*!40000 ALTER TABLE `weather_hourly` DISABLE KEYS */;
INSERT INTO `weather_hourly` VALUES
('003b2578-3b0c-41b4-af1c-c8a538e91110','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 23:00:00',20,92,5,3,'2025-12-31 01:25:53'),
('00aac480-84b5-4660-9ca6-7c2d7078c6f0','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 16:00:00',25,74,8,95,'2025-12-31 01:25:56'),
('01299af4-5dc9-48b8-a147-cf935bc28157','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 08:00:00',19,76,8,2,'2025-12-31 03:42:50'),
('023c365b-3d76-4bef-9896-0196212c5558','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 03:00:00',16,94,2,2,'2025-12-31 03:42:48'),
('02906e45-0ec6-4916-819f-1ee57467594e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 05:00:00',18,98,1,45,'2025-12-31 01:25:54'),
('035336ba-2325-4d61-b663-8e5b870ea245','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 22:00:00',20,92,7,3,'2025-12-31 01:25:53'),
('037bae50-c88e-4d76-85b5-725837d2af96','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 19:00:00',19,86,11,80,'2025-12-31 03:34:21'),
('041653ba-0d80-4196-9711-38a48a8aecb1','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 13:00:00',24,62,6,61,'2025-12-31 03:42:54'),
('0492d73e-21e5-4491-82ea-4248f4a399cd','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 13:00:00',31,40,20,0,'2025-12-31 03:17:12'),
('051f2633-c4ff-47e4-bd79-aead1aeffe11','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 22:00:00',17,92,3,61,'2025-12-31 03:42:49'),
('0545140e-f62f-4ac1-bd7c-5d5009659fb3','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 07:00:00',17,86,4,3,'2025-12-31 03:42:54'),
('054ee95d-ef6b-490a-92b3-35a5431b70ac','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 03:00:00',15,97,4,45,'2025-12-31 03:42:52'),
('056e5f3a-e11b-48cd-b6cb-4d13e52b0be9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 09:00:00',30,58,13,0,'2025-12-31 03:17:18'),
('05cb2836-f4d2-4508-921b-1ac57582ebdf','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 05:00:00',15,100,3,45,'2025-12-31 03:42:51'),
('05d6297b-3578-4676-8a95-ea01ed2cd91c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 19:00:00',18,86,7,3,'2025-12-31 03:42:49'),
('06d9ba24-3d69-4621-86c5-3b0db9095cf8','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 04:00:00',18,92,6,2,'2025-12-31 03:34:29'),
('07380446-3675-4f85-990e-a7c6bcc5a43d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 08:00:00',20,75,4,3,'2025-12-31 03:42:54'),
('078c7a3f-b064-4b62-a973-f01177aebc54','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 02:00:00',22,94,5,2,'2025-12-31 03:17:18'),
('07c7dbb7-6901-4efc-acb6-2370687eb98e','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 18:00:00',20,83,16,80,'2025-12-31 03:34:24'),
('088dc151-cc82-4bbb-b84b-07b2ce840c8b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 06:00:00',16,94,2,2,'2025-12-31 03:42:49'),
('099fb587-44f1-4dbc-82c7-7b29dc6ebbee','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 12:00:00',26,51,17,3,'2025-12-31 03:34:29'),
('0a09a649-898e-4c42-8dbc-f95c4827e4e2','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 19:00:00',19,84,8,3,'2025-12-31 03:42:51'),
('0a985695-ce13-40f3-87ec-0ad27abceb6f','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 02:00:00',16,98,4,45,'2025-12-31 03:42:51'),
('0aacfc33-0bc8-446b-829d-019fd3187f79','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 07:00:00',23,83,6,1,'2025-12-31 03:17:17'),
('0ac364ed-53d4-4617-80ad-18fc229eac4d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 08:00:00',21,77,9,3,'2025-12-31 03:34:29'),
('0ae0af43-680e-441b-8a1a-36642dfa4014','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 21:00:00',25,51,21,1,'2025-12-31 03:17:13'),
('0b08b793-1025-4e3d-87a1-d0506bfd8acd','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 11:00:00',24,59,10,3,'2025-12-31 03:42:52'),
('0b646d17-de65-40cb-ae3d-d6ff8da82b4d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 21:00:00',18,91,3,3,'2025-12-31 03:42:52'),
('0c0d6561-ead1-4d0f-aa33-9ea289d84e06','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 07:00:00',20,87,7,2,'2025-12-31 01:25:57'),
('0c2a40eb-f36a-41f0-a61a-32e6e050e1a9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 22:00:00',27,92,2,3,'2025-12-31 03:17:22'),
('0c3f078a-c489-49a8-b1e3-1de2a06f3e1e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 12:00:00',30,44,20,0,'2025-12-31 03:17:12'),
('0c62b055-deee-4bd8-8df1-b7ace094fd94','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 01:00:00',18,93,4,3,'2025-12-31 01:25:49'),
('0ce94887-726c-42b6-9844-cf25c309a076','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 20:00:00',25,73,11,2,'2025-12-31 03:17:16'),
('0d4a63a3-c91d-4690-a38e-6cea5dd51eeb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 07:00:00',25,80,7,0,'2025-12-31 03:17:18'),
('0d5d5ac6-8cd3-4c43-adef-56be57632e84','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 15:00:00',28,56,11,3,'2025-12-31 01:25:54'),
('0d7e9386-7c77-4324-98d1-f6c6d4dad92a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 08:00:00',26,69,6,1,'2025-12-31 03:17:17'),
('0d86659d-d811-440b-a9d2-0d8f0907b2ac','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 17:00:00',23,74,9,95,'2025-12-31 01:25:49'),
('0ee60590-12d4-42a3-afa7-3e1dc1fded14','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 14:00:00',28,45,14,3,'2025-12-31 01:25:57'),
('0f750b71-d492-48c1-bc7d-0c0d619f882c','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 00:00:00',26,81,4,2,'2025-12-31 03:17:20'),
('0fd58dcd-2ad4-4915-b15b-d87b20f85013','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 13:00:00',27,56,14,2,'2025-12-31 01:25:50'),
('1009a356-b2b9-4493-986f-71368f070779','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 12:00:00',27,56,10,3,'2025-12-31 01:25:54'),
('10364b74-0442-47da-bd25-e5381ef3c238','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 09:00:00',31,60,5,3,'2025-12-31 03:17:20'),
('1148ffa0-f316-4a0a-a3a0-691bfd426370','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 12:00:00',23,65,18,2,'2025-12-31 03:34:24'),
('1165cb22-3323-4bd1-883a-6fd0936b27cd','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 14:00:00',31,47,25,2,'2025-12-31 03:17:15'),
('11f476f8-7bec-49f2-9092-baaeb7bc2495','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 15:00:00',22,82,8,61,'2025-12-31 03:34:28'),
('1292009c-cd83-4fab-a72c-1b656a339975','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 16:00:00',22,69,18,95,'2025-12-31 03:34:25'),
('131fc950-2828-45fa-910d-6939b1a5df37','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 11:00:00',32,59,9,3,'2025-12-31 03:17:21'),
('13489578-c004-4242-a0b5-7b7e731c9551','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 22:00:00',18,87,5,3,'2025-12-31 03:42:53'),
('1396b6eb-1af2-41d5-951d-ffaf1aef96e4','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 20:00:00',21,85,5,95,'2025-12-31 01:25:49'),
('13fd9c65-7a05-4ed1-8c9e-262e8b917643','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 18:00:00',20,80,10,95,'2025-12-31 03:34:25'),
('13fe9191-417c-481f-9d23-58be67a27d1c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 07:00:00',18,88,10,3,'2025-12-31 03:42:55'),
('147784e7-ad05-4912-bd7c-8463125dc7f8','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 04:00:00',18,95,3,2,'2025-12-31 01:25:48'),
('156ec4b8-d377-435d-9ef3-bf6bcf306ea0','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 10:00:00',24,68,10,2,'2025-12-31 01:25:51'),
('16178906-c670-4a51-89e4-d64f95287709','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 00:00:00',16,88,2,1,'2025-12-31 03:34:20'),
('16ebe010-b69e-478d-b165-dc86ef9dfbb9','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 18:00:00',23,74,15,3,'2025-12-31 01:25:53'),
('17980ed8-bc84-4c51-b97c-14919e6e138a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 00:00:00',17,95,2,3,'2025-12-31 03:34:26'),
('185eb9f9-6eff-48c1-85b0-63b8d14f5ac1','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 09:00:00',22,69,11,3,'2025-12-31 03:34:29'),
('189a6d39-8491-4199-b93d-ca2974591d55','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 17:00:00',21,79,19,3,'2025-12-31 03:34:24'),
('1a7087a1-7810-4491-8f91-3416f4326afa','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 12:00:00',33,45,12,1,'2025-12-31 03:17:13'),
('1a79960a-cd1c-49a0-b99c-0a70b0588224','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 09:00:00',21,65,6,2,'2025-12-31 03:42:51'),
('1a99012d-f091-4508-ab1c-7835e74592da','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 21:00:00',21,91,8,3,'2025-12-31 01:25:53'),
('1a9a4abd-c067-4356-b473-4a9044a3d4e8','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 15:00:00',32,46,19,1,'2025-12-31 03:17:14'),
('1da5647a-8a40-4d2e-893b-be181c9a78bb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 21:00:00',25,80,2,0,'2025-12-31 03:17:17'),
('1ee9cba1-66df-4838-a9e1-ace089f066c4','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 23:00:00',17,94,3,3,'2025-12-31 03:42:52'),
('1f0d101f-8c42-4d3a-ba06-a113b00eb933','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 23:00:00',23,80,6,1,'2025-12-31 03:17:15'),
('1f1a1bab-fa95-43b0-83c4-fe5ebb7dd436','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 17:00:00',24,65,19,3,'2025-12-31 01:25:51'),
('1f37955f-8d27-4f16-b0e7-cc0f394e4dac','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 10:00:00',24,59,3,3,'2025-12-31 03:42:54'),
('1f914874-207d-48b4-b3a8-bbecac139022','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 13:00:00',24,57,21,2,'2025-12-31 03:34:25'),
('2061d147-1e84-4a3b-8311-3719505d8005','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 23:00:00',24,91,3,1,'2025-12-31 03:17:19'),
('2122ac0f-4cfa-4c5c-bea8-9f8dadff26ba','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 14:00:00',25,61,17,3,'2025-12-31 01:25:50'),
('2145d5f3-f142-4e60-87f9-2eee38d5b965','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 17:00:00',21,78,12,80,'2025-12-31 03:42:53'),
('215fe3b4-a98c-4e0e-b348-26d63ea6051b','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 11:00:00',23,65,15,80,'2025-12-31 03:34:26'),
('21d03644-812f-49e9-93bd-3d090f1fe9b6','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 04:00:00',16,92,2,2,'2025-12-31 03:34:23'),
('21d3d3e7-d4af-4df9-80fb-aedb12d4dab1','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 11:00:00',25,54,2,3,'2025-12-31 03:42:54'),
('21efd83c-a7e1-4100-9f43-70c82d5512b8','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 14:00:00',22,74,6,61,'2025-12-31 03:42:54'),
('2292c4a8-0562-4c35-a288-b94fdd06f214','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 21:00:00',17,95,7,63,'2025-12-31 03:42:49'),
('233c15c9-3ad7-4067-b098-fe4628d5a0cb','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 06:00:00',16,91,2,3,'2025-12-31 03:34:27'),
('23402d9f-cf12-4ebe-997b-806a1a01bd87','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 14:00:00',24,58,21,2,'2025-12-31 03:42:50'),
('23afb6db-22a9-48b1-8b8a-dd2c97e0f09f','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 22:00:00',24,85,3,2,'2025-12-31 03:17:18'),
('245b2cb5-c64e-4393-b578-60b436df84d4','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 08:00:00',19,79,9,2,'2025-12-31 03:34:24'),
('24911c21-fe06-4e5c-8b70-3f6087fa1ce8','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 00:00:00',16,97,3,45,'2025-12-31 03:42:51'),
('24f67267-f363-49ea-8eb4-f4f1c7a6c6f8','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 22:00:00',28,75,1,2,'2025-12-31 03:17:20'),
('253635e0-a542-4b90-b55f-3d68cafac769','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 11:00:00',24,58,16,3,'2025-12-31 03:34:25'),
('2540bb4d-51e8-4b64-bd5a-b5591386d239','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 23:00:00',27,78,2,2,'2025-12-31 03:17:20'),
('254d5deb-e244-445e-aadf-a450ce34cdaf','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 03:00:00',16,94,1,2,'2025-12-31 03:34:23'),
('25591677-cd8f-4156-8fb1-196aea68422c','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 19:00:00',19,85,7,3,'2025-12-31 03:34:25'),
('25689a37-abb5-4931-84d0-409d0410b796','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 09:00:00',21,65,12,1,'2025-12-31 03:34:20'),
('25fc9ddc-0fba-49c8-8dae-8c306967f52d','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 22:00:00',21,92,6,61,'2025-12-31 01:25:55'),
('26e8dc93-c691-4121-8765-e7ed523ee0ca','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 06:00:00',15,97,4,45,'2025-12-31 03:42:51'),
('271b4317-8568-4828-a4f8-1f5b0b5664df','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 04:00:00',19,96,0,45,'2025-12-31 01:25:54'),
('27551e66-4002-4381-977e-2d9799883872','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 06:00:00',13,89,5,2,'2025-12-31 03:42:47'),
('276dfa6e-005a-452f-a57c-077c38bde675','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 09:00:00',20,69,12,3,'2025-12-31 03:42:50'),
('28451f65-d962-4f16-9ae1-aa5612d69989','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 01:00:00',17,94,1,3,'2025-12-31 03:34:23'),
('286a61ba-65d1-4647-a0e1-ded513df49b3','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 00:00:00',17,94,3,3,'2025-12-31 03:34:24'),
('2918ee1a-7d9a-42eb-9853-242e75bd577c','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 02:00:00',19,94,1,3,'2025-12-31 01:25:54'),
('292e6991-5de5-4bf1-a76f-4710187e0615','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 07:00:00',20,89,2,2,'2025-12-31 01:25:54'),
('294447ce-33ff-4670-ad29-eaf4f741f3e2','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 04:00:00',16,97,4,45,'2025-12-31 03:34:26'),
('296eadc2-91cc-4277-ab03-70aa53020935','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 15:00:00',21,84,6,61,'2025-12-31 03:42:54'),
('29701e25-1d78-4521-8da0-be755ea075f8','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 01:00:00',15,89,2,1,'2025-12-31 03:34:20'),
('2983d59d-e2eb-4f6f-a532-d12c7a38229f','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 14:00:00',24,62,23,2,'2025-12-31 03:34:24'),
('29c05f8b-53a7-43a7-a659-2a8fe3fa6e37','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 06:00:00',20,81,13,0,'2025-12-31 03:17:12'),
('2a770232-7dd2-4463-98e5-9584827a1dde','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 21:00:00',19,90,5,63,'2025-12-31 03:34:28'),
('2aae6b53-1b19-4f05-b621-5965bbf3376e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 09:00:00',28,56,17,1,'2025-12-31 03:17:15'),
('2aec3921-f1cf-4532-8e75-abab8963a8f2','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 19:00:00',20,87,3,63,'2025-12-31 03:34:28'),
('2baf9937-5913-41da-a662-3ac72331435a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 00:00:00',23,92,5,2,'2025-12-31 03:17:18'),
('2c0f4122-aa0a-4cd0-ab20-39afa7805c52','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 03:00:00',18,91,6,3,'2025-12-31 03:34:29'),
('2c918561-c095-4e9e-9e5f-b3ce051bdb5c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 07:00:00',18,86,4,2,'2025-12-31 03:42:52'),
('2ca731e9-8206-4360-8978-4181b062096e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 21:00:00',25,68,5,0,'2025-12-31 03:17:14'),
('2cc6d779-2a13-4a0e-ba39-7797ebc99b14','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 05:00:00',20,82,14,0,'2025-12-31 03:17:12'),
('2d830590-1750-4991-9b1a-e43cfcaa8004','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 22:00:00',17,95,2,3,'2025-12-31 03:34:26'),
('2d982972-b01c-4dbf-a133-2be7864db00f','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 19:00:00',19,94,7,80,'2025-12-31 03:42:54'),
('2dc5b14d-8d62-4b9e-aba0-6c9123985186','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 09:00:00',21,72,15,3,'2025-12-31 03:42:55'),
('2de04327-6796-4ca8-a80f-18eabc7e8dd4','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 20:00:00',27,44,18,0,'2025-12-31 03:17:13'),
('2df0c5f2-44be-439d-912b-2b41b8dedf35','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 04:00:00',18,95,2,3,'2025-12-31 01:25:51'),
('2ee6bc88-fd1d-4623-bc9f-7d414b9b94ca','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 16:00:00',22,84,5,95,'2025-12-31 03:34:28'),
('2f29a43d-0cba-4163-9433-5dca2c247ee5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 22:00:00',18,91,10,3,'2025-12-31 03:42:54'),
('303ba51b-1033-477b-a3c5-b1627bde1f45','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 07:00:00',23,67,8,1,'2025-12-31 03:17:13'),
('31d250c6-21b4-41e3-8a67-eab67ff8633e','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 05:00:00',17,93,8,2,'2025-12-31 03:34:29'),
('3218998d-a0c0-4efd-ac28-9cb2b6280fe8','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 17:00:00',30,53,18,1,'2025-12-31 03:17:17'),
('33035847-5e13-4ef0-842d-90b903a7aaec','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 02:00:00',15,95,3,3,'2025-12-31 03:42:49'),
('333dcb02-7601-468e-9203-132fb5acc770','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 18:00:00',21,83,8,95,'2025-12-31 03:34:27'),
('3355eb6b-9f9a-4667-9d2e-58909667958d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 20:00:00',18,88,5,3,'2025-12-31 03:42:50'),
('3386f223-5810-4465-a894-ca0e9ba38c4c','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 04:00:00',22,97,4,45,'2025-12-31 03:17:19'),
('344dd67f-e6c7-4bca-80ad-3d29f4585bdc','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 19:00:00',20,86,6,80,'2025-12-31 03:42:53'),
('347e2e84-0707-4741-b883-c172c5195ae2','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 00:00:00',14,94,5,1,'2025-12-31 03:42:47'),
('34f2a8f0-558e-4920-b5e6-3d8b0fa28340','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 09:00:00',21,68,7,2,'2025-12-31 03:34:25'),
('358e1d90-9051-40c7-a96d-1caf0669304f','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 11:00:00',24,54,22,2,'2025-12-31 03:34:21'),
('35a1c10c-6eac-4400-96f9-08e99fc7bd28','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 19:00:00',20,87,5,95,'2025-12-31 03:34:27'),
('35f15dbe-85d2-4af3-9567-bb60f646e82b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 16:00:00',22,74,13,80,'2025-12-31 03:42:53'),
('3651630e-9920-4716-b3e3-b807431f2f2b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 11:00:00',26,59,10,2,'2025-12-31 01:25:51'),
('36d65cda-8669-403e-95b3-849acac32dba','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 16:00:00',32,35,21,1,'2025-12-31 03:17:12'),
('36fc8162-8d54-46be-b8f6-1742f9de46db','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 18:00:00',30,71,15,3,'2025-12-31 03:17:21'),
('37036bf8-5e50-4bfc-b27e-963b1959dc89','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 11:00:00',31,46,18,1,'2025-12-31 03:17:15'),
('3714aee6-aada-4956-b8ca-13de8bd0fe16','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 08:00:00',27,63,16,0,'2025-12-31 03:17:15'),
('37346b90-f909-427c-82e7-2c029c1e01a7','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 15:00:00',31,65,16,3,'2025-12-31 03:17:21'),
('377c09d9-cf47-42d6-b999-fe7414a24512','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 13:00:00',24,58,19,2,'2025-12-31 03:42:50'),
('37a8729b-e84e-46bc-87d3-a1755ffeb9c8','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 20:00:00',18,89,4,3,'2025-12-31 03:34:24'),
('381857a1-72cf-4a22-9fe2-1a32e488bfce','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 12:00:00',24,52,18,3,'2025-12-31 03:42:51'),
('38cd033c-9d68-4677-af30-81cb1ce4d455','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 01:00:00',16,97,3,45,'2025-12-31 03:42:51'),
('38f7e7e6-f17e-43d8-b4f5-1cdd640424f1','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 13:00:00',32,46,17,1,'2025-12-31 03:17:17'),
('39127d70-c41e-4381-89cd-dd5532864f49','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 02:00:00',18,91,6,3,'2025-12-31 03:34:29'),
('3942a447-7975-4c17-85aa-ddd68a026a71','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 16:00:00',25,50,20,3,'2025-12-31 03:42:55'),
('3942cf38-b66a-4eda-8485-35cadc9d242c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 03:00:00',13,94,6,1,'2025-12-31 03:42:47'),
('3ac91438-36ef-481a-9618-f81396cfa559','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 07:00:00',19,91,5,3,'2025-12-31 01:25:50'),
('3af7b273-c4ef-42d3-a89b-cf65c3c6415c','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 06:00:00',16,96,4,45,'2025-12-31 03:34:26'),
('3b335908-9caa-4605-bae5-48fe88864c67','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 12:00:00',32,46,15,2,'2025-12-31 03:17:17'),
('3bde2e19-12a7-4c72-a395-245b7f50a4b0','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 17:00:00',24,69,16,3,'2025-12-31 01:25:53'),
('3c42e16b-47f9-473e-a3f3-898482cdc4e1','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 20:00:00',20,87,8,3,'2025-12-31 01:25:50'),
('3c45c0a1-b35a-49f5-b937-443f6fee730f','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 03:00:00',20,93,3,3,'2025-12-31 01:25:56'),
('3d8b45a6-f723-4c8b-96e2-764544c2a993','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 03:00:00',19,95,0,3,'2025-12-31 01:25:52'),
('3e1221bd-2f8f-4e6a-8c42-fd5ffd9614ad','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 13:00:00',33,58,14,3,'2025-12-31 03:17:21'),
('3e319dd9-5525-4355-8d9f-83b1c7bc1605','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 05:00:00',18,96,2,45,'2025-12-31 01:25:51'),
('3f0b58b2-b4a6-4bf3-b379-d054ec31524a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 08:00:00',20,77,4,3,'2025-12-31 03:34:26'),
('3f8050df-65c3-4cb4-9acb-c0eddd1438b4','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 00:00:00',17,92,5,3,'2025-12-31 03:42:53'),
('400ef7b3-c171-4d2f-8b7d-6dcae41b3939','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 05:00:00',19,93,4,3,'2025-12-31 01:25:56'),
('40229ffe-e29b-4163-bec4-ef847ef0fb9d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 20:00:00',20,83,14,3,'2025-12-31 03:42:56'),
('40b51327-9f80-4205-8ed4-a9fe54704c18','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 01:00:00',17,92,0,2,'2025-12-31 03:34:22'),
('40d4793a-e405-4758-add8-2720432efecd','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 03:00:00',15,96,4,2,'2025-12-31 03:42:53'),
('411eb43a-053a-4f6f-a409-59325fae9bb6','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 23:00:00',18,87,2,3,'2025-12-31 03:34:27'),
('417987fb-5c91-4dec-bfd5-6390d6e93ca4','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 02:00:00',19,96,1,45,'2025-12-31 01:25:55'),
('41a57e17-ee16-46f7-93f9-ab1dbd762dcd','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 12:00:00',27,57,10,3,'2025-12-31 01:25:55'),
('41a5e661-0b08-4cbc-a181-3b73d2b1d58a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 09:00:00',20,74,15,3,'2025-12-31 03:34:22'),
('4239302d-f98f-423a-8054-8eec0e70cb27','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 20:00:00',18,88,5,3,'2025-12-31 03:42:52'),
('423c768f-79d0-4df9-afcb-e2166e43d4da','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 23:00:00',18,92,9,3,'2025-12-31 03:42:54'),
('42bf2295-ed6d-43be-8069-0ae231810dcc','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 00:00:00',19,92,8,80,'2025-12-31 01:25:49'),
('42d580b5-6362-4b86-9998-1ff006f76dbe','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 11:00:00',32,45,8,1,'2025-12-31 03:17:13'),
('4316c2f8-b8b4-4571-a0b0-93523aaba477','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 18:00:00',22,65,20,3,'2025-12-31 03:42:55'),
('43a07608-ab05-425b-86c9-89b3a5a577d1','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 18:00:00',21,93,12,95,'2025-12-31 01:25:56'),
('44e968d1-3ef4-4700-97f4-d1994ece2695','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 15:00:00',27,52,18,3,'2025-12-31 01:25:49'),
('45f7d508-7394-416e-963e-d6388ec592ec','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 09:00:00',22,66,5,3,'2025-12-31 03:42:54'),
('460414a1-f4de-46e0-808c-1b6c8c74e5db','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 10:00:00',25,65,8,3,'2025-12-31 01:25:54'),
('4617a17b-bda9-41ac-b71a-54912a251f13','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 00:00:00',20,92,3,3,'2025-12-31 01:25:53'),
('4642c668-1cea-4f56-aa19-bd1c51cad620','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 23:00:00',18,92,12,3,'2025-12-31 03:42:56'),
('464d68d7-eecf-4c32-bf67-045378291261','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 16:00:00',31,51,20,1,'2025-12-31 03:17:17'),
('46afa4d2-a67b-4a1f-8182-bcc543964850','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 22:00:00',24,52,24,0,'2025-12-31 03:17:13'),
('474a5e30-e39e-41b6-8e87-d7285e7763c1','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 16:00:00',27,53,15,2,'2025-12-31 01:25:57'),
('477b9a20-106b-4c8d-a184-8d7e4944a97c','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 05:00:00',15,98,5,45,'2025-12-31 03:34:26'),
('47a3fb7e-839a-494f-a520-6ed551923415','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 10:00:00',22,62,16,2,'2025-12-31 03:42:49'),
('47a8fb07-66f9-45bc-8d3d-5f74828aa288','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 18:00:00',24,57,17,3,'2025-12-31 03:34:30'),
('48540aeb-238e-4d48-b9e1-c4d57fcf8c49','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 20:00:00',22,85,8,95,'2025-12-31 01:25:55'),
('488c8cd5-f6d6-49b3-b7cd-76f973eff650','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 00:00:00',17,93,2,3,'2025-12-31 03:34:21'),
('494c9fec-860d-4a5b-b001-c66826447d90','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 19:00:00',22,80,17,3,'2025-12-31 01:25:57'),
('49523824-9c78-4c4f-919b-9573e732b255','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 10:00:00',23,58,20,1,'2025-12-31 03:34:20'),
('49c3b108-49c3-4ac9-8879-214b53257b43','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 11:00:00',22,62,15,2,'2025-12-31 03:42:50'),
('4a3e7e63-eeab-459c-a8a5-993100104661','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 21:00:00',19,94,3,95,'2025-12-31 03:34:27'),
('4ac13492-0ecf-402b-a104-fe6d7e3c83f2','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 22:00:00',17,93,2,3,'2025-12-31 03:42:52'),
('4ad127f2-24b7-4c4b-9f5b-2ee1b5e592c0','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 07:00:00',19,88,9,2,'2025-12-31 01:25:48'),
('4b6b4e22-650e-4270-94f6-7c60f858643a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 16:00:00',34,43,24,3,'2025-12-31 03:17:20'),
('4ba8ce2e-39be-4248-882e-a59e9ca04bf7','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 11:00:00',23,59,18,3,'2025-12-31 03:42:49'),
('4be3e821-bfb2-4eda-b346-1872e9e6c020','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 22:00:00',17,93,3,3,'2025-12-31 03:42:51'),
('4c456d21-b67c-47fa-a642-91c37e387c76','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 17:00:00',21,68,19,2,'2025-12-31 03:42:48'),
('4ccd76ef-4828-4597-8b40-be593eb490db','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 19:00:00',18,85,11,3,'2025-12-31 03:42:50'),
('4d117179-4357-4c0e-b977-87069cdbfcb6','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 06:00:00',19,98,1,45,'2025-12-31 01:25:55'),
('4d35f710-b4a7-41cf-9ed0-78b0d9d5e18d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 07:00:00',26,82,6,3,'2025-12-31 03:17:21'),
('4d63df27-a7c5-4a23-91aa-d6fb46ff8adb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 05:00:00',20,96,7,1,'2025-12-31 03:17:16'),
('4d742607-5d72-4f40-ac13-1731f65341ec','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 22:00:00',19,91,6,61,'2025-12-31 03:34:28'),
('4dee2f74-7fac-4a1a-a119-63f8c4bfabed','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 01:00:00',22,90,6,1,'2025-12-31 03:17:16'),
('4ebb91c3-d66b-4be8-8482-9c707650fe53','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 16:00:00',26,46,18,3,'2025-12-31 03:34:30'),
('4f1a00cc-1d6d-4b8f-94d8-637a8decc91a','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 23:00:00',17,94,2,3,'2025-12-31 03:34:21'),
('4f1c0277-f841-49c3-ad9d-51e4cb14e911','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 03:00:00',22,85,6,2,'2025-12-31 03:17:15'),
('4f2f664c-67a7-45b4-9e7d-8442f89c3277','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 15:00:00',31,50,20,1,'2025-12-31 03:17:17'),
('4faf2d69-2e50-4d03-b9ed-377d3655d672','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 18:00:00',19,80,9,3,'2025-12-31 03:42:49'),
('4fbe3be0-7ec5-4eee-a044-c64d7596cd40','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 15:00:00',23,64,21,2,'2025-12-31 03:34:25'),
('4ffbe1cf-fc62-4951-94c7-afcdc32e0f13','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 13:00:00',24,63,19,2,'2025-12-31 03:34:24'),
('506846ff-313a-4888-a2d3-3d1a9dcecec9','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 18:00:00',19,83,19,3,'2025-12-31 03:42:50'),
('50a92281-9c37-46f4-b1bd-db72a28b77d6','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 21:00:00',19,91,10,80,'2025-12-31 03:42:54'),
('50ff56fa-e1d2-47c0-9977-2c4b5d9c5465','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 11:00:00',25,62,8,3,'2025-12-31 01:25:53'),
('519c5a73-0c2e-481b-9bbc-145d15bd1c6e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 07:00:00',20,92,2,2,'2025-12-31 01:25:55'),
('51a08380-d853-4f54-acc5-4bd29e7d6319','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 10:00:00',23,72,14,3,'2025-12-31 01:25:50'),
('51ab01a7-ee2a-485a-a48a-97485455ec6c','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 18:00:00',30,36,22,1,'2025-12-31 03:17:12'),
('51dde463-40e0-401b-9b3f-9af12d2561e5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 06:00:00',16,95,5,3,'2025-12-31 03:42:52'),
('52057ff6-aaef-4c1f-95a5-0f0f6c2cf118','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 15:00:00',30,73,22,96,'2025-12-31 03:17:18'),
('522914d4-46d9-494a-a762-6bd9505c9d50','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 23:00:00',18,90,5,3,'2025-12-31 03:42:53'),
('52452eef-46e4-441b-b93a-6e13e771ed83','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 07:00:00',19,85,8,3,'2025-12-31 03:34:29'),
('526225da-59f1-44c9-aec7-cd14ff476a16','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 03:00:00',20,80,15,0,'2025-12-31 03:17:12'),
('526dc011-4943-465c-b7b8-ed93466fbc90','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 19:00:00',27,84,10,2,'2025-12-31 03:17:19'),
('52a67ef7-c067-4cc4-a7b8-22ae439c13af','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 12:00:00',25,54,4,3,'2025-12-31 03:42:54'),
('53618514-e1f5-4a23-8ff2-d16d3c6d85f2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 14:00:00',32,62,15,3,'2025-12-31 03:17:21'),
('539c98ce-1669-4834-8c1b-3e4d3c562ced','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 23:00:00',20,91,6,3,'2025-12-31 01:25:52'),
('55136c38-5c0c-47a8-8d04-b35f27269743','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 00:00:00',19,94,2,3,'2025-12-31 01:25:51'),
('5528f620-d11a-499b-a1c9-5fa790fad3d7','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 19:00:00',21,74,17,3,'2025-12-31 03:42:56'),
('55fc07c7-f36d-4992-86af-e93bf0bb5fee','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 14:00:00',24,53,24,3,'2025-12-31 03:34:21'),
('56765de9-bd41-4a08-b5a7-779e661ce61b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 23:00:00',20,94,5,61,'2025-12-31 01:25:55'),
('56b45c2c-87ae-49ec-a58d-54eb6f97c5b6','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 15:00:00',27,44,18,1,'2025-12-31 03:34:30'),
('56c4ac4d-1a20-4f4f-9009-f9cd5194d1fa','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 11:00:00',24,50,20,2,'2025-12-31 03:42:48'),
('56feeaa7-71d8-4f2a-bfe9-35f43258a7e2','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 00:00:00',18,92,8,3,'2025-12-31 03:42:55'),
('5755d8bf-110e-47f0-a5fe-d6740c272d9d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 20:00:00',18,90,4,3,'2025-12-31 03:34:25'),
('5841bbec-353e-4c9d-b3b8-fc7f58e897d3','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 08:00:00',22,80,4,2,'2025-12-31 01:25:54'),
('586a45d6-2bfd-4209-9be4-f388a4169a80','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 05:00:00',18,98,1,45,'2025-12-31 01:25:52'),
('591db4a8-428e-4bde-b778-3b6546f0aefd','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 15:00:00',26,65,8,80,'2025-12-31 01:25:56'),
('5932d71e-27e9-45f3-88bc-d70a917119f4','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 05:00:00',20,72,7,1,'2025-12-31 03:17:13'),
('599b27de-c807-4053-9c89-e776b2faaf51','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 19:00:00',22,66,13,80,'2025-12-31 03:34:30'),
('59cc76fd-743a-4219-a7c0-52f67dc3612a','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 15:00:00',24,55,23,2,'2025-12-31 03:34:21'),
('5a2aa185-08ea-462c-8b4d-26e3b56e46de','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 08:00:00',28,67,9,0,'2025-12-31 03:17:18'),
('5a30abef-f1f0-444c-9cc6-a880e923d532','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 13:00:00',27,57,10,80,'2025-12-31 01:25:55'),
('5a4503d6-ca1b-4f0e-bca8-6948cb4a52a6','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 00:00:00',16,93,2,2,'2025-12-31 03:42:49'),
('5a77a6a7-5983-47aa-871c-7094a4f20c9a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 09:00:00',25,64,24,1,'2025-12-31 03:17:12'),
('5a80528f-399c-4988-bd8d-7cd0c122b463','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 16:00:00',22,61,23,2,'2025-12-31 03:42:48'),
('5a9e4a71-7074-457d-aa8f-e880b7515aaa','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 08:00:00',28,75,6,3,'2025-12-31 03:17:21'),
('5b17e7cb-3888-40d0-84ad-809c82051268','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 12:00:00',36,39,12,3,'2025-12-31 03:17:20'),
('5b23d611-2ffd-4612-bbd6-336ccc1b54d7','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 11:00:00',23,63,19,3,'2025-12-31 03:34:22'),
('5b934791-f9cc-44fd-91b2-d1250f27bef4','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 13:00:00',24,53,25,3,'2025-12-31 03:34:21'),
('5c105bb8-4867-4b06-a76b-d694f376f166','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 22:00:00',25,88,1,1,'2025-12-31 03:17:19'),
('5d1ce953-283f-4424-9f3d-aabb07bc5fb1','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 17:00:00',25,64,18,2,'2025-12-31 01:25:57'),
('5d25e4de-4c90-492f-9f8e-b43dc524f329','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 12:00:00',27,53,17,3,'2025-12-31 01:25:57'),
('5d8d01e7-c895-4fa8-904e-ae7ec4043a91','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 05:00:00',18,94,4,2,'2025-12-31 01:25:48'),
('5dbd905e-2b4d-469c-8892-dbd703689afd','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 21:00:00',28,89,4,3,'2025-12-31 03:17:22'),
('5de05df4-c918-4d17-92bd-f367ba8d86eb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 19:00:00',29,77,12,3,'2025-12-31 03:17:21'),
('5e894613-874c-4235-8e16-0bf04eaacf0f','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 02:00:00',18,94,2,3,'2025-12-31 01:25:51'),
('5f874bec-13f3-4be4-9f88-3048bb14ad56','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 09:00:00',23,71,7,2,'2025-12-31 01:25:54'),
('60e310bf-28fb-46fe-a612-1345913186fe','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 10:00:00',24,64,10,3,'2025-12-31 01:25:48'),
('616333bf-3c53-4f06-8ab0-2989b0157af6','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 15:00:00',32,35,20,1,'2025-12-31 03:17:12'),
('61d4902b-a402-472f-834e-96ceec42259a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 03:00:00',17,96,3,45,'2025-12-31 03:34:25'),
('61de5bd3-34bc-40cd-9194-4ed258e3932d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 06:00:00',17,93,7,3,'2025-12-31 03:42:55'),
('62a5762e-b5ad-467b-8cb9-a77adc2a3ac9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 05:00:00',22,98,5,45,'2025-12-31 03:17:19'),
('62d3e427-8833-4184-b835-e12c19ffcbeb','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 05:00:00',17,95,7,3,'2025-12-31 03:42:55'),
('631e9a80-369f-460a-9885-684ba879d0de','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 14:00:00',23,66,14,96,'2025-12-31 03:42:53'),
('63406570-0858-4822-8c2f-cd529cb8c9ae','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 13:00:00',24,54,20,2,'2025-12-31 03:42:51'),
('6356d178-b9e6-4e34-9b97-3e38377c4f1d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 09:00:00',20,70,13,3,'2025-12-31 03:34:24'),
('636f4b38-ae22-46a8-8788-148e8c4e80fd','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 15:00:00',23,66,23,2,'2025-12-31 03:34:24'),
('6399aa5f-2a7e-4bde-83a2-2cc3543357c3','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 17:00:00',22,66,19,2,'2025-12-31 03:34:21'),
('63a1d6ac-a8bb-49f6-94e8-a19404fb1e86','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 19:00:00',28,55,13,0,'2025-12-31 03:17:14'),
('65440f01-c01b-4bb9-96d8-345b9d28e1cb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 14:00:00',32,37,20,0,'2025-12-31 03:17:12'),
('657f1fd7-8cc1-4a45-9012-87ea07b6d055','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 05:00:00',12,92,5,0,'2025-12-31 03:42:47'),
('6581e906-6afd-4ed7-9894-c07497b55a04','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 02:00:00',16,93,2,2,'2025-12-31 03:42:48'),
('65e38b02-1134-443c-9eec-4f5e07273494','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 18:00:00',28,58,23,1,'2025-12-31 03:17:16'),
('65f1bb55-9989-479d-a6f1-aaba3ffa25fe','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 23:00:00',17,93,3,3,'2025-12-31 03:34:24'),
('6634754a-3757-461d-b22e-d8128632f0ed','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 18:00:00',19,94,7,95,'2025-12-31 03:42:54'),
('6721bc83-1690-491c-bb06-a86968aa69f0','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 12:00:00',33,52,25,2,'2025-12-31 03:17:18'),
('673ee815-cfef-4840-8b1e-17db5e75b03a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 22:00:00',20,89,6,3,'2025-12-31 01:25:52'),
('67587980-2e8d-4206-a990-3d81f3f7bd1d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 03:00:00',23,96,4,45,'2025-12-31 03:17:19'),
('677520b4-8464-495b-8349-5ead48ba75fc','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 21:00:00',20,91,5,3,'2025-12-31 01:25:50'),
('67d1b44c-dd28-4d5f-af1f-ae994b75077e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 18:00:00',21,82,9,80,'2025-12-31 03:42:53'),
('67ea6d88-394c-4879-9e2e-4b9edc697e11','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 20:00:00',17,95,9,95,'2025-12-31 03:42:49'),
('67f57ce6-7d6a-43a3-830b-2a73d3406ee8','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 04:00:00',17,94,7,3,'2025-12-31 03:42:55'),
('67f612c9-f27b-4a8b-bbcc-2e93b40f0795','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 19:00:00',22,77,12,3,'2025-12-31 01:25:51'),
('6924d9ed-a2c7-413f-bbe3-ebe2355aee6c','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 02:00:00',14,92,3,1,'2025-12-31 03:34:20'),
('69b0343c-ee7a-42c0-8248-fd4415addcb0','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 08:00:00',20,80,12,3,'2025-12-31 03:42:55'),
('6a118d9f-f4aa-4f9e-8dbb-86e0e5b289f3','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 09:00:00',22,76,11,2,'2025-12-31 01:25:51'),
('6a883cb7-6018-47c1-8571-7516b4423f71','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 09:00:00',23,75,6,2,'2025-12-31 01:25:55'),
('6a92cdb1-869c-41e3-9f3f-47bfabb7afaf','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 01:00:00',22,85,6,1,'2025-12-31 03:17:15'),
('6b3cb1ed-5844-4b74-8edc-d91b6fde9a30','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 16:00:00',23,73,16,96,'2025-12-31 01:25:50'),
('6b99d39e-5d27-4e58-a75e-e868c0817c26','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 16:00:00',21,77,19,80,'2025-12-31 03:34:22'),
('6bb0ee9e-9443-4c9c-9ed6-5a8be96cdf3d','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 09:00:00',23,74,11,2,'2025-12-31 01:25:57'),
('6c19488f-8f5a-493d-8e71-18e126c3a6d7','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 16:00:00',21,73,20,3,'2025-12-31 03:42:49'),
('6c5710db-a1f5-4737-a518-94e59b3d738c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 15:00:00',23,64,20,2,'2025-12-31 03:42:51'),
('6c888b9c-30bb-43ce-a43c-253f97c7e776','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 05:00:00',15,94,2,2,'2025-12-31 03:42:48'),
('6d6b7387-e4c8-48a0-841b-b6b1411acac2','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 08:00:00',21,83,10,3,'2025-12-31 01:25:50'),
('6d934e94-1158-4518-9856-81bdc78b12a3','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 03:00:00',17,93,7,3,'2025-12-31 03:42:55'),
('6dcda567-65d7-4c47-a60c-f51b40358cd5','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 23:00:00',23,89,5,2,'2025-12-31 03:17:18'),
('6ded4fee-8f5e-44f1-be4f-8853fd7e3b41','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 03:00:00',19,96,0,45,'2025-12-31 01:25:55'),
('6fa7eac2-0902-4711-b9f3-e8eea4243669','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 17:00:00',23,76,13,95,'2025-12-31 01:25:50'),
('704c413c-cd97-4d23-a338-1c3cd8c73384','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 16:00:00',26,64,15,3,'2025-12-31 01:25:53'),
('70e298ba-004c-43b6-8e1b-05248d4a866e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 14:00:00',23,60,24,2,'2025-12-31 03:42:49'),
('70eeb6d3-cfec-4962-a849-c7116d3d8d55','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 07:00:00',25,85,6,3,'2025-12-31 03:17:20'),
('714c3edc-5358-4705-9203-d6193ecb96ac','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 17:00:00',20,83,14,80,'2025-12-31 03:34:22'),
('71ef0bf4-c823-46ac-ba66-0299191c79be','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 18:00:00',22,80,14,95,'2025-12-31 01:25:50'),
('7267a195-d7da-46db-a62a-7988416665ff','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 13:00:00',25,48,19,1,'2025-12-31 03:42:55'),
('730cedde-8d4e-491e-877d-e0942065fbf1','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 12:00:00',24,51,24,3,'2025-12-31 03:34:21'),
('738401ad-df4b-4c12-903f-83f764cfece6','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 19:00:00',22,80,12,3,'2025-12-31 01:25:53'),
('73e402c0-f0d5-477c-86c9-0c2a70d544aa','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 03:00:00',14,94,3,1,'2025-12-31 03:34:20'),
('7400a09a-3ff6-4e43-8c3b-cb388ca7f95f','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 01:00:00',18,92,6,3,'2025-12-31 03:34:29'),
('743447e0-3130-47ec-82fc-b0d91321c506','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 16:00:00',22,72,22,3,'2025-12-31 03:34:24'),
('746a85b4-51bd-4c19-a749-0231893218b4','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 04:00:00',20,71,7,1,'2025-12-31 03:17:13'),
('7516c7a3-66ea-4529-bc15-9eec5d00c4fa','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 16:00:00',22,68,22,2,'2025-12-31 03:42:50'),
('756ef476-ccef-4116-bb3f-ddcadf0efbb2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 07:00:00',25,71,8,2,'2025-12-31 03:17:15'),
('75dc529e-2ff8-4350-8b71-650919de3989','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 14:00:00',23,63,26,2,'2025-12-31 03:34:22'),
('763dde74-f10d-4989-9822-9b2aa61a6482','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 17:00:00',20,76,16,3,'2025-12-31 03:42:49'),
('76425efc-bb7d-47d1-8f4b-30bf09ac4222','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 04:00:00',15,95,2,2,'2025-12-31 03:42:48'),
('766cf8ac-0ef1-42f9-a4a8-8a88f67241d0','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 13:00:00',28,48,16,3,'2025-12-31 01:25:57'),
('76fd9482-6456-4678-99f1-191d643a50c0','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 03:00:00',16,96,3,45,'2025-12-31 03:34:26'),
('77196576-18d5-4bdf-9be2-4d391b194251','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 05:00:00',14,96,4,2,'2025-12-31 03:42:50'),
('77d39e0d-6e0d-41df-84b8-d2966d004562','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 13:00:00',33,44,15,1,'2025-12-31 03:17:14'),
('78bd8b69-cf10-4b38-8e99-4ff895a550a2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 23:00:00',23,84,4,2,'2025-12-31 03:17:16'),
('79ad830b-ffa1-4cb4-87e9-11920e2638f2','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 08:00:00',21,76,3,2,'2025-12-31 03:34:28'),
('7a0286fa-4768-4b61-ba44-0a3074b273ef','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 04:00:00',18,94,2,3,'2025-12-31 01:25:49'),
('7a27b401-642e-4363-8cc8-853a410a2e66','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 11:00:00',32,51,21,2,'2025-12-31 03:17:18'),
('7a329e70-d1bf-446b-bdec-2dca0cf1d55b','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 20:00:00',19,91,1,95,'2025-12-31 03:34:27'),
('7a8555bc-1e4c-4657-aa54-83ed86bce54c','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 22:00:00',17,93,2,3,'2025-12-31 03:34:21'),
('7ad08709-3300-4aa3-b59a-58f190967211','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 01:00:00',17,88,2,1,'2025-12-31 03:34:27'),
('7b3b9413-78b9-4408-b201-06d338b79e65','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 14:00:00',27,57,19,80,'2025-12-31 01:25:51'),
('7b50c827-928c-4f62-ac50-c1df1f1dd5f5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 16:00:00',22,69,18,80,'2025-12-31 03:42:51'),
('7b5431f3-f4f0-40f2-a602-79ea5df69bf7','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 23:00:00',20,91,8,95,'2025-12-31 01:25:49'),
('7b543e36-93c5-4102-a465-301d1f6ef4cc','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 13:00:00',24,71,14,61,'2025-12-31 03:34:28'),
('7c019a1b-5500-493d-94fa-800aa3ee2e40','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 11:00:00',24,58,18,3,'2025-12-31 03:42:55'),
('7c7c5631-a900-4aae-b23b-9d4d9b16c882','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 21:00:00',21,91,8,96,'2025-12-31 01:25:56'),
('7d037cf6-6e0f-40a0-83da-92f881dd64bc','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 23:00:00',17,91,0,3,'2025-12-31 03:42:48'),
('7dbf8523-6fa2-43a3-aee0-61ff578312d5','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 20:00:00',21,81,7,3,'2025-12-31 01:25:52'),
('7de77de4-95ab-4d40-a959-8e8f6010dbec','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 12:00:00',24,48,22,3,'2025-12-31 03:42:48'),
('7e118b96-22df-4406-8bc8-2cf6b3d0f5eb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 18:00:00',31,56,18,3,'2025-12-31 03:17:20'),
('7e188d2a-4fc8-4b0d-ae64-8ab04c7399f9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 06:00:00',21,93,7,1,'2025-12-31 03:17:16'),
('7e1dd3c4-d4e8-4938-bf58-ff7dd923cf01','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 14:00:00',36,37,21,2,'2025-12-31 03:17:20'),
('7e5e73ee-a9e8-4f53-be59-e724066d7651','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 21:00:00',21,88,7,95,'2025-12-31 01:25:55'),
('7ef6562a-4e0d-4fd9-95a1-d56b31a42119','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 22:00:00',20,91,8,3,'2025-12-31 01:25:57'),
('7f6053a5-bec2-4279-a8cd-0128354340d5','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 20:00:00',21,85,13,3,'2025-12-31 01:25:57'),
('7feb818b-b496-4194-b25d-a7e64116db0b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 18:00:00',20,80,11,80,'2025-12-31 03:42:51'),
('802380d4-a63a-445f-87e7-8648dabae790','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 00:00:00',24,93,4,1,'2025-12-31 03:17:19'),
('805dba5e-7dd8-471e-a198-484c83bd0989','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 10:00:00',23,55,17,2,'2025-12-31 03:42:47'),
('806d91b7-7398-4f70-a226-2aa1fd27a591','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 00:00:00',22,72,17,0,'2025-12-31 03:17:11'),
('80a0ad4b-dbc9-466c-ab7d-d4be635759dd','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 23:00:00',17,93,0,2,'2025-12-31 03:34:23'),
('80d016a0-c03d-4a8c-a318-2f551e5050cd','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 11:00:00',22,65,17,3,'2025-12-31 03:34:24'),
('80ea20d4-01e1-498d-986a-a36772beaa09','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 00:00:00',18,87,2,3,'2025-12-31 03:34:27'),
('8103173d-898c-48f0-9401-667537bc4b54','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 22:00:00',20,91,7,80,'2025-12-31 01:25:56'),
('81609daf-d20a-443d-8647-59d5cf57e998','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 22:00:00',19,93,5,3,'2025-12-31 01:25:50'),
('81697bf2-e1c7-405c-a9e2-c72d66271a8c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 21:00:00',19,93,2,80,'2025-12-31 03:42:53'),
('81784888-a383-4c0d-ad5a-72dd75819462','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 12:00:00',27,54,14,3,'2025-12-31 01:25:51'),
('82ec3437-3c8b-45e4-be0a-5c0562c013d6','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 12:00:00',33,57,12,3,'2025-12-31 03:17:21'),
('834fcdf2-131b-4e1c-8b97-fa0e170a2cce','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 13:00:00',27,47,18,1,'2025-12-31 03:34:30'),
('843dbabf-838d-44f5-88c5-a8c6f8e24320','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 10:00:00',24,66,4,95,'2025-12-31 03:34:28'),
('84a0efc9-6f00-453f-a6f6-0e206a6e6139','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 02:00:00',17,92,0,2,'2025-12-31 03:34:22'),
('84b3687f-7c1f-4937-98b9-52310e647006','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 18:00:00',20,75,14,80,'2025-12-31 03:34:21'),
('84fb8ab1-1fb7-4ba2-a3fc-be851919f7f7','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 07:00:00',17,90,5,2,'2025-12-31 03:34:23'),
('8554b242-fb20-48b3-8e3c-9c6ef9c2624b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 21:00:00',26,89,1,2,'2025-12-31 03:17:19'),
('8573c088-3d5c-46a8-b6a6-1e3cfe22506c','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 00:00:00',20,92,3,80,'2025-12-31 01:25:56'),
('85ffa522-4175-4330-8a51-19539091a7ac','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 02:00:00',21,65,9,0,'2025-12-31 03:17:13'),
('8611692a-f628-435a-8022-6950fd48d9a4','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 21:00:00',18,90,5,80,'2025-12-31 03:34:21'),
('86664421-ad69-4e78-8f13-37dfcd1ad17f','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 16:00:00',23,73,14,95,'2025-12-31 03:34:27'),
('867096b1-1208-452e-bb98-81f56f07db9d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 15:00:00',23,55,22,2,'2025-12-31 03:42:48'),
('868dffd5-b912-456e-8c4a-098ad10ad76e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 04:00:00',19,93,3,3,'2025-12-31 01:25:56'),
('8697c034-1262-431e-ba2b-28754aa952f4','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 06:00:00',16,98,2,45,'2025-12-31 03:34:25'),
('875b41eb-a428-4130-ba6c-d8f54ae027ad','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 14:00:00',28,47,18,2,'2025-12-31 01:25:49'),
('8766c49b-4089-4790-acaa-59299cd1095d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 17:00:00',31,36,22,1,'2025-12-31 03:17:12'),
('877de9d7-c773-4f6b-aca8-47f5ac4a3766','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 10:00:00',24,66,5,3,'2025-12-31 01:25:53'),
('878ba6fc-e3f9-4c64-9bc9-d2a327e8488f','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 10:00:00',30,49,16,1,'2025-12-31 03:17:15'),
('87c16c63-f647-47c3-b800-047a787419e5','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 06:00:00',18,97,2,45,'2025-12-31 01:25:52'),
('88398e02-c0f9-463d-8a4d-58680688a12b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 01:00:00',22,63,13,0,'2025-12-31 03:17:13'),
('8988f1c7-469c-42b3-b1b2-6eb1158be40e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 02:00:00',23,96,4,45,'2025-12-31 03:17:19'),
('89c8b642-4fde-442c-928f-59796132dfba','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 10:00:00',23,62,11,3,'2025-12-31 03:34:25'),
('89fb9ef6-6144-4ab7-8e25-3e17daf4e170','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 00:00:00',19,92,6,61,'2025-12-31 03:34:29'),
('8a3ad65c-e764-411f-9a40-b404650dc08f','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 20:00:00',27,87,4,2,'2025-12-31 03:17:19'),
('8a715468-edcb-4b07-ac81-6ee50bbdba90','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 01:00:00',26,84,5,3,'2025-12-31 03:17:21'),
('8afe4d6c-1065-4a20-9b4c-9ee1e0e481be','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 18:00:00',24,76,10,96,'2025-12-31 01:25:54'),
('8c1d982a-ed2f-4220-82c2-661ed168d136','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 10:00:00',24,62,13,3,'2025-12-31 03:34:29'),
('8c539b97-3745-48e2-a0d6-371c2742e8e2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 10:00:00',27,57,22,1,'2025-12-31 03:17:12'),
('8cacc2e2-09eb-4c96-9955-e072c187fc0c','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 06:00:00',16,93,2,2,'2025-12-31 03:34:23'),
('8cbeee73-7290-470c-95ef-c561f6f750a1','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 01:00:00',23,95,4,45,'2025-12-31 03:17:19'),
('8ec81084-87a3-411f-8f54-21e6cc6c33ad','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 06:00:00',14,95,5,2,'2025-12-31 03:42:50'),
('8ee3e5c6-2507-46d1-8473-6e09d276703d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 03:00:00',17,90,2,1,'2025-12-31 03:34:27'),
('904bc365-4610-4131-9476-f2eadf7e93c7','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 01:00:00',16,94,3,3,'2025-12-31 03:42:49'),
('906caea1-404f-4b5c-b47e-f32c640edb75','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 04:00:00',15,97,4,3,'2025-12-31 03:42:53'),
('90e2656c-3f7d-436c-8b1b-e62ef7ad705b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 08:00:00',23,73,23,0,'2025-12-31 03:17:12'),
('9185a149-f4c6-4d7b-b151-dc5a5977ea2e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 10:00:00',24,67,14,3,'2025-12-31 01:25:57'),
('92583220-3eaa-4e2f-9204-9621eff5c026','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 07:00:00',19,90,1,2,'2025-12-31 01:25:52'),
('92738b67-a4f7-47e8-a972-9df40c0c5c1b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 04:00:00',25,89,5,3,'2025-12-31 03:17:21'),
('92cdc1f1-86e5-46fd-8045-5209c9a27deb','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 16:00:00',29,77,20,95,'2025-12-31 03:17:18'),
('92e0cb1d-d6c2-4f22-acf8-696b4e450049','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 06:00:00',17,91,1,3,'2025-12-31 03:34:22'),
('93631634-624e-4b3f-a210-158154719009','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 17:00:00',25,51,18,3,'2025-12-31 03:34:30'),
('937cc961-16b4-40f8-99d3-41cb70590802','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 13:00:00',26,59,11,3,'2025-12-31 01:25:53'),
('95be7f6f-1946-438c-9c01-5f4d5b0736ea','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 07:00:00',18,88,2,3,'2025-12-31 03:34:26'),
('95dc92a1-1ceb-40ca-94bf-4b8dfc6c6dde','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 18:00:00',23,77,8,96,'2025-12-31 01:25:49'),
('9600b459-d92b-44d6-b732-1acb430a4ee0','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 17:00:00',21,75,14,80,'2025-12-31 03:42:51'),
('9609b16b-dc7d-4474-bafe-19868f1e9310','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 09:00:00',28,57,7,1,'2025-12-31 03:17:17'),
('97053dfd-08aa-406a-aaa9-4aae11aab9a8','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 23:00:00',27,93,2,3,'2025-12-31 03:17:22'),
('970ac183-c58c-4670-8bf8-6dc7fafb51eb','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 23:00:00',17,92,1,2,'2025-12-31 03:42:49'),
('97769835-7db4-4a98-b7bb-655d96ddffe5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 01:00:00',16,94,5,2,'2025-12-31 03:42:53'),
('9778b21a-d087-4462-9aa3-339f565df40c','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 13:00:00',23,63,25,2,'2025-12-31 03:34:22'),
('98c66f5d-3511-403b-a963-7aceaae46527','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 11:00:00',25,59,16,3,'2025-12-31 01:25:57'),
('990974a1-6738-45f6-aa73-7a4257efaa70','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 01:00:00',19,95,3,3,'2025-12-31 01:25:52'),
('99c0d234-9736-4dae-994f-8a54bcc4051e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 00:00:00',16,95,4,3,'2025-12-31 03:42:52'),
('9aa9d9f7-c0e3-4940-8973-1e03d5b02b96','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 23:00:00',23,58,24,0,'2025-12-31 03:17:13'),
('9abd8729-f04b-46b3-86cd-acd2578c04e0','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 05:00:00',24,90,5,3,'2025-12-31 03:17:21'),
('9b1cd3f2-03ff-4d64-9f24-ae99938779c0','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 17:00:00',29,79,18,95,'2025-12-31 03:17:18'),
('9bc3fd0c-a102-435b-ac2c-d0d2750a21b6','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 19:00:00',30,61,13,2,'2025-12-31 03:17:20'),
('9c7d9bc6-e722-4dbf-9621-01773f3305be','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 03:00:00',25,88,5,3,'2025-12-31 03:17:21'),
('9cf0de48-9dc1-47aa-ab39-51ccb3fd08aa','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 21:00:00',18,94,2,3,'2025-12-31 03:34:25'),
('9d04e276-854a-41bb-87b6-bc3611b760d9','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 05:00:00',18,99,0,45,'2025-12-31 01:25:55'),
('9d28b738-d728-47cb-a828-437be860da6a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 07:00:00',18,85,3,2,'2025-12-31 03:34:27'),
('9df18bf8-5cbc-473d-972f-11dfb699aa03','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 14:00:00',33,44,17,1,'2025-12-31 03:17:14'),
('9e6fb3de-743d-4c72-b21e-db25c45bc7d8','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 03:00:00',16,98,4,45,'2025-12-31 03:42:51'),
('9eef7fdb-cd7b-41ab-bcbe-1652231dbfe7','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 10:00:00',21,65,14,3,'2025-12-31 03:42:50'),
('9f0c1aae-7b52-4cf0-b362-ca9c55ef3b74','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 14:00:00',24,53,23,2,'2025-12-31 03:42:48'),
('9f76a66c-f66a-4684-8ba0-10a2ead5766c','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 13:00:00',23,60,23,2,'2025-12-31 03:42:49'),
('9fd54158-aa4b-4b87-b223-89373d6ca2f9','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 02:00:00',20,93,3,3,'2025-12-31 01:25:56'),
('a00a7fe6-32f0-410b-8844-f206ff8e9269','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 02:00:00',17,95,3,3,'2025-12-31 03:34:24'),
('a0f899e2-011f-4430-877e-f53879ddadfc','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 01:00:00',18,94,2,3,'2025-12-31 01:25:51'),
('a1b66a8a-4c7a-4894-9d75-01bc7a608876','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 08:00:00',21,83,4,2,'2025-12-31 01:25:55'),
('a2293574-5954-475c-ade3-ce272d6d0a2a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 06:00:00',21,71,8,1,'2025-12-31 03:17:13'),
('a232a69f-ced1-4766-bbac-0935a5b78726','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 07:00:00',17,90,1,2,'2025-12-31 03:34:25'),
('a27ba418-99f6-441f-8e7e-51f7fc83d5d9','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 05:00:00',16,100,1,45,'2025-12-31 03:34:25'),
('a28199e0-6090-43ef-a435-e1ebd33f2f03','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 21:00:00',21,87,4,95,'2025-12-31 01:25:49'),
('a3af5a02-ce9c-47ff-8d27-daf785e95e1d','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 05:00:00',13,95,5,1,'2025-12-31 03:34:20'),
('a3af8d2d-4231-4c11-98d9-b8f0901d1472','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 14:00:00',23,77,11,61,'2025-12-31 03:34:28'),
('a51e3612-8b45-400a-a7ac-ad6fe5fa7d58','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 04:00:00',22,84,7,1,'2025-12-31 03:17:15'),
('a595a292-34c0-4700-9fbe-73aa13d7fa1f','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 01:00:00',17,95,3,80,'2025-12-31 03:34:24'),
('a5a55595-08d1-47b9-93ac-534de636d9ca','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 21:00:00',18,91,2,3,'2025-12-31 03:34:24'),
('a5bce7db-803d-4f0f-8056-e9a47dba940f','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 20:00:00',19,92,8,80,'2025-12-31 03:42:54'),
('a626dd82-2a97-4044-a30d-8bb0a0f96f87','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 07:00:00',17,84,1,2,'2025-12-31 03:42:47'),
('a6438e5f-794c-46fb-a6b0-d8898b81c0a1','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 13:00:00',24,62,14,96,'2025-12-31 03:42:53'),
('a6ac4a7c-0daa-4253-b506-4f06a3ad609a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 01:00:00',17,95,3,45,'2025-12-31 03:34:26'),
('a6d4d4f4-d566-4a33-99a3-b2519b10855a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 12:00:00',26,60,10,3,'2025-12-31 01:25:53'),
('a6fc953f-eab8-421a-aa49-785d46d32e5d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 20:00:00',27,59,7,0,'2025-12-31 03:17:14'),
('a70c52f2-f7aa-469a-89bd-ffa16072de8e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 07:00:00',18,87,3,2,'2025-12-31 03:42:49'),
('a76964d7-f9d3-424a-83fa-d9c61980b611','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 18:00:00',20,76,15,80,'2025-12-31 03:42:48'),
('a7889ade-5e42-4ec8-b9a9-56b99d68ebfc','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 15:00:00',25,65,15,3,'2025-12-31 01:25:50'),
('a89288bf-fc10-42dd-8de1-06704a22beae','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 22:00:00',18,86,3,3,'2025-12-31 03:34:27'),
('a8c84a8a-4b77-4821-94e4-1f11653eea45','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 23:00:00',20,91,7,3,'2025-12-31 01:25:57'),
('a8e2cb64-a3bb-4d15-a6cc-a8f2b621cc49','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 22:00:00',19,87,7,3,'2025-12-31 03:34:30'),
('a92481b3-fd9d-4b99-8027-f1913d91ba58','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 17:00:00',24,57,20,3,'2025-12-31 03:42:55'),
('a9747f48-8068-4ffe-8539-f5bda1460e04','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 10:00:00',31,63,5,3,'2025-12-31 03:17:21'),
('a9be1761-871b-4f13-8f99-ca7d776a32fc','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 13:00:00',36,37,16,2,'2025-12-31 03:17:20'),
('a9f2e8f2-55d3-4797-ad65-680606869af4','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 14:00:00',32,48,19,1,'2025-12-31 03:17:17'),
('ab410486-57fa-4377-a939-5151f7076abe','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 11:00:00',24,54,15,3,'2025-12-31 03:42:51'),
('abd002a2-67ab-4504-90c9-6f09bac4e3bd','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 00:00:00',22,62,19,1,'2025-12-31 03:17:13'),
('ac6e9a6c-6dec-406c-b304-b2c211b287a3','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 12:00:00',23,60,17,2,'2025-12-31 03:42:50'),
('acc12ba1-66ba-4661-a714-fe08c7154c91','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 16:00:00',27,61,11,96,'2025-12-31 01:25:54'),
('ad0818f4-f49b-434f-a199-bf6b847755da','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 14:00:00',31,66,24,96,'2025-12-31 03:17:18'),
('adbe3a36-1e7a-4590-81e1-492f48b6bbf1','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 13:00:00',24,51,23,3,'2025-12-31 03:42:48'),
('ae0e1960-cd26-44d6-afe0-b656555eb897','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 14:00:00',27,59,12,3,'2025-12-31 01:25:53'),
('ae1cd69e-06a8-4cd9-8258-2306eb4ff851','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 15:00:00',26,46,20,1,'2025-12-31 03:42:55'),
('ae1dbe06-1098-4cfb-a7e8-c63c1cdeeb57','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 08:00:00',19,67,4,1,'2025-12-31 03:42:47'),
('ae2aec6c-9262-46ea-97cf-fd2164c647b5','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 07:00:00',20,90,4,2,'2025-12-31 01:25:51'),
('ae4b5444-5626-48ff-90f6-3081bdb1224d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 06:00:00',15,94,5,3,'2025-12-31 03:42:54'),
('ae61c112-7b04-484c-905e-964a62762b48','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 09:00:00',22,64,5,2,'2025-12-31 03:42:52'),
('af35b682-a838-4c8e-931f-41133f02895b','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 13:00:00',24,65,18,95,'2025-12-31 03:34:26'),
('afa48540-adeb-4177-a18f-80555164b670','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 02:00:00',18,94,2,3,'2025-12-31 01:25:49'),
('b04d409a-cd26-4001-a47e-5bc3c6429c7d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 21:00:00',18,91,3,80,'2025-12-31 03:34:23'),
('b0548378-3bf6-4268-965d-2c71a9120e6d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 15:00:00',24,69,16,95,'2025-12-31 03:34:27'),
('b0ac6528-8916-4d50-b20b-e983b0a0f531','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 00:00:00',19,93,4,3,'2025-12-31 01:25:52'),
('b1361b01-de2f-446b-8530-919036e1b49d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 12:00:00',32,45,21,2,'2025-12-31 03:17:15'),
('b19b811c-1ea4-48e4-8b47-d44ca5bc8334','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 08:00:00',20,80,8,2,'2025-12-31 01:25:48'),
('b1b17205-edef-4b92-ae2f-7e892a170aa2','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 15:00:00',26,61,13,3,'2025-12-31 01:25:53'),
('b1e98b3d-5e64-466d-a3dd-19fe3601e1aa','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 06:00:00',18,96,1,45,'2025-12-31 01:25:51'),
('b28faf44-70f6-4bbd-8045-6d8f67af89eb','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 06:00:00',19,91,5,3,'2025-12-31 01:25:56'),
('b2c503a0-dad3-4d67-95a4-d694a5336913','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 02:00:00',17,93,7,3,'2025-12-31 03:42:55'),
('b2c554b9-5720-45ef-896a-bb3fc90ecd01','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 02:00:00',21,78,16,0,'2025-12-31 03:17:12'),
('b2f5d992-efc5-4cd7-8d72-bc618918d459','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 03:00:00',15,95,4,2,'2025-12-31 03:42:50'),
('b35aa9fc-6568-480d-9a0c-8beb033acf63','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 12:00:00',23,58,20,2,'2025-12-31 03:42:49'),
('b3fbb86c-8d83-498d-b578-b994d18e8ab7','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 04:00:00',13,93,5,1,'2025-12-31 03:42:47'),
('b4c0bd81-6941-4beb-8ab5-09505f2eba33','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 19:00:00',18,92,7,80,'2025-12-31 03:34:23'),
('b586007a-8bf8-4958-9486-3275447d249f','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 07:00:00',17,90,3,2,'2025-12-31 03:34:20'),
('b5d92ec0-522b-4738-91a4-a52a0a6c6f9b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 12:00:00',26,55,14,1,'2025-12-31 01:25:48'),
('b668d8bf-b3a7-435e-a7b0-253dd1c43743','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 13:00:00',27,49,15,2,'2025-12-31 01:25:49'),
('b68296fa-2a70-4e23-8635-ba48414f839e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 19:00:00',22,81,6,96,'2025-12-31 01:25:49'),
('b87da304-e7da-4acc-aecf-a2a0dd8d2098','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 05:00:00',18,95,2,80,'2025-12-31 01:25:50'),
('b8a72912-e4c5-415b-9512-8a87f516ead0','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 14:00:00',27,60,9,80,'2025-12-31 01:25:55'),
('b8c7685a-c4ba-40d6-9eb0-1f6f55cda399','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 11:00:00',24,66,11,95,'2025-12-31 03:34:28'),
('b995cf2a-25e0-485a-b33d-a2bc88325287','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 20:00:00',18,86,10,3,'2025-12-31 03:42:48'),
('b9e62ab7-eb3e-4881-9584-6bccfe02d1bc','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 23:00:00',19,92,5,61,'2025-12-31 03:34:29'),
('ba13c0e0-76ea-4267-9a28-2ab6258b5a73','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 19:00:00',19,86,9,2,'2025-12-31 03:34:24'),
('ba570be5-adc1-4d4a-a8fe-4ad24af983c0','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 10:00:00',30,51,8,2,'2025-12-31 03:17:17'),
('ba5fe517-7750-49c0-a571-21329a4cc84a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 18:00:00',23,73,20,2,'2025-12-31 01:25:57'),
('bac6af8c-4581-4a38-8b8b-9b875c40e267','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 04:00:00',13,94,3,1,'2025-12-31 03:34:20'),
('bb37713c-6c79-4009-9cd7-32da8ce55b29','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 04:00:00',16,98,1,45,'2025-12-31 03:34:25'),
('bbcc835c-38d7-425c-a540-412469189694','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 10:00:00',23,66,12,80,'2025-12-31 03:34:26'),
('bc1a766c-19d2-4148-bcd8-60a601d6fc68','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 15:00:00',23,70,13,96,'2025-12-31 03:42:53'),
('bc48e7c6-dfe8-463d-b4a7-fb2800e0909b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 09:00:00',22,70,7,2,'2025-12-31 01:25:48'),
('bc9a4c8e-4dec-4798-bcc5-df80f5d81d4b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 10:00:00',33,51,4,3,'2025-12-31 03:17:20'),
('bcfd2220-91a2-4276-88b8-314324daabf1','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 17:00:00',21,84,4,95,'2025-12-31 03:34:28'),
('bdd241d5-6c52-450b-b0b0-e45a24977fda','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 19:00:00',27,63,11,0,'2025-12-31 03:17:17'),
('bdef70e7-2c19-40ce-8e2f-030e71963e57','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 00:00:00',23,87,5,1,'2025-12-31 03:17:16'),
('be5ed6f4-5bed-4d0d-ad57-6367d5710d53','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 08:00:00',19,78,3,2,'2025-12-31 03:34:25'),
('bf2832b0-f7fd-40ee-9e15-694f24bb75c9','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 06:00:00',13,95,5,2,'2025-12-31 03:34:20'),
('bf44164d-d6d3-44cc-9113-e9c91318d1b2','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 12:00:00',23,65,17,80,'2025-12-31 03:34:26'),
('bf90f7df-fd3e-4d47-8b71-626f70e3ca94','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 22:00:00',18,91,2,3,'2025-12-31 03:34:24'),
('bf9a6890-a351-4e78-8a73-515ad6dda266','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 08:00:00',20,73,4,2,'2025-12-31 03:42:52'),
('bf9e408e-8634-4377-8404-a58a820c8593','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 02:00:00',18,95,3,2,'2025-12-31 01:25:48'),
('c00aca64-272b-4fca-9155-4637577f91fd','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 07:00:00',17,87,4,1,'2025-12-31 03:42:50'),
('c011f897-8a7b-4a21-bf81-a7816543894e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 04:00:00',15,98,4,3,'2025-12-31 03:42:52'),
('c0838bbd-2c60-4a58-b5da-2ecc8ae6aed5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 01:00:00',13,95,6,1,'2025-12-31 03:42:47'),
('c0bf2182-d797-4810-bb41-40bf38e1fd5d','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 19:00:00',21,83,11,80,'2025-12-31 01:25:50'),
('c0c93762-b551-4ad9-aec1-025257e0dda1','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 15:00:00',31,51,26,1,'2025-12-31 03:17:15'),
('c1671918-fc31-4559-9e92-9f1865dac614','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 01:00:00',18,92,3,2,'2025-12-31 01:25:48'),
('c1ec01ce-d9c7-49ba-b062-40ff0bc9f259','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 08:00:00',19,73,4,1,'2025-12-31 03:34:20'),
('c2c7cb9c-88aa-4875-b42a-3169cb72a461','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 08:00:00',21,82,8,2,'2025-12-31 01:25:51'),
('c38a7c02-6c6b-4f30-b625-5598a8cc125e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 12:00:00',25,52,19,3,'2025-12-31 03:42:55'),
('c39a06bb-6f83-4252-8d1c-16f367676d81','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 12:00:00',23,64,21,2,'2025-12-31 03:34:22'),
('c44ada79-e433-4861-9672-4e1c3520483a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 18:00:00',29,55,18,0,'2025-12-31 03:17:14'),
('c4658e64-3dc6-4383-a2e4-4559fa4b78df','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 02:00:00',15,97,4,45,'2025-12-31 03:42:52'),
('c4670922-de1b-483c-8035-6e7ab61a03f8','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 14:00:00',27,44,18,1,'2025-12-31 03:34:30'),
('c4a53b85-4308-4707-8eee-a117bd994de1','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 20:00:00',18,89,8,80,'2025-12-31 03:34:21'),
('c4db8e74-d924-46ea-b23a-21700350b9e9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 06:00:00',22,89,6,3,'2025-12-31 03:17:18'),
('c5eb302b-8129-4f39-b5bf-a645ab0130ce','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 03:00:00',22,94,5,2,'2025-12-31 03:17:18'),
('c62ea491-ddc7-468c-b4be-c06605d4a7fa','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 00:00:00',18,89,3,3,'2025-12-31 01:25:48'),
('c67f4b55-1daf-4960-9294-a821e5b3468b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 02:00:00',13,95,6,1,'2025-12-31 03:42:47'),
('c7467381-ce11-484e-86f8-5480791dc2b2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 05:00:00',22,82,7,2,'2025-12-31 03:17:15'),
('c7be679d-927c-42ec-ba83-0badd31d1d2d','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 18:00:00',28,81,15,95,'2025-12-31 03:17:19'),
('c7cbff32-fe03-4c01-a487-1799296922fe','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 04:00:00',15,95,4,2,'2025-12-31 03:42:50'),
('c831d504-4774-40bd-ad93-fe3205d08d27','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 17:00:00',29,55,24,1,'2025-12-31 03:17:16'),
('c859d84e-559b-498c-8927-f36a787f280a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 03:00:00',18,95,2,3,'2025-12-31 01:25:51'),
('c887c3ca-ec51-4039-bcd4-d274c6580268','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 12:00:00',24,60,13,3,'2025-12-31 03:42:52'),
('c8f2a036-fe16-49ff-a46c-5a419e8f6d70','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 04:00:00',19,98,0,45,'2025-12-31 01:25:55'),
('c9d2825c-0163-46e5-8af3-0feaec870097','51387727-9b3b-485d-9869-6e474d2656e7','2025-12-31 16:00:00',23,58,23,2,'2025-12-31 03:34:21'),
('ca08b7c2-f8af-489f-a85b-e61ce5e35832','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 22:00:00',20,89,5,95,'2025-12-31 01:25:49'),
('ca53ae74-7c5e-4fb1-9885-517601b485aa','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 16:00:00',30,51,26,0,'2025-12-31 03:17:16'),
('ca8c3927-17f7-4af3-b02a-e60d4cfb35b9','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 01:00:00',19,93,2,3,'2025-12-31 01:25:53'),
('ca96fea5-757e-4015-8743-a3e8808e749b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 00:00:00',20,95,3,61,'2025-12-31 01:25:55'),
('cac7a8c8-ee37-404f-a4db-e2d589d99409','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 03:00:00',19,95,0,3,'2025-12-31 01:25:54'),
('cba6cf55-5790-4f27-b471-34650af50325','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 14:00:00',24,67,17,95,'2025-12-31 03:34:26'),
('cc4a6e32-cd36-442c-8437-229593855bfe','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 20:00:00',26,72,6,0,'2025-12-31 03:17:17'),
('ccae28b0-d4ef-4657-b9c3-610227b3da99','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 10:00:00',22,67,15,3,'2025-12-31 03:34:24'),
('cce66518-9013-4d53-9ad5-b891e0b65b5f','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 23:00:00',19,94,2,80,'2025-12-31 01:25:50'),
('ccf18c4c-8a11-4dc4-bdf1-59ab9e6128f8','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 11:00:00',26,61,9,3,'2025-12-31 01:25:55'),
('cde71b11-e8bc-41db-ae69-9bb37fb20ca5','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 10:00:00',30,51,5,0,'2025-12-31 03:17:13'),
('ceb998c8-6d66-45e6-9079-69c1177bea2f','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 17:00:00',32,50,21,3,'2025-12-31 03:17:20'),
('cef4ad0d-8819-481e-b13f-0cef167b031b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 03:00:00',21,68,8,1,'2025-12-31 03:17:13'),
('cf1a064f-71a0-4471-b671-ea7965a90278','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 14:00:00',24,59,21,2,'2025-12-31 03:42:51'),
('cf7dfb1d-3d74-4dfd-8dc8-4d37f8f2e573','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 10:00:00',23,60,7,3,'2025-12-31 03:42:52'),
('cf88f5b9-b1ed-4820-9fa9-80a7e3d012eb','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 07:00:00',18,89,4,2,'2025-12-31 03:34:22'),
('d096968f-9213-4d00-bc58-6e78ea23832a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 03:00:00',18,95,1,3,'2025-12-31 01:25:49'),
('d20bbe7c-e735-41dd-b226-b0679c4b29a3','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 09:00:00',23,71,3,2,'2025-12-31 01:25:53'),
('d28d4a0f-a9fc-41e0-9969-7d632c69c1ca','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 11:00:00',24,69,13,2,'2025-12-31 01:25:50'),
('d2ff9395-7959-48d2-a96d-076f66f67ed5','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 01:00:00',17,91,1,3,'2025-12-31 03:42:48'),
('d3878d50-3393-445f-9f02-8b4be3d4ef1e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 04:00:00',21,94,6,1,'2025-12-31 03:17:16'),
('d3abdb05-b8d0-4d07-b0e7-03d0519642e4','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 08:00:00',19,75,3,2,'2025-12-31 03:42:51'),
('d3fa7b67-032a-4772-9559-2d51802c6419','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 20:00:00',18,93,8,80,'2025-12-31 03:34:23'),
('d51ca3b2-9ad8-40bd-9ceb-a9959574707e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 19:00:00',19,82,12,3,'2025-12-31 03:42:48'),
('d569c255-21c4-4d7b-b0eb-b9fdd0d42af0','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 05:00:00',15,92,2,3,'2025-12-31 03:34:27'),
('d59e0772-fee1-487f-b001-016301edf289','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 09:00:00',28,58,7,1,'2025-12-31 03:17:13'),
('d63dd159-b589-4c00-8232-0e79d4d29be2','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 04:00:00',16,93,1,2,'2025-12-31 03:34:22'),
('d646b6fe-db87-432d-8058-de3ad8e4f225','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 06:00:00',22,80,7,2,'2025-12-31 03:17:15'),
('d75f7a25-3825-4e50-81eb-396c45ace3e9','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 17:00:00',21,75,14,95,'2025-12-31 03:34:25'),
('d7cc5cc6-c476-489b-adc4-fdac1e2e267a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 13:00:00',32,57,26,96,'2025-12-31 03:17:18'),
('d81013ae-95d0-424b-8e90-7870631d93de','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 03:00:00',16,93,1,2,'2025-12-31 03:34:22'),
('d8337603-4146-464a-8e14-9375f4cf048a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 04:00:00',18,97,1,45,'2025-12-31 01:25:52'),
('d8d99d03-b6a7-4495-81d4-f378bf93ca2e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 11:00:00',31,48,11,2,'2025-12-31 03:17:17'),
('d8f6c4a6-1ef7-4342-9f7f-5bd6cad4255d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 17:00:00',20,92,6,95,'2025-12-31 03:42:54'),
('d9122a6b-5045-4989-9d8f-36ccfc8ff613','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 20:00:00',20,88,3,63,'2025-12-31 03:34:28'),
('d97be03b-3ba5-40c9-8a40-6aa67a66e050','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 18:00:00',29,56,16,1,'2025-12-31 03:17:17'),
('da932c8d-9029-4f2a-9bd6-151e724a0040','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 15:00:00',23,63,23,1,'2025-12-31 03:42:50'),
('dac59556-b167-4efa-a77a-a719af865e1f','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 01:00:00',19,96,2,45,'2025-12-31 01:25:55'),
('dad33198-4ac5-4d54-80cc-41c22c113762','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 13:00:00',32,44,23,2,'2025-12-31 03:17:15'),
('dafd8eb1-3890-4b6f-a3de-ae6ac697b129','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 17:00:00',21,75,22,3,'2025-12-31 03:42:50'),
('db042b2b-a107-4b43-9913-e9da173e6609','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 08:00:00',19,79,10,3,'2025-12-31 03:34:22'),
('db2d1195-a9cc-44b2-b52b-2c61dcba4a4b','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 06:00:00',18,91,8,2,'2025-12-31 03:34:29'),
('dbcf6e1a-8c4a-416e-8d94-9a25b0942aac','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 10:00:00',23,58,10,3,'2025-12-31 03:42:51'),
('dcbbcb2c-a9a2-46ae-ae1f-ed186ee66dfe','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 03:00:00',18,96,3,45,'2025-12-31 01:25:48'),
('dcbc9888-d626-44aa-8d80-edf2324b24b6','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 08:00:00',21,81,9,2,'2025-12-31 01:25:57'),
('dd89a3fd-5615-481d-91b7-53756082c033','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 18:00:00',21,85,5,95,'2025-12-31 03:34:28'),
('ddf4dc87-0163-4df8-bcef-e5d2137a4419','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 05:00:00',16,92,2,2,'2025-12-31 03:34:23'),
('de55fcc0-fa70-421c-a1c1-38ea3c575552','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 02:00:00',22,86,6,1,'2025-12-31 03:17:15'),
('df08c867-203a-4874-94b5-115112a4c64e','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 14:00:00',24,60,22,2,'2025-12-31 03:34:25'),
('df26e0bc-77f8-4c73-ab35-7cb91dbc54e2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 08:00:00',25,63,7,0,'2025-12-31 03:17:13'),
('df411af6-0c25-429c-a577-495926f2f970','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 05:00:00',21,93,6,3,'2025-12-31 03:17:18'),
('df4499b1-29a5-4656-93e7-e975e2313364','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 23:00:00',19,86,10,3,'2025-12-31 03:34:30'),
('df4e6d3f-82f9-4f83-a320-23e9c8adb5cc','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 21:00:00',17,88,6,3,'2025-12-31 03:42:48'),
('df6525c4-ea2d-4c19-90cc-f38c35080738','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 16:00:00',32,46,21,1,'2025-12-31 03:17:14'),
('e07e8059-61e2-4221-aa44-805d09f3e1d6','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 04:00:00',16,91,2,3,'2025-12-31 03:34:27'),
('e080d8cd-fdb9-406f-845a-acc7173206fd','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 09:00:00',30,68,6,3,'2025-12-31 03:17:21'),
('e094b825-7ed3-4bf2-9157-4f6f48176f4b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 06:00:00',19,96,0,45,'2025-12-31 01:25:54'),
('e0e7adde-3efc-478f-b275-ee2cb3360b99','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 23:00:00',17,95,2,3,'2025-12-31 03:34:26'),
('e1172243-3b6e-4f40-a475-dcee33ac0051','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 20:00:00',28,84,8,3,'2025-12-31 03:17:22'),
('e53b4157-e3b6-412d-8c6c-dd3ba8f496f2','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 17:00:00',22,78,11,95,'2025-12-31 03:34:27'),
('e560a616-4a4b-42f8-b4a6-a19eceb78806','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 01:00:00',16,96,4,45,'2025-12-31 03:42:52'),
('e5709a34-76fb-44ed-895b-74ea74c91067','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 08:00:00',21,80,1,2,'2025-12-31 01:25:53'),
('e57db9a8-bc84-4def-9bac-e15448d66cf2','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 22:00:00',17,90,2,80,'2025-12-31 03:42:48'),
('e5a065be-fcf4-4ffe-b58c-6a249d8b111c','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 05:00:00',16,92,1,2,'2025-12-31 03:34:22'),
('e5b4cda7-c468-404f-ad01-bf534cf6d557','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 21:00:00',17,91,3,3,'2025-12-31 03:42:50'),
('e6101b28-10ec-4cf9-ba2d-f61792d00a5a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 02:00:00',16,94,1,2,'2025-12-31 03:34:23'),
('e6285ef9-8e9a-4da9-afaa-98b699f64155','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 04:00:00',15,99,3,45,'2025-12-31 03:42:51'),
('e6a8c1d4-17ae-427d-a11a-503a483ee5ca','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 12:00:00',26,63,9,2,'2025-12-31 01:25:50'),
('e759ba96-10ec-4469-b597-2d95f8ef66e1','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 02:00:00',22,91,6,1,'2025-12-31 03:17:16'),
('e80335c8-d1db-4124-a021-9e924e9742a4','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 11:00:00',35,44,8,3,'2025-12-31 03:17:20'),
('e8245878-6ab9-4fde-9ada-f9b19d1e378d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 22:00:00',18,93,1,3,'2025-12-31 03:34:23'),
('e87a0d99-64dd-4965-b50e-45a324fd967b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 15:00:00',22,66,25,2,'2025-12-31 03:42:49'),
('e8d452ad-3bff-46ae-8e0c-a5e3314e3304','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 15:00:00',28,46,13,3,'2025-12-31 01:25:57'),
('e904640b-3be4-4ce7-a0e8-7a39a7352f1b','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 14:00:00',28,54,11,3,'2025-12-31 01:25:54'),
('e9cb3281-7316-41d1-9212-9d18a6cb98bd','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 20:00:00',21,86,9,3,'2025-12-31 01:25:53'),
('ea10db7c-60f7-4242-b14a-251737225802','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 23:00:00',20,92,5,80,'2025-12-31 01:25:56'),
('ea6add6c-2528-4e8d-aa24-cdb80935f6fd','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-02 00:00:00',17,93,0,3,'2025-12-31 03:34:23'),
('ea7e35b1-5361-49ce-91cc-5715dfa69827','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 04:00:00',22,94,6,3,'2025-12-31 03:17:18'),
('eaadca46-15dc-4f41-a7a7-ed0615a2b19e','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 07:00:00',21,79,19,0,'2025-12-31 03:17:12'),
('eab74bd6-7d09-473f-95d1-a0c749ad5002','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 15:00:00',26,60,19,2,'2025-12-31 01:25:51'),
('ec4a6931-c12a-4dc2-a07a-3ea1daa84334','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 21:00:00',28,71,4,2,'2025-12-31 03:17:20'),
('ecc8a5be-2987-4094-a862-8daf735389e2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 06:00:00',25,88,5,3,'2025-12-31 03:17:21'),
('ed030f90-5924-46f8-84e0-f2cd487d023d','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 19:00:00',23,81,9,95,'2025-12-31 01:25:54'),
('ed168dba-648f-4332-99f4-f39075ce873d','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 21:00:00',19,90,11,3,'2025-12-31 03:42:56'),
('ed702eaa-8bb5-4937-a712-d572e339e626','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 14:00:00',26,46,19,1,'2025-12-31 03:42:55'),
('ee3158f1-d8e9-4be5-85ba-093a4e28c501','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-03 12:00:00',24,56,20,3,'2025-12-31 03:34:25'),
('ee351139-e0a3-43a8-aa45-ad68a1c7ea9a','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 11:00:00',25,56,15,3,'2025-12-31 03:34:29'),
('ee770937-e60f-4358-bb9a-847e61e30232','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 06:00:00',22,95,5,45,'2025-12-31 03:17:19'),
('eef648cc-4eb5-4f57-a018-2a8d3c7131d1','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 17:00:00',31,51,21,1,'2025-12-31 03:17:14'),
('ef5e7a09-8d12-48b3-86f3-e7a3e9b95248','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 17:00:00',25,69,10,96,'2025-12-31 01:25:54'),
('efa985bc-3b63-432e-885e-97942debba1a','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 04:00:00',20,81,15,0,'2025-12-31 03:17:12'),
('efb98980-edd8-4167-858e-3482313627a0','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 10:00:00',32,53,16,2,'2025-12-31 03:17:18'),
('eff6cc88-f3a9-46fe-91a7-78804a42f3aa','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 05:00:00',15,98,5,3,'2025-12-31 03:42:52'),
('f0db90fa-b36c-424b-bf25-5e7cc3c5e31e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 00:00:00',17,90,1,3,'2025-12-31 03:42:48'),
('f17e1465-3414-443f-ba5b-1e8f52e70474','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 17:00:00',23,85,10,95,'2025-12-31 01:25:56'),
('f1bdac8f-e558-40de-83e6-bf6686a1bd6b','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 15:00:00',35,39,24,2,'2025-12-31 03:17:20'),
('f1d59228-28d7-4705-982f-7d56ed2871b9','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 17:00:00',30,68,16,3,'2025-12-31 03:17:21'),
('f2604d81-664e-454b-bcd1-369eea42b9f0','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 18:00:00',19,87,9,80,'2025-12-31 03:34:22'),
('f2846d2d-3afe-49f7-bcff-bf9c37d990be','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 16:00:00',20,89,5,95,'2025-12-31 03:42:54'),
('f2be2dd6-78c8-43e3-9ea4-76f5d8239af7','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 09:00:00',22,75,13,2,'2025-12-31 01:25:50'),
('f335aee9-191c-4ef8-a592-8f59e901041b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-03 07:00:00',17,88,3,2,'2025-12-31 03:42:51'),
('f338a27f-fbbb-48c4-884e-b5bf5d8b7975','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 10:00:00',22,67,17,3,'2025-12-31 03:34:22'),
('f33cfae6-5944-4d1b-af4e-c01f5437a0fb','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 22:00:00',18,92,11,3,'2025-12-31 03:42:56'),
('f38bee4c-9655-4747-962e-f74eff69ab19','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 09:00:00',21,68,13,2,'2025-12-31 03:42:49'),
('f3c34dfb-35f3-48b7-8522-6477c913ebd1','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 10:00:00',22,65,17,3,'2025-12-31 03:42:55'),
('f4830406-dfc8-4dae-92b3-022d1197d689','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 16:00:00',25,64,19,80,'2025-12-31 01:25:51'),
('f4b801d1-5622-466d-8325-27ebb19a55c6','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 01:00:00',20,92,3,3,'2025-12-31 01:25:56'),
('f4f9f337-0dd5-4bb5-b5d8-9acbf665be7e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 13:00:00',27,54,10,3,'2025-12-31 01:25:54'),
('f4fb6790-e398-45b7-ac8d-688649849a7e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2025-12-31 09:00:00',21,61,12,1,'2025-12-31 03:42:47'),
('f522a802-69b3-4222-8842-cd62b11fd7fa','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 21:00:00',21,86,6,3,'2025-12-31 01:25:52'),
('f578b216-687a-4c3f-9832-b9926820b6a1','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 02:00:00',25,86,5,3,'2025-12-31 03:17:21'),
('f5d0e8ce-3050-4f9b-b773-c0fd882f2b08','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-06 01:00:00',18,92,7,3,'2025-12-31 03:42:55'),
('f5d328ba-efea-4c1f-9e21-b55d1fa24db8','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 02:00:00',17,89,2,1,'2025-12-31 03:34:27'),
('f5da21b3-0391-488a-95fe-a8c9d6af9193','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-03 03:00:00',21,92,6,1,'2025-12-31 03:17:16'),
('f5f1a9a9-b3fe-4f62-abc0-b34d28e96b5e','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 05:00:00',15,97,5,3,'2025-12-31 03:42:53'),
('f5f4d2ad-6f31-4d9e-9d07-6661b359c1bc','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-01 22:00:00',24,75,6,0,'2025-12-31 03:17:14'),
('f5fd304a-0ed3-4802-bc42-b8fca6caa95f','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-03 02:00:00',18,96,1,45,'2025-12-31 01:25:52'),
('f61ea6ba-b60c-4039-8e7f-9109096f07db','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-06 16:00:00',31,67,16,3,'2025-12-31 03:17:21'),
('f61fb519-04b3-4823-976d-d53cdb2dbf84','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 19:00:00',28,41,19,0,'2025-12-31 03:17:12'),
('f6a49cf4-7c46-4a3a-a6b4-42f228f2d0d8','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 08:00:00',28,72,6,3,'2025-12-31 03:17:20'),
('f6cdacd9-8bdb-4cfe-8cca-1459752db34b','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 12:00:00',24,67,15,95,'2025-12-31 03:34:28'),
('f71ebb04-9499-430c-959a-176f7a372b1b','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-02 23:00:00',16,96,4,45,'2025-12-31 03:42:51'),
('f74c9891-2308-4f4c-9540-80bf96b4d7d0','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-05 09:00:00',23,69,1,2,'2025-12-31 03:34:28'),
('f74d964c-d7e6-4a30-b2f5-1c0ffb2d2cfc','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 16:00:00',24,68,15,95,'2025-12-31 01:25:49'),
('f76211dd-0905-40c4-aead-910ae34ad04c','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 19:00:00',26,67,18,2,'2025-12-31 03:17:16'),
('f7624c37-d7a5-4b1b-b4d0-7d314d48c4d7','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-06 21:00:00',20,89,9,3,'2025-12-31 01:25:57'),
('f86d3deb-0968-4fd0-a8d5-a26d27de27e0','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-05 20:00:00',29,66,8,2,'2025-12-31 03:17:20'),
('f87882d0-8342-4ff1-9ee5-f4bdb147f89d','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 09:00:00',22,69,8,3,'2025-12-31 03:34:26'),
('f8f01c5c-82ac-47d4-936e-8f50c9542b77','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 19:00:00',21,94,12,96,'2025-12-31 01:25:56'),
('f95075c0-f1c1-4d10-b862-8df96fed23cc','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 01:00:00',21,74,17,0,'2025-12-31 03:17:12'),
('f9b90a30-ce7f-4d39-ba88-1cb43f08d3c7','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-01 06:00:00',18,96,1,45,'2025-12-31 01:25:50'),
('fa1e3441-2741-4a8e-8645-9895b504e2f2','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 21:00:00',25,76,5,1,'2025-12-31 03:17:16'),
('fa612f4d-bd49-49e7-894e-91d6b474bdfb','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 20:00:00',21,76,9,80,'2025-12-31 03:34:30'),
('fa8cac63-9663-41f2-8491-edf81f9960ee','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-05 02:00:00',16,95,4,2,'2025-12-31 03:42:53'),
('fb1b043a-d3c5-4d77-bd9a-b97b4cd31e71','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 00:00:00',23,83,6,1,'2025-12-31 03:17:15'),
('fb3c449c-d211-48a9-a8b9-8d91df97d35d','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-04 11:00:00',26,60,9,3,'2025-12-31 01:25:54'),
('fb3fda71-8064-4ed3-9e16-833d83d2ab37','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-01 08:00:00',19,76,8,2,'2025-12-31 03:42:49'),
('fb46740a-01ee-44d1-bc6d-2f2e3b7d2925','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 06:00:00',18,91,5,2,'2025-12-31 01:25:48'),
('fb767a51-0b61-49f5-86a0-ec6187a5ca9f','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-01 15:00:00',22,75,26,80,'2025-12-31 03:34:22'),
('fc5aaddc-37f9-4384-b778-c2f71a960eb3','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2025-12-31 11:00:00',29,50,21,0,'2025-12-31 03:17:12'),
('fd0a4cd9-4e68-45f0-9cea-1f72da7d507b','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-04 02:00:00',16,96,3,45,'2025-12-31 03:34:26'),
('fd5d959b-0c7b-4ff1-8321-2cede3d63b12','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-02 22:00:00',24,80,3,2,'2025-12-31 03:17:16'),
('fdb852f8-5e0d-4de2-97ea-8f61c1321aa6','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 20:00:00',21,93,10,96,'2025-12-31 01:25:56'),
('fdbc9358-18a0-4003-851e-724841e068a8','1651e54e-de81-4494-8ac3-2bdf9406ad58','2025-12-31 11:00:00',25,59,13,3,'2025-12-31 01:25:48'),
('fdbd7086-b996-40f0-b19b-752cbedb471a','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-05 10:00:00',25,68,8,3,'2025-12-31 01:25:55'),
('fddd52b4-ef69-4f8a-8487-da15c72d7e43','bdc3f461-4a54-4670-8966-39bb092a9ec8','2026-01-04 20:00:00',19,90,1,80,'2025-12-31 03:42:53'),
('fdf6bc94-9f24-468d-8a54-306ad4648f0e','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 18:00:00',23,73,15,3,'2025-12-31 01:25:51'),
('fe1dd9e9-1347-45fa-8547-dcde73de75fd','1651e54e-de81-4494-8ac3-2bdf9406ad58','2026-01-02 13:00:00',27,52,18,3,'2025-12-31 01:25:51'),
('fe7c6ea2-a27d-48a1-ad9f-4332c72fdb60','51387727-9b3b-485d-9869-6e474d2656e7','2026-01-06 21:00:00',20,84,6,80,'2025-12-31 03:34:30'),
('fea4d1b9-45d0-4bf7-8a9c-b5c05dc1b030','cd8f7118-54d9-4f9d-b4f9-0b700a528daa','2026-01-04 01:00:00',22,94,5,2,'2025-12-31 03:17:18');
/*!40000 ALTER TABLE `weather_hourly` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weather_locations`
--

DROP TABLE IF EXISTS `weather_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather_locations` (
  `id` char(36) NOT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  `place_name` varchar(150) NOT NULL,
  `region` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather_locations`
--

LOCK TABLES `weather_locations` WRITE;
/*!40000 ALTER TABLE `weather_locations` DISABLE KEYS */;
INSERT INTO `weather_locations` VALUES
('1651e54e-de81-4494-8ac3-2bdf9406ad58',-18.879200,47.507900,'Antananarivo',NULL,NULL,'2025-12-25 01:34:49'),
('51387727-9b3b-485d-9869-6e474d2656e7',-19.865860,47.033330,'Antsirabe, Vakinankaratra Region, Madagascar',NULL,NULL,'2025-12-31 03:12:54'),
('bdc3f461-4a54-4670-8966-39bb092a9ec8',-19.783330,47.100000,'Andranomanelatra, Vakinankaratra Region, Madagascar',NULL,NULL,'2025-12-31 03:14:17'),
('cd8f7118-54d9-4f9d-b4f9-0b700a528daa',-23.550000,44.100000,'Antanimena, Atsimo-Andrefana Region, Madagascar',NULL,NULL,'2025-12-31 03:16:30');
/*!40000 ALTER TABLE `weather_locations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-02 21:29:12
