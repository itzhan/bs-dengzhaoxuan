# 农产品产销对接管理系统 API 文档

## 概览
- Base URL: `/api`
- Auth: JWT（请求头 `Authorization: Bearer <token>`）
- Content-Type: application/json
- 分页参数：`page`(默认1), `size`(默认10)

## 统一返回
```json
{ "code": 200, "message": "成功", "data": {} }
```

## 认证
### 注册
- POST `/auth/register`
- Body:
```json
{"username":"buyer01","password":"123456","role":3,"realName":"张三"}
```

### 登录
- POST `/auth/login`
- Body:
```json
{"username":"buyer01","password":"123456"}
```
- Response:
```json
{"code":200,"message":"成功","data":{"token":"...","userId":1,"username":"buyer01","role":"BUYER"}}
```

### 当前用户
- GET `/auth/me`

## 用户（管理员）
- GET `/users`
- GET `/users/{id}`
- POST `/users`
- PUT `/users/{id}`
- DELETE `/users/{id}`

## 资质审核
- GET `/qualifications`
- POST `/qualifications`
- PUT `/qualifications/{id}`
- POST `/qualifications/{id}/audit`（管理员）

## 分类与单位
- GET `/categories`
- POST `/categories`（管理员）
- PUT `/categories/{id}`（管理员）
- DELETE `/categories/{id}`（管理员）

- GET `/units`
- POST `/units`（管理员）
- PUT `/units/{id}`（管理员）
- DELETE `/units/{id}`（管理员）

## 商品
- GET `/products`
- POST `/products`
- PUT `/products/{id}`
- DELETE `/products/{id}`

## 信息发布（供给/求购）
- GET `/listings`
- GET `/listings/{id}`
- POST `/listings`
- PUT `/listings/{id}`
- DELETE `/listings/{id}`
- POST `/listings/{id}/audit`（管理员）
> 求购信息需填写 contactName、contactPhone

## 库存
- GET `/inventories`
- POST `/inventories`
- PUT `/inventories/{id}`
- DELETE `/inventories/{id}`

## 订单
- GET `/orders`
- GET `/orders/{id}`
- POST `/orders`
- POST `/orders/{id}/status?status=2`

## 售后
- GET `/after-sales`
- POST `/after-sales`
- POST `/after-sales/{id}/audit?status=2`

## 日程
- GET `/schedules`
- POST `/schedules`
- PUT `/schedules/{id}`
- DELETE `/schedules/{id}`

## 溯源
- GET `/traces`
- GET `/traces/by-batch/{batchNo}`
- POST `/traces`
- PUT `/traces/{id}`
- DELETE `/traces/{id}`

## 站内消息
- GET `/conversations`
- GET `/conversations/{id}/messages`
- POST `/messages`

## 客服
- GET `/support/agent`

## 公告
- GET `/notices`
- POST `/notices`（管理员）
- PUT `/notices/{id}`（管理员）
- POST `/notices/{id}/publish`（管理员）
- DELETE `/notices/{id}`（管理员）

## 审核记录
- GET `/audits`（管理员）

## 统计与导出
- GET `/stats/overview`
- GET `/exports/orders`
