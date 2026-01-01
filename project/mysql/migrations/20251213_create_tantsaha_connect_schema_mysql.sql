-- MySQL-compatible schema converted from PostgreSQL migration
-- Date: 2025-12-13
-- Changes applied for compatibility:
--  - Avoided `DEFAULT (UUID())` to support older MySQL/MariaDB; generate UUIDs from app or add triggers.
--  - Escaped reserved column name `condition` with backticks to avoid syntax errors.
--  - Removed `IF NOT EXISTS` from CREATE INDEX statements for phpMyAdmin compatibility.

CREATE DATABASE IF NOT EXISTS `tantsaha_connect` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `tantsaha_connect`;

-- Minimal users table (placeholder if you move off Supabase auth)
CREATE TABLE IF NOT EXISTS `users` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- regions table
CREATE TABLE IF NOT EXISTS `regions` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `name` TEXT NOT NULL,
  `name_fr` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- profiles table
CREATE TABLE IF NOT EXISTS `profiles` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `full_name` TEXT NOT NULL,
  `region_id` CHAR(36),
  `profile_photo_url` TEXT,
  `phone` VARCHAR(50),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_profiles_region` FOREIGN KEY (`region_id`) REFERENCES `regions`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_profiles_user` FOREIGN KEY (`id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- weather_forecasts table
CREATE TABLE IF NOT EXISTS `weather_forecasts` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `region_id` CHAR(36) NOT NULL,
  `forecast_date` DATE NOT NULL,
  `temp_min` INT NOT NULL,
  `temp_max` INT NOT NULL,
  `humidity` INT,
  `condition` TEXT NOT NULL,
  `condition_icon` TEXT NOT NULL,
  `description_mg` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_weather_region` FOREIGN KEY (`region_id`) REFERENCES `regions`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_region_forecast_date` (`region_id`, `forecast_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- weather_alerts table
CREATE TABLE IF NOT EXISTS `weather_alerts` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `region_id` CHAR(36) NOT NULL,
  `alert_type` TEXT NOT NULL,
  `severity` ENUM('danger','warning','info') NOT NULL,
  `title_mg` TEXT NOT NULL,
  `message_mg` TEXT NOT NULL,
  `recommendation_mg` TEXT,
  `alert_date` DATE NOT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_alerts_region` FOREIGN KEY (`region_id`) REFERENCES `regions`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- agricultural_advices table
CREATE TABLE IF NOT EXISTS `agricultural_advices` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `region_id` CHAR(36),
  `crop_type` TEXT NOT NULL,
  `season` TEXT NOT NULL,
  `title_mg` TEXT NOT NULL,
  `content_mg` TEXT NOT NULL,
  `icon` TEXT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_advices_region` FOREIGN KEY (`region_id`) REFERENCES `regions`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- crop_journal table
CREATE TABLE IF NOT EXISTS `crop_journal` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `user_id` CHAR(36) NOT NULL,
  `observation_date` DATE NOT NULL,
  `observation_type` TEXT NOT NULL,
  `crop_type` TEXT,
  `notes_mg` TEXT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_journal_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Indexes (without IF NOT EXISTS for phpMyAdmin compatibility)
CREATE INDEX `idx_profiles_region` ON `profiles`(`region_id`);
CREATE INDEX `idx_weather_forecasts_region_date` ON `weather_forecasts`(`region_id`, `forecast_date`);
CREATE INDEX `idx_weather_alerts_region_active` ON `weather_alerts`(`region_id`, `is_active`);
CREATE INDEX `idx_agricultural_advices_region` ON `agricultural_advices`(`region_id`);
CREATE INDEX `idx_crop_journal_user_date` ON `crop_journal`(`user_id`, `observation_date`);

-- Notes: MySQL/MariaDB don't support Postgres RLS policies. Implement access control in your backend API.
