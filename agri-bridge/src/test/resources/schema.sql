CREATE TABLE IF NOT EXISTS sys_user (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role TINYINT NOT NULL,
  status TINYINT NOT NULL DEFAULT 1,
  real_name VARCHAR(64) NULL,
  avatar VARCHAR(255) NULL,
  gender TINYINT NULL,
  address VARCHAR(255) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_listing (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  type TINYINT NOT NULL,
  title VARCHAR(128) NOT NULL,
  product_id BIGINT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  unit_id BIGINT NOT NULL,
  price DECIMAL(12,2) NULL,
  location VARCHAR(128) NULL,
  description TEXT NULL,
  contact_name VARCHAR(64) NULL,
  contact_phone VARCHAR(32) NULL,
  status TINYINT NOT NULL DEFAULT 1,
  publisher_id BIGINT NOT NULL,
  start_time DATETIME NULL,
  end_time DATETIME NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);
