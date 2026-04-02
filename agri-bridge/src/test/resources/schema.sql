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

CREATE TABLE IF NOT EXISTS sys_qualification (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  type VARCHAR(64) NOT NULL,
  number VARCHAR(128) NOT NULL,
  file_url VARCHAR(255) NULL,
  status TINYINT NOT NULL DEFAULT 1,
  remark VARCHAR(255) NULL,
  audit_by BIGINT NULL,
  audit_time DATETIME NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dict_category (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  parent_id BIGINT NULL,
  sort_no INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dict_unit (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(32) NOT NULL,
  symbol VARCHAR(16) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(128) NOT NULL,
  category_id BIGINT NOT NULL,
  unit_id BIGINT NOT NULL,
  origin VARCHAR(128) NULL,
  description TEXT NULL,
  image_url VARCHAR(255) NULL,
  traceable TINYINT NOT NULL DEFAULT 1,
  status TINYINT NOT NULL DEFAULT 1,
  owner_id BIGINT NOT NULL,
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
  remark VARCHAR(500) NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_inventory (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  producer_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  unit_id BIGINT NOT NULL,
  location VARCHAR(128) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_order (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_no VARCHAR(32) NOT NULL,
  buyer_id BIGINT NOT NULL,
  seller_id BIGINT NOT NULL,
  status TINYINT NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  total_quantity DECIMAL(12,2) NOT NULL,
  delivery_address VARCHAR(255) NOT NULL,
  contact_name VARCHAR(64) NULL,
  expected_delivery_time DATETIME NULL,
  remark VARCHAR(255) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_order_item (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(128) NOT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  unit_id BIGINT NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_after_sale (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  buyer_id BIGINT NOT NULL,
  seller_id BIGINT NOT NULL,
  type TINYINT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  status TINYINT NOT NULL,
  audit_by BIGINT NULL,
  audit_time DATETIME NULL,
  remark VARCHAR(500) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_schedule (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  producer_id BIGINT NOT NULL,
  type TINYINT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NULL,
  location VARCHAR(128) NOT NULL,
  route_plan TEXT NULL,
  order_id BIGINT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS biz_trace_batch (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  batch_no VARCHAR(64) NOT NULL,
  producer_id BIGINT NOT NULL,
  production_date DATE NULL,
  harvest_date DATE NULL,
  expiry_date DATE NULL,
  trace_info TEXT NULL,
  qr_code_url VARCHAR(255) NULL,
  status TINYINT NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS msg_conversation (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_a_id BIGINT NOT NULL,
  user_b_id BIGINT NOT NULL,
  last_message VARCHAR(255) NULL,
  last_time DATETIME NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS msg_message (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  conversation_id BIGINT NOT NULL,
  sender_id BIGINT NOT NULL,
  content TEXT NOT NULL,
  type TINYINT NOT NULL,
  read_flag TINYINT NOT NULL DEFAULT 0,
  sent_at DATETIME NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS sys_notice (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(128) NOT NULL,
  content TEXT NOT NULL,
  publish_status TINYINT NOT NULL DEFAULT 1,
  publish_time DATETIME NULL,
  publisher_id BIGINT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS sys_audit_record (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  target_type TINYINT NOT NULL,
  target_id BIGINT NOT NULL,
  status TINYINT NOT NULL,
  remark VARCHAR(255) NULL,
  auditor_id BIGINT NOT NULL,
  audit_time DATETIME NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS sys_export_record (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  exporter_id BIGINT NOT NULL,
  type VARCHAR(64) NOT NULL,
  params TEXT NULL,
  file_name VARCHAR(128) NULL,
  file_url VARCHAR(255) NULL,
  status TINYINT NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
);
