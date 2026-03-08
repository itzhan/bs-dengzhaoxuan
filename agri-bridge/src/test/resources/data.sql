MERGE INTO biz_listing (id, type, title, product_id, quantity, unit_id, price, location, description, contact_name, contact_phone, status, publisher_id, created_at, updated_at, deleted)
KEY (id)
VALUES (1, 1, '测试供给', NULL, 100.00, 1, 10.00, '郑州', '测试描述', NULL, NULL, 2, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0);
