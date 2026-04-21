-- 农产品产销对接管理系统 DDL
-- 数据库：agri_bridge
DROP DATABASE agri_bridge;
CREATE DATABASE IF NOT EXISTS agri_bridge DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE agri_bridge;

SET NAMES utf8mb4;

-- 用户
CREATE TABLE IF NOT EXISTS sys_user (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role TINYINT NOT NULL COMMENT '1管理员 2生产方 3采购方',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '1启用 2禁用',
  real_name VARCHAR(64) NULL,
  avatar VARCHAR(255) NULL,
  gender TINYINT NULL COMMENT '0未知 1男 2女',
  address VARCHAR(255) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_user_username (username),
  KEY idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 资质
CREATE TABLE IF NOT EXISTS sys_qualification (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  type VARCHAR(64) NOT NULL,
  number VARCHAR(128) NOT NULL,
  file_url VARCHAR(255) NULL,
  status TINYINT NOT NULL DEFAULT 1 COMMENT '1待审 2通过 3驳回',
  remark VARCHAR(255) NULL,
  audit_by BIGINT NULL,
  audit_time DATETIME NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_qual_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 分类
CREATE TABLE IF NOT EXISTS dict_category (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  parent_id BIGINT NULL,
  sort_no INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_cat_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 单位
CREATE TABLE IF NOT EXISTS dict_unit (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(32) NOT NULL,
  symbol VARCHAR(16) NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 商品
CREATE TABLE IF NOT EXISTS biz_product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(128) NOT NULL,
  category_id BIGINT NOT NULL,
  unit_id BIGINT NOT NULL,
  origin VARCHAR(128) NULL,
  description TEXT NULL,
  image_url VARCHAR(255) NULL,
  traceable TINYINT NOT NULL DEFAULT 1,
  status TINYINT NOT NULL DEFAULT 1 COMMENT '1上架 2下架',
  owner_id BIGINT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_prod_cat (category_id),
  KEY idx_prod_owner (owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 信息发布
CREATE TABLE IF NOT EXISTS biz_listing (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  type TINYINT NOT NULL COMMENT '1供给 2求购',
  title VARCHAR(128) NOT NULL,
  product_id BIGINT NULL,
  quantity DECIMAL(12,2) NOT NULL,
  unit_id BIGINT NOT NULL,
  price DECIMAL(12,2) NULL,
  location VARCHAR(128) NULL,
  description TEXT NULL,
  contact_name VARCHAR(64) NULL,
  contact_phone VARCHAR(32) NULL,
  status TINYINT NOT NULL DEFAULT 1 COMMENT '1待审2通过3驳回4上架5下架6过期',
  publisher_id BIGINT NOT NULL,
  start_time DATETIME NULL,
  end_time DATETIME NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  remark VARCHAR(500) NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_list_type (type),
  KEY idx_list_pub (publisher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 库存
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
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_inv_producer (producer_id),
  KEY idx_inv_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单
CREATE TABLE IF NOT EXISTS biz_order (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_no VARCHAR(32) NOT NULL,
  buyer_id BIGINT NOT NULL,
  seller_id BIGINT NOT NULL,
  status TINYINT NOT NULL COMMENT '1待付款2待发货3配送中4已送达5已完成6已取消7售后中',
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
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_order_no (order_no),
  KEY idx_order_buyer (buyer_id),
  KEY idx_order_seller (seller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单明细
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
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_order_item_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 售后
CREATE TABLE IF NOT EXISTS biz_after_sale (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  buyer_id BIGINT NOT NULL,
  seller_id BIGINT NOT NULL,
  type TINYINT NOT NULL COMMENT '1仅退款2退货退款',
  reason VARCHAR(255) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  status TINYINT NOT NULL COMMENT '1待审2通过3驳回4完成',
  audit_by BIGINT NULL,
  audit_time DATETIME NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  remark VARCHAR(500) NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_after_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 日程
CREATE TABLE IF NOT EXISTS biz_schedule (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  producer_id BIGINT NOT NULL,
  type TINYINT NOT NULL COMMENT '1采收2配送',
  start_time DATETIME NOT NULL,
  end_time DATETIME NULL,
  location VARCHAR(128) NOT NULL,
  route_plan TEXT NULL,
  order_id BIGINT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_sched_producer (producer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 溯源批次
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
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_trace_product (product_id),
  KEY idx_trace_producer (producer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 会话
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
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_conv_a (user_a_id),
  KEY idx_conv_b (user_b_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 消息
CREATE TABLE IF NOT EXISTS msg_message (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  conversation_id BIGINT NOT NULL,
  sender_id BIGINT NOT NULL,
  content TEXT NOT NULL,
  type TINYINT NOT NULL COMMENT '1文本2图片3文件',
  read_flag TINYINT NOT NULL DEFAULT 0,
  sent_at DATETIME NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_msg_conv (conversation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 公告
CREATE TABLE IF NOT EXISTS sys_notice (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(128) NOT NULL,
  content TEXT NOT NULL,
  publish_status TINYINT NOT NULL DEFAULT 1 COMMENT '1草稿2发布',
  publish_time DATETIME NULL,
  publisher_id BIGINT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 审核记录
CREATE TABLE IF NOT EXISTS sys_audit_record (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  target_type TINYINT NOT NULL COMMENT '1发布2资质',
  target_id BIGINT NOT NULL,
  status TINYINT NOT NULL COMMENT '1通过2驳回',
  remark VARCHAR(255) NULL,
  auditor_id BIGINT NOT NULL,
  audit_time DATETIME NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 导出记录
CREATE TABLE IF NOT EXISTS sys_export_record (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  exporter_id BIGINT NOT NULL,
  type VARCHAR(64) NOT NULL,
  params TEXT NULL,
  file_name VARCHAR(128) NULL,
  file_url VARCHAR(255) NULL,
  status TINYINT NOT NULL DEFAULT 1 COMMENT '1生成中2完成3失败',
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  created_by BIGINT NULL,
  updated_by BIGINT NULL,
  deleted TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- 初始化模拟数据（演示用）
-- 说明：管理员账号由后端启动自动创建（admin/123456）。
-- 以下用户密码为占位符，不用于登录，仅用于数据展示。
-- =========================

-- 用户（生产方、采购方）
INSERT INTO sys_user (id, username, password, role, status, real_name, avatar, gender, address, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1001, 'producer01', '$2a$10$dummyhashproducer01dummyhash000000000000000000000', 2, 1, '郑丽', NULL, 2, '河南郑州', NOW(), NOW(), NULL, NULL, 0),
(1002, 'producer02', '$2a$10$dummyhashproducer02dummyhash000000000000000000000', 2, 1, '王强', NULL, 1, '河南开封', NOW(), NOW(), NULL, NULL, 0),
(1003, 'producer03', '$2a$10$dummyhashproducer03dummyhash000000000000000000000', 2, 1, '赵敏', NULL, 2, '山东寿光', NOW(), NOW(), NULL, NULL, 0),
(2001, 'buyer01', '$2a$10$dummyhashbuyer01dummyhash000000000000000000000000', 3, 1, '李晨', NULL, 1, '河南郑州', NOW(), NOW(), NULL, NULL, 0),
(2002, 'buyer02', '$2a$10$dummyhashbuyer02dummyhash000000000000000000000000', 3, 1, '周杰', NULL, 1, '北京朝阳', NOW(), NOW(), NULL, NULL, 0),
(2003, 'buyer03', '$2a$10$dummyhashbuyer03dummyhash000000000000000000000000', 3, 1, '林雨', NULL, 2, '上海浦东', NOW(), NOW(), NULL, NULL, 0);

-- 分类
INSERT INTO dict_category (id, name, parent_id, sort_no, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1, '蔬菜', NULL, 1, NOW(), NOW(), NULL, NULL, 0),
(2, '水果', NULL, 2, NOW(), NOW(), NULL, NULL, 0),
(3, '粮油', NULL, 3, NOW(), NOW(), NULL, NULL, 0),
(4, '肉类', NULL, 4, NOW(), NOW(), NULL, NULL, 0),
(5, '水产', NULL, 5, NOW(), NOW(), NULL, NULL, 0),
(6, '叶菜类', 1, 1, NOW(), NOW(), NULL, NULL, 0),
(7, '根茎类', 1, 2, NOW(), NOW(), NULL, NULL, 0),
(8, '柑橘类', 2, 1, NOW(), NOW(), NULL, NULL, 0),
(9, '瓜果类', 2, 2, NOW(), NOW(), NULL, NULL, 0);

-- 计量单位
INSERT INTO dict_unit (id, name, symbol, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1, '千克', 'kg', NOW(), NOW(), NULL, NULL, 0),
(2, '斤', '斤', NOW(), NOW(), NULL, NULL, 0),
(3, '吨', 't', NOW(), NOW(), NULL, NULL, 0),
(4, '箱', '箱', NOW(), NOW(), NULL, NULL, 0),
(5, '袋', '袋', NOW(), NOW(), NULL, NULL, 0),
(6, '件', '件', NOW(), NOW(), NULL, NULL, 0);

-- 商品
INSERT INTO biz_product (id, name, category_id, unit_id, origin, description, image_url, traceable, status, owner_id, created_at, updated_at, created_by, updated_by, deleted) VALUES
(101, '有机菠菜', 6, 2, '河南郑州', '绿色种植', NULL, 1, 1, 1001, NOW(), NOW(), NULL, NULL, 0),
(102, '红富士苹果', 2, 1, '山东烟台', '脆甜多汁', NULL, 1, 1, 1002, NOW(), NOW(), NULL, NULL, 0),
(103, '大蒜', 7, 2, '河南开封', '辛香浓郁', NULL, 0, 1, 1002, NOW(), NOW(), NULL, NULL, 0),
(104, '西红柿', 6, 2, '山东寿光', '口感沙甜', NULL, 1, 1, 1003, NOW(), NOW(), NULL, NULL, 0),
(105, '玉米', 3, 2, '河南周口', '优质饲料用玉米', NULL, 0, 1, 1001, NOW(), NOW(), NULL, NULL, 0),
(106, '草鱼', 5, 1, '湖北荆州', '鲜活水产', NULL, 1, 1, 1003, NOW(), NOW(), NULL, NULL, 0),
(107, '鸡蛋', 4, 2, '河北保定', '散养鸡蛋', NULL, 0, 1, 1001, NOW(), NOW(), NULL, NULL, 0),
(108, '黄瓜', 6, 2, '山东寿光', '脆爽多汁', NULL, 1, 1, 1003, NOW(), NOW(), NULL, NULL, 0);

-- 信息发布（供给/求购）
INSERT INTO biz_listing (id, type, title, product_id, quantity, unit_id, price, location, description, status, publisher_id, start_time, end_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(201, 1, '供应有机菠菜', 101, 800.00, 2, 4.80, '河南郑州', '现货供应，支持配送', 4, 1001, NOW(), DATE_ADD(NOW(), INTERVAL 20 DAY), NOW(), NOW(), NULL, NULL, 0),
(202, 1, '供应红富士苹果', 102, 500.00, 1, 6.50, '山东烟台', '品质稳定，支持大宗', 4, 1002, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), NOW(), NOW(), NULL, NULL, 0),
(203, 2, '求购黄瓜', 108, 1000.00, 2, 3.80, '北京', '餐饮渠道采购', 2, 2002, NOW(), DATE_ADD(NOW(), INTERVAL 10 DAY), NOW(), NOW(), NULL, NULL, 0),
(204, 2, '求购草鱼', 106, 300.00, 1, 12.00, '上海', '生鲜渠道采购', 2, 2003, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY), NOW(), NOW(), NULL, NULL, 0);

-- 库存
INSERT INTO biz_inventory (id, producer_id, product_id, quantity, unit_id, location, created_at, updated_at, created_by, updated_by, deleted) VALUES
(301, 1001, 101, 1200.00, 2, '郑州仓库A', NOW(), NOW(), NULL, NULL, 0),
(302, 1002, 102, 600.00, 1, '烟台冷库B', NOW(), NOW(), NULL, NULL, 0),
(303, 1003, 104, 900.00, 2, '寿光基地C', NOW(), NOW(), NULL, NULL, 0),
(304, 1003, 108, 1500.00, 2, '寿光基地C', NOW(), NOW(), NULL, NULL, 0);

-- 订单
INSERT INTO biz_order (id, order_no, buyer_id, seller_id, status, total_amount, total_quantity, delivery_address, contact_name, expected_delivery_time, remark, created_at, updated_at, created_by, updated_by, deleted) VALUES
(401, 'ORD202501010001', 2001, 1001, 2, 2400.00, 500.00, '河南郑州高新区', '李晨', DATE_ADD(NOW(), INTERVAL 3 DAY), '按时配送', NOW(), NOW(), NULL, NULL, 0),
(402, 'ORD202501010002', 2002, 1002, 3, 3250.00, 500.00, '北京朝阳区', '周杰', DATE_ADD(NOW(), INTERVAL 5 DAY), '', NOW(), NOW(), NULL, NULL, 0),
(403, 'ORD202501010003', 2003, 1003, 1, 1140.00, 300.00, '上海浦东新区', '林雨', DATE_ADD(NOW(), INTERVAL 4 DAY), '', NOW(), NOW(), NULL, NULL, 0);

-- 订单明细
INSERT INTO biz_order_item (id, order_id, product_id, product_name, quantity, unit_id, price, amount, created_at, updated_at, created_by, updated_by, deleted) VALUES
(501, 401, 101, '有机菠菜', 500.00, 2, 4.80, 2400.00, NOW(), NOW(), NULL, NULL, 0),
(502, 402, 102, '红富士苹果', 500.00, 1, 6.50, 3250.00, NOW(), NOW(), NULL, NULL, 0),
(503, 403, 106, '草鱼', 300.00, 1, 3.80, 1140.00, NOW(), NOW(), NULL, NULL, 0);

-- 售后
INSERT INTO biz_after_sale (id, order_id, buyer_id, seller_id, type, reason, amount, status, audit_by, audit_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(601, 401, 2001, 1001, 1, '部分破损', 120.00, 1, NULL, NULL, NOW(), NOW(), NULL, NULL, 0);

-- 日程
INSERT INTO biz_schedule (id, producer_id, type, start_time, end_time, location, route_plan, order_id, created_at, updated_at, created_by, updated_by, deleted) VALUES
(701, 1001, 1, DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), '郑州基地', '基地-仓库-装车', 401, NOW(), NOW(), NULL, NULL, 0),
(702, 1002, 2, DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), '烟台冷库', '冷库-高速-配送点', 402, NOW(), NOW(), NULL, NULL, 0);

-- 溯源批次
INSERT INTO biz_trace_batch (id, product_id, batch_no, producer_id, production_date, harvest_date, expiry_date, trace_info, qr_code_url, status, created_at, updated_at, created_by, updated_by, deleted) VALUES
(801, 101, 'BATCH-202501-01', 1001, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 20 DAY), '{\"farm\":\"郑州基地\",\"pesticide\":\"0\"}', 'trace://batch/BATCH-202501-01', 1, NOW(), NOW(), NULL, NULL, 0),
(802, 104, 'BATCH-202501-02', 1003, DATE_SUB(CURDATE(), INTERVAL 25 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_ADD(CURDATE(), INTERVAL 18 DAY), '{\"farm\":\"寿光基地\",\"pesticide\":\"低\"}', 'trace://batch/BATCH-202501-02', 1, NOW(), NOW(), NULL, NULL, 0);

-- 会话
INSERT INTO msg_conversation (id, user_a_id, user_b_id, last_message, last_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(901, 2001, 1001, '请确认明日发货', NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 消息
INSERT INTO msg_message (id, conversation_id, sender_id, content, type, read_flag, sent_at, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1001, 901, 2001, '请确认明日发货', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1002, 901, 1001, '已确认，明早装车', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 公告
INSERT INTO sys_notice (id, title, content, publish_status, publish_time, publisher_id, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1101, '平台升级通知', '平台将在本周末进行升级维护。', 2, NOW(), NULL, NOW(), NOW(), NULL, NULL, 0),
(1102, '春节物流提醒', '春节期间物流时效可能延迟，请提前安排。', 1, NULL, NULL, NOW(), NOW(), NULL, NULL, 0);

-- 审核记录
INSERT INTO sys_audit_record (id, target_type, target_id, status, remark, auditor_id, audit_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1201, 1, 201, 1, '信息完整，审核通过', 1, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1202, 2, 1, 1, '资质清晰，审核通过', 1, NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 资质
INSERT INTO sys_qualification (id, user_id, type, number, file_url, status, remark, audit_by, audit_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1301, 1001, '营业执照', '91370100MA3XXXXXXX', NULL, 2, '审核通过', 1, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1302, 2001, '采购资质', 'PQ-2025-0001', NULL, 1, NULL, NULL, NULL, NOW(), NOW(), NULL, NULL, 0);

-- 导出记录
INSERT INTO sys_export_record (id, exporter_id, type, params, file_name, file_url, status, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1401, 1, 'orders', '{\"status\":2}', 'orders_demo.xlsx', NULL, 2, NOW(), NOW(), NULL, NULL, 0);

-- =========================
-- 更多模拟数据（扩充测试用）
-- =========================

-- 更多用户
INSERT INTO sys_user (id, username, password, role, status, real_name, avatar, gender, address, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1004, 'producer04', '$2a$10$dummyhashproducer04dummyhash000000000000000000000', 2, 1, '郭涛', NULL, 1, '广西南宁', NOW(), NOW(), NULL, NULL, 0),
(1005, 'producer05', '$2a$10$dummyhashproducer05dummyhash000000000000000000000', 2, 1, '沈芳', NULL, 2, '云南昆明', NOW(), NOW(), NULL, NULL, 0),
(1006, 'producer06', '$2a$10$dummyhashproducer06dummyhash000000000000000000000', 2, 1, '马超', NULL, 1, '吉林长春', NOW(), NOW(), NULL, NULL, 0),
(1007, 'producer07', '$2a$10$dummyhashproducer07dummyhash000000000000000000000', 2, 1, '孙慧', NULL, 2, '陕西西安', NOW(), NOW(), NULL, NULL, 0),
(1008, 'producer08', '$2a$10$dummyhashproducer08dummyhash000000000000000000000', 2, 1, '蒋明', NULL, 1, '四川成都', NOW(), NOW(), NULL, NULL, 0),
(2004, 'buyer04', '$2a$10$dummyhashbuyer04dummyhash000000000000000000000000', 3, 1, '许晨', NULL, 1, '广州天河', NOW(), NOW(), NULL, NULL, 0),
(2005, 'buyer05', '$2a$10$dummyhashbuyer05dummyhash000000000000000000000000', 3, 1, '唐婧', NULL, 2, '深圳南山', NOW(), NOW(), NULL, NULL, 0),
(2006, 'buyer06', '$2a$10$dummyhashbuyer06dummyhash000000000000000000000000', 3, 1, '邵军', NULL, 1, '杭州西湖', NOW(), NOW(), NULL, NULL, 0),
(2007, 'buyer07', '$2a$10$dummyhashbuyer07dummyhash000000000000000000000000', 3, 1, '吴楠', NULL, 2, '南京鼓楼', NOW(), NOW(), NULL, NULL, 0),
(2008, 'buyer08', '$2a$10$dummyhashbuyer08dummyhash000000000000000000000000', 3, 1, '范浩', NULL, 1, '厦门思明', NOW(), NOW(), NULL, NULL, 0);

-- 更多分类
INSERT INTO dict_category (id, name, parent_id, sort_no, created_at, updated_at, created_by, updated_by, deleted) VALUES
(10, '瓜菜类', 1, 3, NOW(), NOW(), NULL, NULL, 0),
(11, '浆果类', 2, 3, NOW(), NOW(), NULL, NULL, 0),
(12, '豆类', 3, 1, NOW(), NOW(), NULL, NULL, 0),
(13, '禽类', 4, 1, NOW(), NOW(), NULL, NULL, 0),
(14, '淡水鱼', 5, 1, NOW(), NOW(), NULL, NULL, 0),
(15, '海水鱼', 5, 2, NOW(), NOW(), NULL, NULL, 0);

-- 更多单位
INSERT INTO dict_unit (id, name, symbol, created_at, updated_at, created_by, updated_by, deleted) VALUES
(7, '盒', '盒', NOW(), NOW(), NULL, NULL, 0),
(8, '筐', '筐', NOW(), NOW(), NULL, NULL, 0),
(9, '打', '打', NOW(), NOW(), NULL, NULL, 0);

-- 更多商品
INSERT INTO biz_product (id, name, category_id, unit_id, origin, description, image_url, traceable, status, owner_id, created_at, updated_at, created_by, updated_by, deleted) VALUES
(109, '草莓', 11, 1, '云南昆明', '香甜多汁', NULL, 1, 1, 1005, NOW(), NOW(), NULL, NULL, 0),
(110, '沃柑', 8, 1, '广西南宁', '酸甜适口', NULL, 1, 1, 1004, NOW(), NOW(), NULL, NULL, 0),
(111, '香菇', 6, 2, '河南信阳', '新鲜菌菇', NULL, 0, 1, 1007, NOW(), NOW(), NULL, NULL, 0),
(112, '大米', 3, 3, '黑龙江', '东北大米', NULL, 0, 1, 1006, NOW(), NOW(), NULL, NULL, 0),
(113, '鸡腿', 13, 1, '河北保定', '冷鲜禽肉', NULL, 0, 1, 1008, NOW(), NOW(), NULL, NULL, 0),
(114, '罗非鱼', 14, 1, '广东佛山', '活鲜水产', NULL, 1, 1, 1004, NOW(), NOW(), NULL, NULL, 0),
(115, '西瓜', 9, 1, '海南', '清甜解暑', NULL, 1, 1, 1005, NOW(), NOW(), NULL, NULL, 0),
(116, '毛豆', 12, 2, '江苏', '鲜嫩毛豆', NULL, 0, 1, 1007, NOW(), NOW(), NULL, NULL, 0);

-- 更多信息发布
INSERT INTO biz_listing (id, type, title, product_id, quantity, unit_id, price, location, description, status, publisher_id, start_time, end_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(205, 1, '供应草莓', 109, 300.00, 1, 15.50, '云南昆明', '冷链发货', 4, 1005, NOW(), DATE_ADD(NOW(), INTERVAL 12 DAY), NOW(), NOW(), NULL, NULL, 0),
(206, 1, '供应沃柑', 110, 800.00, 1, 5.20, '广西南宁', '适合商超', 4, 1004, NOW(), DATE_ADD(NOW(), INTERVAL 25 DAY), NOW(), NOW(), NULL, NULL, 0),
(207, 2, '求购香菇', 111, 400.00, 2, 7.00, '杭州', '餐饮渠道采购', 2, 2006, NOW(), DATE_ADD(NOW(), INTERVAL 8 DAY), NOW(), NOW(), NULL, NULL, 0),
(208, 2, '求购大米', 112, 20.00, 3, 3800.00, '广州', '团餐采购', 2, 2004, NOW(), DATE_ADD(NOW(), INTERVAL 20 DAY), NOW(), NOW(), NULL, NULL, 0),
(209, 1, '供应罗非鱼', 114, 500.00, 1, 11.50, '广东佛山', '活鲜配送', 4, 1004, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY), NOW(), NOW(), NULL, NULL, 0),
(210, 2, '求购西瓜', 115, 1200.00, 1, 2.60, '南京', '夏季促销', 2, 2007, NOW(), DATE_ADD(NOW(), INTERVAL 18 DAY), NOW(), NOW(), NULL, NULL, 0);

-- 更多库存
INSERT INTO biz_inventory (id, producer_id, product_id, quantity, unit_id, location, created_at, updated_at, created_by, updated_by, deleted) VALUES
(305, 1004, 110, 900.00, 1, '南宁仓库D', NOW(), NOW(), NULL, NULL, 0),
(306, 1005, 109, 450.00, 1, '昆明冷链E', NOW(), NOW(), NULL, NULL, 0),
(307, 1006, 112, 60.00, 3, '长春粮库F', NOW(), NOW(), NULL, NULL, 0),
(308, 1007, 111, 300.00, 2, '西安库房G', NOW(), NOW(), NULL, NULL, 0),
(309, 1008, 113, 500.00, 1, '成都冷库H', NOW(), NOW(), NULL, NULL, 0);

-- 更多订单
INSERT INTO biz_order (id, order_no, buyer_id, seller_id, status, total_amount, total_quantity, delivery_address, contact_name, expected_delivery_time, remark, created_at, updated_at, created_by, updated_by, deleted) VALUES
(404, 'ORD202501010004', 2004, 1004, 2, 4160.00, 800.00, '广州天河区', '许晨', DATE_ADD(NOW(), INTERVAL 6 DAY), '', NOW(), NOW(), NULL, NULL, 0),
(405, 'ORD202501010005', 2005, 1005, 4, 4650.00, 300.00, '深圳南山区', '唐婧', DATE_ADD(NOW(), INTERVAL 3 DAY), '', NOW(), NOW(), NULL, NULL, 0),
(406, 'ORD202501010006', 2006, 1007, 5, 2800.00, 400.00, '杭州西湖区', '邵军', DATE_ADD(NOW(), INTERVAL 4 DAY), '', NOW(), NOW(), NULL, NULL, 0),
(407, 'ORD202501010007', 2007, 1005, 3, 3120.00, 1200.00, '南京鼓楼区', '吴楠', DATE_ADD(NOW(), INTERVAL 5 DAY), '', NOW(), NOW(), NULL, NULL, 0),
(408, 'ORD202501010008', 2008, 1006, 1, 7600.00, 20.00, '厦门思明区', '范浩', DATE_ADD(NOW(), INTERVAL 7 DAY), '', NOW(), NOW(), NULL, NULL, 0);

-- 更多订单明细
INSERT INTO biz_order_item (id, order_id, product_id, product_name, quantity, unit_id, price, amount, created_at, updated_at, created_by, updated_by, deleted) VALUES
(504, 404, 110, '沃柑', 800.00, 1, 5.20, 4160.00, NOW(), NOW(), NULL, NULL, 0),
(505, 405, 109, '草莓', 300.00, 1, 15.50, 4650.00, NOW(), NOW(), NULL, NULL, 0),
(506, 406, 111, '香菇', 400.00, 2, 7.00, 2800.00, NOW(), NOW(), NULL, NULL, 0),
(507, 407, 115, '西瓜', 1200.00, 1, 2.60, 3120.00, NOW(), NOW(), NULL, NULL, 0),
(508, 408, 112, '大米', 20.00, 3, 3800.00, 7600.00, NOW(), NOW(), NULL, NULL, 0);

-- 更多售后
INSERT INTO biz_after_sale (id, order_id, buyer_id, seller_id, type, reason, amount, status, audit_by, audit_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(602, 405, 2005, 1005, 2, '到货破损', 300.00, 2, 1, NOW(), NOW(), NOW(), NULL, NULL, 0),
(603, 406, 2006, 1007, 1, '少量缺斤短两', 80.00, 3, 1, NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 更多日程
INSERT INTO biz_schedule (id, producer_id, type, start_time, end_time, location, route_plan, order_id, created_at, updated_at, created_by, updated_by, deleted) VALUES
(703, 1005, 1, DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), '昆明基地', '基地-冷链-发货', 405, NOW(), NOW(), NULL, NULL, 0),
(704, 1004, 2, DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), '南宁仓库', '仓库-高速-广州', 404, NOW(), NOW(), NULL, NULL, 0),
(705, 1007, 2, DATE_ADD(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 3 DAY), '西安库房', '库房-高速-杭州', 406, NOW(), NOW(), NULL, NULL, 0);

-- 更多溯源批次
INSERT INTO biz_trace_batch (id, product_id, batch_no, producer_id, production_date, harvest_date, expiry_date, trace_info, qr_code_url, status, created_at, updated_at, created_by, updated_by, deleted) VALUES
(803, 109, 'BATCH-202501-03', 1005, DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), '{\"farm\":\"昆明基地\",\"pesticide\":\"低\"}', 'trace://batch/BATCH-202501-03', 1, NOW(), NOW(), NULL, NULL, 0),
(804, 110, 'BATCH-202501-04', 1004, DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), '{\"farm\":\"南宁基地\",\"pesticide\":\"0\"}', 'trace://batch/BATCH-202501-04', 1, NOW(), NOW(), NULL, NULL, 0),
(805, 112, 'BATCH-202501-05', 1006, DATE_SUB(CURDATE(), INTERVAL 40 DAY), DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_ADD(CURDATE(), INTERVAL 180 DAY), '{\"farm\":\"东北产区\",\"pesticide\":\"0\"}', 'trace://batch/BATCH-202501-05', 1, NOW(), NOW(), NULL, NULL, 0);

-- 更多会话
INSERT INTO msg_conversation (id, user_a_id, user_b_id, last_message, last_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(902, 2004, 1004, '请确认价格和到货时间', NOW(), NOW(), NOW(), NULL, NULL, 0),
(903, 2005, 1005, '草莓冷链费用怎么算？', NOW(), NOW(), NOW(), NULL, NULL, 0),
(904, 2006, 1007, '香菇需几天内到货', NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 更多消息
INSERT INTO msg_message (id, conversation_id, sender_id, content, type, read_flag, sent_at, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1003, 902, 2004, '请确认价格和到货时间', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1004, 902, 1004, '价格已确认，2天内到货', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1005, 903, 2005, '草莓冷链费用怎么算？', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1006, 903, 1005, '按公里计费，可协商', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1007, 904, 2006, '香菇需几天内到货', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1008, 904, 1007, '72小时内到货', 1, 0, NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 更多公告
INSERT INTO sys_notice (id, title, content, publish_status, publish_time, publisher_id, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1103, '冷链运输说明', '冷链订单请在备注中注明温控要求。', 2, NOW(), NULL, NOW(), NOW(), NULL, NULL, 0),
(1104, '资质审核提示', '上传资质请确保清晰可读。', 2, NOW(), NULL, NOW(), NOW(), NULL, NULL, 0);

-- 更多审核记录
INSERT INTO sys_audit_record (id, target_type, target_id, status, remark, auditor_id, audit_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1203, 1, 205, 1, '供给信息真实', 1, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1204, 1, 206, 1, '信息完整', 1, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1205, 2, 1301, 1, '资质有效', 1, NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 更多资质
INSERT INTO sys_qualification (id, user_id, type, number, file_url, status, remark, audit_by, audit_time, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1303, 1004, '营业执照', '91440101MA3YYYYYYY', NULL, 2, '审核通过', 1, NOW(), NOW(), NOW(), NULL, NULL, 0),
(1304, 1005, '产地证明', 'CZ-2025-002', NULL, 1, NULL, NULL, NULL, NOW(), NOW(), NULL, NULL, 0),
(1305, 2006, '采购资质', 'PQ-2025-0006', NULL, 2, '审核通过', 1, NOW(), NOW(), NOW(), NULL, NULL, 0);

-- 更多导出记录
INSERT INTO sys_export_record (id, exporter_id, type, params, file_name, file_url, status, created_at, updated_at, created_by, updated_by, deleted) VALUES
(1402, 1, 'orders', '{\"status\":3}', 'orders_demo_2.xlsx', NULL, 2, NOW(), NOW(), NULL, NULL, 0),
(1403, 1, 'orders', '{\"status\":4}', 'orders_demo_3.xlsx', NULL, 2, NOW(), NOW(), NULL, NULL, 0);
