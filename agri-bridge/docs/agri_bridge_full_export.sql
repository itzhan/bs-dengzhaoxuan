-- MySQL dump 10.13  Distrib 9.2.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: agri_bridge
-- ------------------------------------------------------
-- Server version	9.2.0

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

--
-- Current Database: `agri_bridge`
--

/*!40000 DROP DATABASE IF EXISTS `agri_bridge`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `agri_bridge` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `agri_bridge`;

--
-- Table structure for table `biz_after_sale`
--

DROP TABLE IF EXISTS `biz_after_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_after_sale` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `buyer_id` bigint NOT NULL,
  `seller_id` bigint NOT NULL,
  `type` tinyint NOT NULL COMMENT '1仅退款2退货退款',
  `reason` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `status` tinyint NOT NULL COMMENT '1待审2通过3驳回4完成',
  `audit_by` bigint DEFAULT NULL,
  `audit_time` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_after_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_after_sale`
--

LOCK TABLES `biz_after_sale` WRITE;
/*!40000 ALTER TABLE `biz_after_sale` DISABLE KEYS */;
INSERT INTO `biz_after_sale` (`id`, `order_id`, `buyer_id`, `seller_id`, `type`, `reason`, `amount`, `status`, `audit_by`, `audit_time`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`, `remark`) VALUES (601,401,2001,1001,1,'部分破损',120.00,2,2009,'2026-04-02 22:30:24','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0,'有问题'),(602,405,2005,1005,2,'到货破损',300.00,2,1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(603,406,2006,1007,1,'少量缺斤短两',80.00,3,2009,'2026-04-02 17:18:04','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0,NULL),(604,401,2001,1001,1,'联调测试退款',10.00,2,2009,'2026-03-14 17:24:32','2026-03-14 17:23:53','2026-03-14 17:23:53',2001,2001,0,NULL),(605,401,2001,1001,1,'联调测试退款',10.00,2,2009,'2026-04-02 16:42:58','2026-03-14 17:24:32','2026-03-14 17:24:32',2001,2001,0,NULL);
/*!40000 ALTER TABLE `biz_after_sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_inventory`
--

DROP TABLE IF EXISTS `biz_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `producer_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `quantity` decimal(12,2) NOT NULL,
  `unit_id` bigint NOT NULL,
  `location` varchar(128) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_inv_producer` (`producer_id`),
  KEY `idx_inv_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_inventory`
--

LOCK TABLES `biz_inventory` WRITE;
/*!40000 ALTER TABLE `biz_inventory` DISABLE KEYS */;
INSERT INTO `biz_inventory` (`id`, `producer_id`, `product_id`, `quantity`, `unit_id`, `location`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (301,1001,101,80.00,2,'郑州仓库A','2025-12-28 17:50:22','2026-03-14 17:23:53',NULL,1001,1),(302,1002,102,600.00,1,'烟台冷库B','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(303,1003,104,900.00,2,'寿光基地C','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(304,1003,108,1500.00,2,'寿光基地C','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(305,1004,110,900.00,1,'南宁仓库D','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(306,1005,109,450.00,1,'昆明冷链E','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(307,1006,112,60.00,3,'长春粮库F','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(308,1007,111,300.00,2,'西安库房G','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(309,1008,113,500.00,1,'成都冷库H','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(310,1001,101,80.00,2,'测试仓库','2026-03-14 17:23:53','2026-03-14 17:24:32',1001,1001,1),(311,1001,101,50.00,2,'测试仓库','2026-03-14 17:24:32','2026-03-14 17:24:32',1001,1001,0),(312,1001,101,100.00,1,'仓库A','2026-04-02 16:36:43','2026-04-02 16:36:43',2009,2009,0),(313,1001,101,888.00,1,'测试仓-改','2026-04-02 16:42:31','2026-04-02 16:42:31',2009,2009,1),(314,1002,103,100.00,3,'是啊','2026-04-02 17:19:16','2026-04-02 17:19:16',2009,2009,0);
/*!40000 ALTER TABLE `biz_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_listing`
--

DROP TABLE IF EXISTS `biz_listing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_listing` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` tinyint NOT NULL COMMENT '1供给 2求购',
  `title` varchar(128) NOT NULL,
  `product_id` bigint DEFAULT NULL,
  `quantity` decimal(12,2) NOT NULL,
  `unit_id` bigint NOT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `location` varchar(128) DEFAULT NULL,
  `description` text,
  `contact_name` varchar(64) DEFAULT NULL,
  `contact_phone` varchar(32) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1待审2通过3驳回4上架5下架6过期',
  `publisher_id` bigint NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_list_type` (`type`),
  KEY `idx_list_pub` (`publisher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_listing`
--

LOCK TABLES `biz_listing` WRITE;
/*!40000 ALTER TABLE `biz_listing` DISABLE KEYS */;
INSERT INTO `biz_listing` (`id`, `type`, `title`, `product_id`, `quantity`, `unit_id`, `price`, `location`, `description`, `contact_name`, `contact_phone`, `status`, `publisher_id`, `start_time`, `end_time`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`, `remark`) VALUES (201,1,'供应有机菠菜',101,800.00,2,4.80,'河南郑州','现货供应，支持配送',NULL,NULL,3,1001,'2025-12-28 17:50:22','2026-01-17 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0,'商品信息不符合规范'),(202,1,'供应红富士苹果',102,500.00,1,6.50,'山东烟台','品质稳定，支持大宗',NULL,NULL,4,1002,'2025-12-28 17:50:22','2026-01-27 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(203,2,'求购黄瓜',108,1000.00,2,3.80,'北京','餐饮渠道采购',NULL,NULL,2,2002,'2025-12-28 17:50:22','2026-01-07 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(204,2,'求购草鱼',106,300.00,1,12.00,'上海','生鲜渠道采购',NULL,NULL,2,2003,'2025-12-28 17:50:22','2026-01-12 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(205,1,'供应草莓',109,300.00,1,15.50,'云南昆明','冷链发货',NULL,NULL,4,1005,'2025-12-28 17:50:22','2026-01-09 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(206,1,'供应沃柑',110,800.00,1,5.20,'广西南宁','适合商超',NULL,NULL,4,1004,'2025-12-28 17:50:22','2026-01-22 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(207,2,'求购香菇',111,400.00,2,7.00,'杭州','餐饮渠道采购',NULL,NULL,2,2006,'2025-12-28 17:50:22','2026-01-05 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(208,2,'求购大米',112,20.00,3,3800.00,'广州','团餐采购',NULL,NULL,2,2004,'2025-12-28 17:50:22','2026-01-17 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(209,1,'供应罗非鱼',114,500.00,1,11.50,'广东佛山','活鲜配送',NULL,NULL,4,1004,'2025-12-28 17:50:22','2026-01-12 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(210,2,'求购西瓜',115,1200.00,1,2.60,'南京','夏季促销',NULL,NULL,2,2007,'2025-12-28 17:50:22','2026-01-15 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0,NULL),(211,2,'富士山苹果',NULL,100.00,1,NULL,'河南郑州','','展昭','15515915507',2,2010,NULL,NULL,'2025-12-28 17:53:17','2025-12-28 17:53:17',2010,2010,0,NULL),(212,1,'test-listing-1773480233156',NULL,100.00,1,8.80,'测试','测试供给信息',NULL,NULL,1,1001,NULL,NULL,'2026-03-14 17:23:53','2026-03-14 17:23:53',1001,2009,1,NULL),(213,1,'test-listing-1773480272304',NULL,100.00,1,8.80,'测试','测试供给信息',NULL,NULL,2,1001,NULL,NULL,'2026-03-14 17:24:32','2026-03-14 17:24:32',1001,2009,1,NULL),(214,1,'测试供给信息',101,500.00,1,5.50,'郑州','新鲜蔬菜',NULL,NULL,1,2009,NULL,NULL,'2026-04-02 16:36:43','2026-04-02 16:36:43',2009,2009,0,NULL),(215,2,'测试求购',102,200.00,1,8.00,'开封','需要苹果','张三','13800138000',1,2009,NULL,NULL,'2026-04-02 16:36:43','2026-04-02 16:36:43',2009,2009,0,NULL),(216,1,'测试供给X-改',101,100.00,1,5.00,'测试',NULL,NULL,NULL,2,2009,NULL,NULL,'2026-04-02 16:42:31','2026-04-02 16:42:32',2009,2009,1,NULL),(217,2,'测试求购X',102,50.00,1,8.00,'测试',NULL,'张三','13800000000',1,2009,NULL,NULL,'2026-04-02 16:42:31','2026-04-02 16:42:32',2009,2009,1,NULL),(218,1,'测试',102,3.00,3,3.00,'11','',NULL,NULL,2,2009,NULL,NULL,'2026-04-02 17:16:48','2026-04-02 17:16:48',2009,2009,0,NULL);
/*!40000 ALTER TABLE `biz_listing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_order`
--

DROP TABLE IF EXISTS `biz_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) NOT NULL,
  `buyer_id` bigint NOT NULL,
  `seller_id` bigint NOT NULL,
  `status` tinyint NOT NULL COMMENT '1待付款2待发货3配送中4已送达5已完成6已取消7售后中',
  `total_amount` decimal(12,2) NOT NULL,
  `total_quantity` decimal(12,2) NOT NULL,
  `delivery_address` varchar(255) NOT NULL,
  `contact_name` varchar(64) DEFAULT NULL,
  `expected_delivery_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_order_buyer` (`buyer_id`),
  KEY `idx_order_seller` (`seller_id`)
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_order`
--

LOCK TABLES `biz_order` WRITE;
/*!40000 ALTER TABLE `biz_order` DISABLE KEYS */;
INSERT INTO `biz_order` (`id`, `order_no`, `buyer_id`, `seller_id`, `status`, `total_amount`, `total_quantity`, `delivery_address`, `contact_name`, `expected_delivery_time`, `remark`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (401,'ORD202501010001',2001,1001,2,2400.00,500.00,'河南郑州高新区','李晨','2025-12-31 17:50:22','按时配送','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(402,'ORD202501010002',2002,1002,3,3250.00,500.00,'北京朝阳区','周杰','2026-01-02 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(403,'ORD202501010003',2003,1003,1,1140.00,300.00,'上海浦东新区','林雨','2026-01-01 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(404,'ORD202501010004',2004,1004,2,4160.00,800.00,'广州天河区','许晨','2026-01-03 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(405,'ORD202501010005',2005,1005,4,4650.00,300.00,'深圳南山区','唐婧','2025-12-31 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(406,'ORD202501010006',2006,1007,5,2800.00,400.00,'杭州西湖区','邵军','2026-01-01 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(407,'ORD202501010007',2007,1005,3,3120.00,1200.00,'南京鼓楼区','吴楠','2026-01-02 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(408,'ORD202501010008',2008,1006,1,7600.00,20.00,'厦门思明区','范浩','2026-01-04 17:50:22','','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0),(409,'ORD20260314172353868',2001,1001,5,48.00,10.00,'测试地址','测试人',NULL,'联调测试订单','2026-03-14 17:23:53','2026-03-14 17:23:53',2001,2001,0),(410,'ORD20260314172432518',2001,1001,2,48.00,10.00,'测试地址','测试人',NULL,'联调测试订单','2026-03-14 17:24:32','2026-03-14 17:24:32',2001,2001,0),(411,'ORD20260402234535289',2001,1002,1,6.50,1.00,'11','11',NULL,'11','2026-04-02 23:45:35','2026-04-02 23:45:35',2001,2001,0),(412,'ORD20260402234535685',2001,1005,1,15.50,1.00,'11','11',NULL,'11','2026-04-02 23:45:35','2026-04-02 23:45:35',2001,2001,0);
/*!40000 ALTER TABLE `biz_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_order_item`
--

DROP TABLE IF EXISTS `biz_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `product_name` varchar(128) NOT NULL,
  `quantity` decimal(12,2) NOT NULL,
  `unit_id` bigint NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_order_item_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_order_item`
--

LOCK TABLES `biz_order_item` WRITE;
/*!40000 ALTER TABLE `biz_order_item` DISABLE KEYS */;
INSERT INTO `biz_order_item` (`id`, `order_id`, `product_id`, `product_name`, `quantity`, `unit_id`, `price`, `amount`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (501,401,101,'有机菠菜',500.00,2,4.80,2400.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(502,402,102,'红富士苹果',500.00,1,6.50,3250.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(503,403,106,'草鱼',300.00,1,3.80,1140.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(504,404,110,'沃柑',800.00,1,5.20,4160.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(505,405,109,'草莓',300.00,1,15.50,4650.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(506,406,111,'香菇',400.00,2,7.00,2800.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(507,407,115,'西瓜',1200.00,1,2.60,3120.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(508,408,112,'大米',20.00,3,3800.00,7600.00,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(509,409,101,'有机菠菜',10.00,2,4.80,48.00,'2026-03-14 17:23:53','2026-03-14 17:23:53',2001,2001,0),(510,410,101,'有机菠菜',10.00,2,4.80,48.00,'2026-03-14 17:24:32','2026-03-14 17:24:32',2001,2001,0),(511,411,102,'供应红富士苹果',1.00,1,6.50,6.50,'2026-04-02 23:45:35','2026-04-02 23:45:35',2001,2001,0),(512,412,109,'供应草莓',1.00,1,15.50,15.50,'2026-04-02 23:45:35','2026-04-02 23:45:35',2001,2001,0);
/*!40000 ALTER TABLE `biz_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_product`
--

DROP TABLE IF EXISTS `biz_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `category_id` bigint NOT NULL,
  `unit_id` bigint NOT NULL,
  `origin` varchar(128) DEFAULT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `traceable` tinyint NOT NULL DEFAULT '1',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1上架 2下架',
  `owner_id` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_prod_cat` (`category_id`),
  KEY `idx_prod_owner` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_product`
--

LOCK TABLES `biz_product` WRITE;
/*!40000 ALTER TABLE `biz_product` DISABLE KEYS */;
INSERT INTO `biz_product` (`id`, `name`, `category_id`, `unit_id`, `origin`, `description`, `image_url`, `traceable`, `status`, `owner_id`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (101,'有机菠菜',6,2,'河南郑州','绿色种植',NULL,1,1,1001,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(102,'红富士苹果',2,1,'山东烟台','脆甜多汁',NULL,1,1,1002,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(103,'大蒜',7,2,'河南开封','辛香浓郁',NULL,0,1,1002,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(104,'西红柿',6,2,'山东寿光','口感沙甜',NULL,1,1,1003,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(105,'玉米',3,2,'河南周口','优质饲料用玉米',NULL,0,1,1001,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(106,'草鱼',5,1,'湖北荆州','鲜活水产',NULL,1,1,1003,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(107,'鸡蛋',4,2,'河北保定','散养鸡蛋',NULL,0,1,1001,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(108,'黄瓜',6,2,'山东寿光','脆爽多汁',NULL,1,1,1003,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(109,'草莓',11,1,'云南昆明','香甜多汁',NULL,1,1,1005,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(110,'沃柑',8,1,'广西南宁','酸甜适口',NULL,1,1,1004,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(111,'香菇',6,2,'河南信阳','新鲜菌菇',NULL,0,1,1007,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(112,'大米',3,3,'黑龙江','东北大米',NULL,0,1,1006,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(113,'鸡腿',13,1,'河北保定','冷鲜禽肉',NULL,0,1,1008,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(114,'罗非鱼',14,1,'广东佛山','活鲜水产',NULL,1,1,1004,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(115,'西瓜',9,1,'海南','清甜解暑',NULL,1,1,1005,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(116,'毛豆',12,2,'江苏','鲜嫩毛豆',NULL,0,1,1007,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(117,'test-product-1773480233103',1,1,'修改产地',NULL,NULL,1,1,1001,'2026-03-14 17:23:53','2026-03-14 17:23:53',1001,1001,1),(118,'test-product-1773480272270',1,1,'修改产地',NULL,NULL,1,1,1001,'2026-03-14 17:24:32','2026-03-14 17:24:32',1001,1001,1),(119,'测试商品',1,1,'测试',NULL,NULL,1,1,1,'2026-04-02 16:36:28','2026-04-02 16:41:22',2009,2009,1),(120,'测试商品X-改',1,1,'测试',NULL,NULL,1,1,1001,'2026-04-02 16:42:05','2026-04-02 16:42:05',2009,2009,1),(121,'测试',3,2,'河南省','啊啊·','',1,1,1002,'2026-04-02 17:18:50','2026-04-02 17:18:57',2009,2009,0);
/*!40000 ALTER TABLE `biz_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_schedule`
--

DROP TABLE IF EXISTS `biz_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `producer_id` bigint NOT NULL,
  `type` tinyint NOT NULL COMMENT '1采收2配送',
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `location` varchar(128) NOT NULL,
  `route_plan` text,
  `order_id` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_sched_producer` (`producer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=710 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_schedule`
--

LOCK TABLES `biz_schedule` WRITE;
/*!40000 ALTER TABLE `biz_schedule` DISABLE KEYS */;
INSERT INTO `biz_schedule` (`id`, `producer_id`, `type`, `start_time`, `end_time`, `location`, `route_plan`, `order_id`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (701,1001,1,'2025-12-29 17:50:22','2025-12-29 17:50:22','修改基地','基地-仓库-装车',401,'2025-12-28 17:50:22','2026-03-14 17:23:53',NULL,1001,1),(702,1002,2,'2025-12-30 17:50:22','2025-12-30 17:50:22','烟台冷库','冷库-高速-配送点',402,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(703,1005,1,'2025-12-29 17:50:22','2025-12-29 17:50:22','昆明基地','基地-冷链-发货',405,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(704,1004,2,'2025-12-30 17:50:22','2025-12-30 17:50:22','南宁仓库','仓库-高速-广州',404,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(705,1007,2,'2025-12-31 17:50:22','2025-12-31 17:50:22','西安库房','库房-高速-杭州',406,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(706,1001,1,'2025-06-01 10:00:00','2025-06-01 12:00:00','修改基地',NULL,NULL,'2026-03-14 17:23:53','2026-03-14 17:24:32',1001,1001,1),(707,1001,1,'2025-06-01 10:00:00','2025-06-01 12:00:00','测试基地',NULL,NULL,'2026-03-14 17:24:32','2026-03-14 17:24:32',1001,1001,0),(708,1001,1,'2025-07-01 08:00:00','2025-07-01 18:00:00','田间',NULL,NULL,'2026-04-02 16:37:02','2026-04-02 16:37:02',2009,2009,0),(709,1001,1,'2025-07-01 08:00:00','2025-07-01 18:00:00','测试田间-改',NULL,NULL,'2026-04-02 16:42:31','2026-04-02 16:42:31',2009,2009,1);
/*!40000 ALTER TABLE `biz_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_trace_batch`
--

DROP TABLE IF EXISTS `biz_trace_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_trace_batch` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `batch_no` varchar(64) NOT NULL,
  `producer_id` bigint NOT NULL,
  `production_date` date DEFAULT NULL,
  `harvest_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `trace_info` text,
  `qr_code_url` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_trace_product` (`product_id`),
  KEY `idx_trace_producer` (`producer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=812 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_trace_batch`
--

LOCK TABLES `biz_trace_batch` WRITE;
/*!40000 ALTER TABLE `biz_trace_batch` DISABLE KEYS */;
INSERT INTO `biz_trace_batch` (`id`, `product_id`, `batch_no`, `producer_id`, `production_date`, `harvest_date`, `expiry_date`, `trace_info`, `qr_code_url`, `status`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (801,101,'BATCH-202501-01',1001,'2025-12-08','2025-12-18','2026-01-17','{\"farm\":\"郑州有机蔬菜基地\",\"pesticide\":\"零农药\",\"variety\":\"有机菠菜\",\"fertilizer\":\"生物有机肥\",\"soil\":\"沙壤土\",\"irrigation\":\"滴灌\",\"certification\":\"有机认证\",\"grade\":\"特级\"}','trace://batch/BATCH-202501-01',1,'2025-12-28 17:50:22','2026-03-14 17:23:53',NULL,2009,1),(802,104,'BATCH-202501-02',1003,'2025-12-03','2025-12-16','2026-01-15','{\"farm\":\"寿光基地\",\"pesticide\":\"低\"}','trace://batch/BATCH-202501-02',1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(803,109,'BATCH-202501-03',1005,'2025-12-13','2025-12-23','2026-01-07','{\"farm\":\"昆明高原草莓园\",\"pesticide\":\"低毒生物药\",\"variety\":\"红颜草莓\",\"fertilizer\":\"有机复合肥\",\"method\":\"大棚种植\",\"storage\":\"冷链保鲜\",\"grade\":\"精品级\"}','trace://batch/BATCH-202501-03',1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(804,110,'BATCH-202501-04',1004,'2025-12-10','2025-12-20','2026-01-09','{\"farm\":\"南宁柑橘基地\",\"pesticide\":\"零农药\",\"variety\":\"沃柑\",\"fertilizer\":\"有机肥\",\"method\":\"露天种植\",\"storage\":\"常温通风\",\"certification\":\"绿色食品认证\",\"grade\":\"一级\"}','trace://batch/BATCH-202501-04',1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(805,112,'BATCH-202501-05',1006,'2025-11-18','2025-11-28','2026-06-26','{\"farm\":\"东北产区\",\"pesticide\":\"0\"}','trace://batch/BATCH-202501-05',1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(806,101,'BATCH-TEST-1773480233381',1001,NULL,NULL,NULL,'{\"test\":\"联调\"}','trace://batch/BATCH-TEST-1773480233381',1,'2026-03-14 17:23:53','2026-03-14 17:24:32',2009,2009,1),(807,101,'BATCH-TEST-1773480272425',1001,NULL,NULL,NULL,'{\"test\":\"联调\"}','trace://batch/BATCH-TEST-1773480272425',1,'2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,0),(808,101,'BATCH-TEST-001',1001,'2025-06-01','2025-06-15','2025-12-01','测试','trace://batch/BATCH-TEST-001',1,'2026-04-02 16:36:43','2026-04-02 16:36:43',2009,2009,0),(809,101,'BATCH-TEST-X',1001,'2025-06-01','2025-06-15','2025-12-01','测试改','trace://batch/BATCH-TEST-X',1,'2026-04-02 16:42:31','2026-04-02 16:42:31',2009,2009,1),(810,102,'BATCH-202501-06',1002,'2025-12-05','2025-12-15','2026-02-15','{\"farm\":\"开封基地\",\"pesticide\":\"0\",\"variety\":\"红富士\",\"fertilizer\":\"有机肥\",\"storage\":\"冷链储藏\",\"grade\":\"精品级\"}','trace://batch/BATCH-202501-06',1,'2026-04-02 23:33:29','2026-04-02 23:33:29',NULL,NULL,0),(811,114,'BATCH-202501-07',1004,'2025-12-12','2025-12-22','2026-01-10','{\"farm\":\"南宁水产基地\",\"pesticide\":\"无\",\"variety\":\"罗非鱼\",\"method\":\"池塘养殖\",\"certification\":\"绿色食品认证\",\"storage\":\"活鲜运输\"}','trace://batch/BATCH-202501-07',1,'2026-04-02 23:33:29','2026-04-02 23:33:29',NULL,NULL,0);
/*!40000 ALTER TABLE `biz_trace_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_category`
--

DROP TABLE IF EXISTS `dict_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  `sort_no` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_cat_parent` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_category`
--

LOCK TABLES `dict_category` WRITE;
/*!40000 ALTER TABLE `dict_category` DISABLE KEYS */;
INSERT INTO `dict_category` (`id`, `name`, `parent_id`, `sort_no`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1,'蔬菜',NULL,1,'2025-12-28 17:50:22','2026-04-02 16:41:22',NULL,2009,0),(2,'水果',NULL,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(3,'粮油',NULL,3,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(4,'肉类',NULL,4,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(5,'水产',NULL,5,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(6,'叶菜类',1,1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(7,'根茎类',1,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(8,'柑橘类',2,1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(9,'瓜果类',2,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(10,'瓜菜类',1,3,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(11,'浆果类',2,3,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(12,'豆类',3,1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(13,'禽类',4,1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(14,'淡水鱼',5,1,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(15,'海水鱼',5,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(16,'test-cat-1773480233032',1,100,'2026-03-14 17:23:53','2026-03-14 17:23:53',2009,2009,1),(17,'test-cat-1773480272223',1,100,'2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,1),(18,'测试分类',0,99,'2026-04-02 16:36:15','2026-04-02 16:36:16',2009,2009,1),(19,'代理测试',0,88,'2026-04-02 16:40:47','2026-04-02 16:41:22',2009,2009,1),(20,'测试分类X-改',0,99,'2026-04-02 16:42:05','2026-04-02 16:42:05',2009,2009,1),(21,'代理测试',0,77,'2026-04-02 16:43:14','2026-04-02 16:43:15',2009,2009,1);
/*!40000 ALTER TABLE `dict_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_unit`
--

DROP TABLE IF EXISTS `dict_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `symbol` varchar(16) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_unit`
--

LOCK TABLES `dict_unit` WRITE;
/*!40000 ALTER TABLE `dict_unit` DISABLE KEYS */;
INSERT INTO `dict_unit` (`id`, `name`, `symbol`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1,'千克','kg','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2,'斤','斤','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(3,'吨','t','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(4,'箱','箱','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(5,'袋','袋','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(6,'件','件','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(7,'盒','盒','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(8,'筐','筐','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(9,'打','打','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(10,'test-unit-1773480233065','u2','2026-03-14 17:23:53','2026-03-14 17:23:53',2009,2009,1),(11,'test-unit-1773480272246','u2','2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,1),(12,'测试单位','TU','2026-04-02 16:36:28','2026-04-02 16:41:22',2009,2009,1),(13,'测试单位-改','T','2026-04-02 16:42:05','2026-04-02 16:42:05',2009,2009,1);
/*!40000 ALTER TABLE `dict_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msg_conversation`
--

DROP TABLE IF EXISTS `msg_conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msg_conversation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_a_id` bigint NOT NULL,
  `user_b_id` bigint NOT NULL,
  `last_message` varchar(255) DEFAULT NULL,
  `last_time` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_conv_a` (`user_a_id`),
  KEY `idx_conv_b` (`user_b_id`)
) ENGINE=InnoDB AUTO_INCREMENT=906 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msg_conversation`
--

LOCK TABLES `msg_conversation` WRITE;
/*!40000 ALTER TABLE `msg_conversation` DISABLE KEYS */;
INSERT INTO `msg_conversation` (`id`, `user_a_id`, `user_b_id`, `last_message`, `last_time`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (901,2001,1001,'收到，联调回复','2026-03-14 17:24:32','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2001,0),(902,2004,1004,'请确认价格和到货时间','2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(903,2005,1005,'草莓冷链费用怎么算？','2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(904,2006,1007,'香菇需几天内到货','2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(905,2010,2009,'1','2025-12-28 18:12:53','2025-12-28 18:04:47','2025-12-28 18:04:47',2010,2010,0);
/*!40000 ALTER TABLE `msg_conversation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msg_message`
--

DROP TABLE IF EXISTS `msg_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msg_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint NOT NULL,
  `sender_id` bigint NOT NULL,
  `content` text NOT NULL,
  `type` tinyint NOT NULL COMMENT '1文本2图片3文件',
  `read_flag` tinyint NOT NULL DEFAULT '0',
  `sent_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_msg_conv` (`conversation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1017 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msg_message`
--

LOCK TABLES `msg_message` WRITE;
/*!40000 ALTER TABLE `msg_message` DISABLE KEYS */;
INSERT INTO `msg_message` (`id`, `conversation_id`, `sender_id`, `content`, `type`, `read_flag`, `sent_at`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1001,901,2001,'请确认明日发货',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1002,901,1001,'已确认，明早装车',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1003,902,2004,'请确认价格和到货时间',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1004,902,1004,'价格已确认，2天内到货',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1005,903,2005,'草莓冷链费用怎么算？',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1006,903,1005,'按公里计费，可协商',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1007,904,2006,'香菇需几天内到货',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1008,904,1007,'72小时内到货',1,0,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1009,905,2010,'nihoa\n',1,0,'2025-12-28 18:04:47','2025-12-28 18:04:47','2025-12-28 18:04:47',2010,2010,0),(1010,905,2009,'你好呀',1,0,'2025-12-28 18:04:59','2025-12-28 18:04:59','2025-12-28 18:04:59',2009,2009,0),(1011,905,2010,'ene \n',1,0,'2025-12-28 18:12:43','2025-12-28 18:12:43','2025-12-28 18:12:43',2010,2010,0),(1012,905,2009,'1',1,0,'2025-12-28 18:12:53','2025-12-28 18:12:53','2025-12-28 18:12:53',2009,2009,0),(1013,901,2001,'联调测试消息',1,0,'2026-03-14 17:23:53','2026-03-14 17:23:53','2026-03-14 17:23:53',2001,2001,0),(1014,901,1001,'收到，联调回复',1,0,'2026-03-14 17:23:53','2026-03-14 17:23:53','2026-03-14 17:23:53',1001,1001,0),(1015,901,2001,'联调测试消息',1,0,'2026-03-14 17:24:32','2026-03-14 17:24:32','2026-03-14 17:24:32',2001,2001,0),(1016,901,1001,'收到，联调回复',1,0,'2026-03-14 17:24:32','2026-03-14 17:24:32','2026-03-14 17:24:32',1001,1001,0);
/*!40000 ALTER TABLE `msg_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_audit_record`
--

DROP TABLE IF EXISTS `sys_audit_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_audit_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `target_type` tinyint NOT NULL COMMENT '1发布2资质',
  `target_id` bigint NOT NULL,
  `status` tinyint NOT NULL COMMENT '1通过2驳回',
  `remark` varchar(255) DEFAULT NULL,
  `auditor_id` bigint NOT NULL,
  `audit_time` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_audit_record`
--

LOCK TABLES `sys_audit_record` WRITE;
/*!40000 ALTER TABLE `sys_audit_record` DISABLE KEYS */;
INSERT INTO `sys_audit_record` (`id`, `target_type`, `target_id`, `status`, `remark`, `auditor_id`, `audit_time`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1201,1,201,1,'信息完整，审核通过',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1202,2,1,1,'资质清晰，审核通过',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1203,1,205,1,'供给信息真实',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1204,1,206,1,'信息完整',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1205,2,1301,1,'资质有效',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1206,1,211,1,NULL,2009,'2025-12-28 17:53:55','2025-12-28 17:53:55','2025-12-28 17:53:55',2009,2009,0),(1207,1,213,1,'审核通过',2009,'2026-03-14 17:24:32','2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,0),(1208,2,1302,1,'审核通过',2009,'2026-03-14 17:24:32','2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,0),(1209,1,216,1,NULL,2009,'2026-04-02 16:42:32','2026-04-02 16:42:32','2026-04-02 16:42:32',2009,2009,0),(1210,2,1309,1,NULL,2009,'2026-04-02 16:42:58','2026-04-02 16:42:58','2026-04-02 16:42:58',2009,2009,0),(1211,1,201,1,NULL,2009,'2026-04-02 16:43:15','2026-04-02 16:43:15','2026-04-02 16:43:15',2009,2009,0),(1212,2,1301,1,NULL,2009,'2026-04-02 16:43:15','2026-04-02 16:43:15','2026-04-02 16:43:15',2009,2009,0),(1213,1,201,1,NULL,2009,'2026-04-02 17:15:54','2026-04-02 17:15:54','2026-04-02 17:15:54',2009,2009,0),(1214,2,1301,1,NULL,2009,'2026-04-02 17:15:54','2026-04-02 17:15:54','2026-04-02 17:15:54',2009,2009,0),(1215,1,218,1,NULL,2009,'2026-04-02 17:17:12','2026-04-02 17:17:12','2026-04-02 17:17:12',2009,2009,0),(1216,2,1302,1,NULL,2009,'2026-04-02 17:19:42','2026-04-02 17:19:42','2026-04-02 17:19:42',2009,2009,0),(1217,2,1302,2,NULL,2009,'2026-04-02 17:19:43','2026-04-02 17:19:43','2026-04-02 17:19:43',2009,2009,0),(1218,1,201,2,'商品信息不符合规范',2009,'2026-04-02 21:49:17','2026-04-02 21:49:17','2026-04-02 21:49:17',2009,2009,0);
/*!40000 ALTER TABLE `sys_audit_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_export_record`
--

DROP TABLE IF EXISTS `sys_export_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_export_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `exporter_id` bigint NOT NULL,
  `type` varchar(64) NOT NULL,
  `params` text,
  `file_name` varchar(128) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1生成中2完成3失败',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1405 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_export_record`
--

LOCK TABLES `sys_export_record` WRITE;
/*!40000 ALTER TABLE `sys_export_record` DISABLE KEYS */;
INSERT INTO `sys_export_record` (`id`, `exporter_id`, `type`, `params`, `file_name`, `file_url`, `status`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1401,1,'orders','{\"status\":2}','orders_demo.xlsx',NULL,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1402,1,'orders','{\"status\":3}','orders_demo_2.xlsx',NULL,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1403,1,'orders','{\"status\":4}','orders_demo_3.xlsx',NULL,2,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1404,2009,'orders',NULL,'orders_20260314172432.xlsx',NULL,2,'2026-03-14 17:24:33','2026-03-14 17:24:33',2009,2009,0);
/*!40000 ALTER TABLE `sys_export_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `content` text NOT NULL,
  `publish_status` tinyint NOT NULL DEFAULT '1' COMMENT '1草稿2发布',
  `publish_time` datetime DEFAULT NULL,
  `publisher_id` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` (`id`, `title`, `content`, `publish_status`, `publish_time`, `publisher_id`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1101,'平台升级通知','平台将在本周末进行升级维护。',2,'2025-12-28 17:50:22',NULL,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1102,'春节物流提醒','春节期间物流时效可能延迟，请提前安排。',2,'2026-04-02 17:15:54',NULL,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0),(1103,'冷链运输说明','冷链订单请在备注中注明温控要求。',2,'2025-12-28 17:50:22',NULL,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1104,'资质审核提示','上传资质请确保清晰可读。',2,'2025-12-28 17:50:22',NULL,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1105,'test-notice-1773480233436','修改公告内容',2,'2026-03-14 17:23:53',2009,'2026-03-14 17:23:53','2026-03-14 17:23:53',2009,2009,1),(1106,'test-notice-1773480272459','修改公告内容',2,'2026-03-14 17:24:32',2009,'2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,1),(1107,'测试公告 1','公告内容',1,NULL,2009,'2026-04-02 16:37:28','2026-04-02 17:08:34',2009,2009,0),(1108,'测试公告X-改','改',2,'2026-04-02 16:42:59',2009,'2026-04-02 16:42:59','2026-04-02 16:42:59',2009,2009,1);
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_qualification`
--

DROP TABLE IF EXISTS `sys_qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_qualification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `type` varchar(64) NOT NULL,
  `number` varchar(128) NOT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1待审 2通过 3驳回',
  `remark` varchar(255) DEFAULT NULL,
  `audit_by` bigint DEFAULT NULL,
  `audit_time` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_qual_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1310 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_qualification`
--

LOCK TABLES `sys_qualification` WRITE;
/*!40000 ALTER TABLE `sys_qualification` DISABLE KEYS */;
INSERT INTO `sys_qualification` (`id`, `user_id`, `type`, `number`, `file_url`, `status`, `remark`, `audit_by`, `audit_time`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1301,1001,'营业执照','91370100MA3XXXXXXX',NULL,2,'审核通过',2009,'2026-04-02 17:15:54','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0),(1302,2001,'采购资质','PQ-2025-0001',NULL,3,'审核通过',2009,'2026-04-02 17:19:43','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,2009,0),(1303,1004,'营业执照','91440101MA3YYYYYYY',NULL,2,'审核通过',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1304,1005,'产地证明','CZ-2025-002',NULL,1,NULL,NULL,NULL,'2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1305,2006,'采购资质','PQ-2025-0006',NULL,2,'审核通过',1,'2025-12-28 17:50:22','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1306,1001,'食品安全证书','QA-TEST-1773480233410',NULL,1,NULL,NULL,NULL,'2026-03-14 17:23:53','2026-03-14 17:23:53',1001,1001,0),(1307,1001,'食品安全证书','QA-TEST-1773480272442',NULL,1,NULL,NULL,NULL,'2026-03-14 17:24:32','2026-03-14 17:24:32',1001,1001,0),(1308,2009,'营业执照','BL12345','http://example.com/file.pdf',1,NULL,NULL,NULL,'2026-04-02 16:37:28','2026-04-02 16:37:28',2009,2009,0),(1309,2009,'营业执照','TEST-001-改','http://test.com/f.pdf',2,NULL,2009,'2026-04-02 16:42:58','2026-04-02 16:42:58','2026-04-02 16:42:58',2009,2009,0);
/*!40000 ALTER TABLE `sys_qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` tinyint NOT NULL COMMENT '1管理员 2生产方 3采购方',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用 2禁用',
  `real_name` varchar(64) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `gender` tinyint DEFAULT NULL COMMENT '0未知 1男 2女',
  `address` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_username` (`username`),
  KEY `idx_user_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=2017 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` (`id`, `username`, `password`, `role`, `status`, `real_name`, `avatar`, `gender`, `address`, `created_at`, `updated_at`, `created_by`, `updated_by`, `deleted`) VALUES (1001,'producer01','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'郑丽',NULL,2,'河南郑州','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1002,'producer02','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'王强',NULL,1,'河南开封','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1003,'producer03','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'赵敏',NULL,2,'山东寿光','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1004,'producer04','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'郭涛',NULL,1,'广西南宁','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1005,'producer05','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'沈芳',NULL,2,'云南昆明','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1006,'producer06','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'马超',NULL,1,'吉林长春','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1007,'producer07','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'孙慧',NULL,2,'陕西西安','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(1008,'producer08','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',2,1,'蒋明',NULL,1,'四川成都','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2001,'buyer01','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'李晨',NULL,1,'河南郑州','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2002,'buyer02','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'周杰',NULL,1,'北京朝阳','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2003,'buyer03','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'林雨',NULL,2,'上海浦东','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2004,'buyer04','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'许晨',NULL,1,'广州天河','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2005,'buyer05','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'唐婧',NULL,2,'深圳南山','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2006,'buyer06','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'邵军',NULL,1,'杭州西湖','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2007,'buyer07','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'吴楠',NULL,2,'南京鼓楼','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2008,'buyer08','$2a$10$vxbGczv6Lncp1t6WA5dvm.FZfjweM6nz5VEUEgmLq6sPTSlvlxJpy',3,1,'范浩',NULL,1,'厦门思明','2025-12-28 17:50:22','2025-12-28 17:50:22',NULL,NULL,0),(2009,'admin','$2a$10$KquPsU0nrFwUOXb/YloAtuH80qW4UuKW0EUZFwgAZvk2WQYONOZx.',1,1,'系统管理员',NULL,NULL,NULL,'2025-12-28 17:50:41','2025-12-28 17:50:41',NULL,NULL,0),(2010,'c1','$2a$10$qM3O73w6yXjqvulQOfEOZO3XHMYhsg27Y7.H.riqHE13QzjVD8NbK',3,1,'秋明',NULL,NULL,NULL,'2025-12-28 17:52:23','2025-12-28 17:52:23',NULL,NULL,0),(2011,'test-user-1773480232900','$2a$10$IxmiEbrxQ0PzTZcQeh/uCeXfJAx9IfhBoUKgZ3U8IbuXV5b5PL8ky',2,1,'测试修改',NULL,NULL,NULL,'2026-03-14 17:23:53','2026-03-14 17:23:53',2009,2009,1),(2012,'test-user-1773480272123','$2a$10$F8lqcu81P0sXLzOQG6nT7O/iIQAUEtnpsLDWaoqJoFk8w4Ku1FuD2',2,1,'测试修改',NULL,NULL,NULL,'2026-03-14 17:24:32','2026-03-14 17:24:32',2009,2009,1),(2013,'test-reg-1773480272517','$2a$10$biQ3wz5yjOs1ruo8jxUP4.YdRdFjhGWYfCbcaRa.6Ev2PanMmAUWy',2,1,'注册测试',NULL,NULL,NULL,'2026-03-14 17:24:33','2026-03-14 17:24:33',NULL,NULL,0),(2014,'testuser999','$2a$10$skSr9Eobk23kX.8M/ckqZO7maSNoYl3DcHH7QfMbWWDxb4WUNzdgO',2,1,'测试用户',NULL,NULL,NULL,'2026-04-02 16:36:29','2026-04-02 16:41:22',2009,2009,1),(2015,'testxyz','$2a$10$la/ezpOd8h5PQeBOfcCv/OTirKy7TCn19RhZLPDjyNAwIC0Psk3fu',2,1,'测试改',NULL,NULL,NULL,'2026-04-02 16:42:05','2026-04-02 16:42:05',2009,2009,1),(2016,'a','$2a$10$rsbCoCHrMoNcPlPzBy0oSeit7faItxKzjpIfJCk4i31I7LQIIH6aK',2,1,'a',NULL,NULL,NULL,'2026-04-02 23:46:48','2026-04-02 23:46:48',NULL,NULL,0);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-03  1:03:45
