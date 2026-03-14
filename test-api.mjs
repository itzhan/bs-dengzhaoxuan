#!/usr/bin/env node
/*
 * 农产品产销对接管理系统 — 前后端联调全量测试脚本
 *
 * 功能：
 *   1. 多角色登录验证（管理员 / 生产方 / 采购方）
 *   2. 全部 20 个 Controller、60+ 个 API 端点覆盖
 *   3. 完整业务流转：商品→发布→订单→状态变更→售后→审核
 *   4. 后端直连 + 前端代理双通道验证
 *
 * 使用方式：
 *   node test-api.mjs                         # 测试后端 localhost:8080
 *   ADMIN_BASE=http://localhost:3006 node test-api.mjs  # 额外测试管理后台代理
 */

const BACKEND = process.env.API_BASE || 'http://localhost:8080'
const ADMIN_PROXY = process.env.ADMIN_BASE || '' // 管理后台代理地址
const FRONT_PROXY = process.env.FRONT_BASE || '' // 用户前台代理地址

// ────────── 工具函数 ──────────
let passCount = 0
let failCount = 0
let skipCount = 0
const failures = []

const COLORS = {
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
  bold: '\x1b[1m',
  reset: '\x1b[0m',
  dim: '\x1b[2m',
}

function log(msg) {
  process.stdout.write(`${msg}\n`)
}

function pass(step) {
  passCount++
  log(`  ${COLORS.green}✓${COLORS.reset} ${step}`)
}

function fail(step, err) {
  failCount++
  const msg = err?.message || String(err)
  failures.push({ step, msg })
  log(`  ${COLORS.red}✗ ${step}${COLORS.reset}  →  ${COLORS.dim}${msg.slice(0, 120)}${COLORS.reset}`)
}

function skip(step, reason) {
  skipCount++
  log(`  ${COLORS.yellow}⊘ ${step}${COLORS.reset}  →  ${reason}`)
}

function section(title) {
  log(`\n${COLORS.cyan}${COLORS.bold}── ${title} ${'─'.repeat(50 - title.length)}${COLORS.reset}`)
}

async function request(method, path, body, token, base = BACKEND) {
  const url = `${base}${path}`
  const headers = { 'Content-Type': 'application/json' }
  if (token) headers.Authorization = `Bearer ${token}`
  const options = { method, headers }
  if (body !== undefined) options.body = JSON.stringify(body)

  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 15000)
  options.signal = controller.signal
  let res
  try {
    res = await fetch(url, options)
  } finally {
    clearTimeout(timeout)
  }
  const text = await res.text()
  let json
  try {
    json = text ? JSON.parse(text) : null
  } catch {
    json = null
  }
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} ${path} → ${text.slice(0, 200)}`)
  }
  return json
}

async function run(step, fn) {
  try {
    const res = await fn()
    pass(step)
    return res
  } catch (err) {
    fail(step, err)
    return null
  }
}

function pickId(resp) {
  const records = resp?.data?.records
  return Array.isArray(records) && records.length > 0 ? records[0].id : null
}

// ────────── 登录辅助 ──────────
async function login(username, password = '123456') {
  const res = await request('POST', '/api/auth/login', { username, password })
  return res?.data?.token
}

// ════════════════════════════════════════
//  主测试流程
// ════════════════════════════════════════
async function main() {
  log(`${COLORS.bold}╔══════════════════════════════════════════════════════════╗${COLORS.reset}`)
  log(`${COLORS.bold}║   🧪 农产品产销对接管理系统 — 前后端联调全量测试        ║${COLORS.reset}`)
  log(`${COLORS.bold}╚══════════════════════════════════════════════════════════╝${COLORS.reset}`)
  log(`${COLORS.dim}Backend: ${BACKEND}${COLORS.reset}`)
  if (ADMIN_PROXY) log(`${COLORS.dim}Admin Proxy: ${ADMIN_PROXY}${COLORS.reset}`)
  if (FRONT_PROXY) log(`${COLORS.dim}Front Proxy: ${FRONT_PROXY}${COLORS.reset}`)

  // ═══════════════════════════
  //  0. 健康检查
  // ═══════════════════════════
  section('0. 健康检查')
  await run('GET /api/health', () => request('GET', '/api/health'))

  // ═══════════════════════════
  //  1. 多角色登录
  // ═══════════════════════════
  section('1. 多角色登录')

  let adminToken = null
  let producerToken = null
  let buyerToken = null

  const adminLogin = await run('管理员登录 (admin/123456)', () =>
    request('POST', '/api/auth/login', { username: 'admin', password: '123456' })
  )
  adminToken = adminLogin?.data?.token
  if (!adminToken) fail('adminToken', '管理员 token 获取失败，后续测试将受影响')

  const producerLogin = await run('生产方登录 (producer01/123456)', () =>
    request('POST', '/api/auth/login', { username: 'producer01', password: '123456' })
  )
  producerToken = producerLogin?.data?.token
  if (!producerToken) fail('producerToken', '生产方 token 获取失败')

  const buyerLogin = await run('采购方登录 (buyer01/123456)', () =>
    request('POST', '/api/auth/login', { username: 'buyer01', password: '123456' })
  )
  buyerToken = buyerLogin?.data?.token
  if (!buyerToken) fail('buyerToken', '采购方 token 获取失败')

  // /auth/me 三角色
  await run('管理员 /auth/me', () => request('GET', '/api/auth/me', undefined, adminToken))
  await run('生产方 /auth/me', () => request('GET', '/api/auth/me', undefined, producerToken))
  await run('采购方 /auth/me', () => request('GET', '/api/auth/me', undefined, buyerToken))

  // ═══════════════════════════
  //  2. 用户管理 (ADMIN CRUD)
  // ═══════════════════════════
  section('2. 用户管理 (admin)')

  await run('用户列表', () => request('GET', '/api/users?page=1&size=5', undefined, adminToken))
  await run('用户详情 (id=1001)', () => request('GET', '/api/users/1001', undefined, adminToken))

  const testUserName = `test-user-${Date.now()}`
  const createUser = await run('创建用户', () =>
    request('POST', '/api/users', {
      username: testUserName,
      password: '123456',
      role: 2,
      status: 1,
      realName: '测试用户',
    }, adminToken)
  )
  // 查找刚创建的用户
  const userList = await run('搜索用户', () =>
    request('GET', `/api/users?page=1&size=5&keyword=${encodeURIComponent(testUserName)}`, undefined, adminToken)
  )
  const testUserId = pickId(userList)
  if (testUserId) {
    await run('更新用户', () =>
      request('PUT', `/api/users/${testUserId}`, { realName: '测试修改' }, adminToken)
    )
    await run('删除用户', () =>
      request('DELETE', `/api/users/${testUserId}`, undefined, adminToken)
    )
  } else {
    skip('用户更新/删除', '未获取到测试用户ID')
  }

  // ═══════════════════════════
  //  3. 分类 CRUD
  // ═══════════════════════════
  section('3. 分类 CRUD')

  await run('分类列表', () => request('GET', '/api/categories?page=1&size=10', undefined, adminToken))

  const catName = `test-cat-${Date.now()}`
  await run('创建分类', () =>
    request('POST', '/api/categories', { name: catName, parentId: 1, sortNo: 99 }, adminToken)
  )
  const catList = await run('搜索分类', () =>
    request('GET', `/api/categories?page=1&size=5&keyword=${encodeURIComponent(catName)}`, undefined, adminToken)
  )
  const catId = pickId(catList)
  if (catId) {
    await run('更新分类', () => request('PUT', `/api/categories/${catId}`, { sortNo: 100 }, adminToken))
    await run('删除分类', () => request('DELETE', `/api/categories/${catId}`, undefined, adminToken))
  } else {
    skip('分类更新/删除', '未获取到分类ID')
  }

  // ═══════════════════════════
  //  4. 计量单位 CRUD
  // ═══════════════════════════
  section('4. 计量单位 CRUD')

  await run('单位列表', () => request('GET', '/api/units?page=1&size=10', undefined, adminToken))

  const unitName = `test-unit-${Date.now()}`
  await run('创建单位', () => request('POST', '/api/units', { name: unitName, symbol: 'u' }, adminToken))
  const unitList = await run('搜索单位', () =>
    request('GET', `/api/units?page=1&size=5&keyword=${encodeURIComponent(unitName)}`, undefined, adminToken)
  )
  const unitId = pickId(unitList)
  if (unitId) {
    await run('更新单位', () => request('PUT', `/api/units/${unitId}`, { symbol: 'u2' }, adminToken))
    await run('删除单位', () => request('DELETE', `/api/units/${unitId}`, undefined, adminToken))
  } else {
    skip('单位更新/删除', '未获取到单位ID')
  }

  // ═══════════════════════════
  //  5. 商品管理（生产方视角）
  // ═══════════════════════════
  section('5. 商品管理 (producer)')

  await run('商品列表', () => request('GET', '/api/products?page=1&size=5', undefined, producerToken))
  await run('按分类筛选商品', () => request('GET', '/api/products?page=1&size=5&categoryId=1', undefined, producerToken))

  const prodName = `test-product-${Date.now()}`
  await run('生产方创建商品', () =>
    request('POST', '/api/products', {
      name: prodName,
      categoryId: 1,
      unitId: 1,
      origin: '测试产地',
      traceable: 1,
      status: 1,
    }, producerToken)
  )
  const prodList = await run('搜索商品', () =>
    request('GET', `/api/products?page=1&size=5&keyword=${encodeURIComponent(prodName)}`, undefined, producerToken)
  )
  const prodId = pickId(prodList)
  if (prodId) {
    await run('生产方更新商品', () =>
      request('PUT', `/api/products/${prodId}`, { origin: '修改产地' }, producerToken)
    )
    // admin也能看到
    await run('管理员查看商品列表', () => request('GET', '/api/products?page=1&size=5', undefined, adminToken))
    await run('生产方删除商品', () =>
      request('DELETE', `/api/products/${prodId}`, undefined, producerToken)
    )
  } else {
    skip('商品更新/删除', '未获取到商品ID')
  }

  // ═══════════════════════════
  //  6. 信息发布（供给/求购 + 审核）
  // ═══════════════════════════
  section('6. 信息发布 + 审核')

  await run('发布列表', () => request('GET', '/api/listings?page=1&size=5', undefined, adminToken))
  await run('发布详情 (id=201)', () => request('GET', '/api/listings/201', undefined, adminToken))
  await run('按类型筛选(供给)', () => request('GET', '/api/listings?page=1&size=5&type=1', undefined, adminToken))

  const listingTitle = `test-listing-${Date.now()}`
  // 生产方发布供给信息
  await run('生产方发布供给', () =>
    request('POST', '/api/listings', {
      type: 1,
      title: listingTitle,
      quantity: 100,
      unitId: 1,
      price: 9.9,
      location: '测试',
      description: '测试供给信息',
    }, producerToken)
  )
  const listingList = await run('搜索发布', () =>
    request('GET', `/api/listings?page=1&size=5&keyword=${encodeURIComponent(listingTitle)}`, undefined, adminToken)
  )
  const listingId = pickId(listingList)
  if (listingId) {
    await run('更新发布', () => request('PUT', `/api/listings/${listingId}`, { price: 8.8 }, producerToken))
    await run('管理员审核发布', () =>
      request('POST', `/api/listings/${listingId}/audit`, { status: 2, remark: '审核通过' }, adminToken)
    )
    await run('删除发布', () => request('DELETE', `/api/listings/${listingId}`, undefined, adminToken))
  } else {
    skip('发布更新/审核/删除', '未获取到发布ID')
  }

  // ═══════════════════════════
  //  7. 库存管理（生产方视角）
  // ═══════════════════════════
  section('7. 库存管理 (producer)')

  await run('库存列表', () => request('GET', '/api/inventories?page=1&size=5', undefined, producerToken))

  await run('创建库存', () =>
    request('POST', '/api/inventories', {
      producerId: 1001,
      productId: 101,
      quantity: 50,
      unitId: 2,
      location: '测试仓库',
    }, producerToken)
  )
  const invList = await run('查询库存', () =>
    request('GET', '/api/inventories?page=1&size=5', undefined, producerToken)
  )
  const invId = pickId(invList)
  if (invId) {
    await run('更新库存', () => request('PUT', `/api/inventories/${invId}`, { quantity: 80 }, producerToken))
    await run('删除库存', () => request('DELETE', `/api/inventories/${invId}`, undefined, producerToken))
  } else {
    skip('库存更新/删除', '未获取到库存ID')
  }

  // ═══════════════════════════
  //  8. 订单完整流转（采购方→生产方→管理员）
  // ═══════════════════════════
  section('8. 订单完整流转')

  await run('订单列表 (admin)', () => request('GET', '/api/orders?page=1&size=5', undefined, adminToken))
  await run('订单详情 (id=401)', () => request('GET', '/api/orders/401', undefined, adminToken))
  await run('按状态筛选订单', () => request('GET', '/api/orders?page=1&size=5&status=2', undefined, adminToken))

  // 采购方创建订单
  const createOrder = await run('采购方创建订单', () =>
    request('POST', '/api/orders', {
      sellerId: 1001,
      deliveryAddress: '测试地址',
      contactName: '测试人',
      remark: '联调测试订单',
      items: [
        {
          productId: 101,
          productName: '有机菠菜',
          quantity: 10,
          unitId: 2,
          price: 4.8,
        },
      ],
    }, buyerToken)
  )
  const orderId = createOrder?.data
  if (orderId) {
    await run('订单详情(新)', () => request('GET', `/api/orders/${orderId}`, undefined, buyerToken))
    // 生产方确认订单 (status=2 已确认)
    await run('生产方确认订单', () =>
      request('POST', `/api/orders/${orderId}/status?status=2`, undefined, producerToken)
    )
    // 生产方配送中 (status=3)
    await run('生产方发货(配送中)', () =>
      request('POST', `/api/orders/${orderId}/status?status=3`, undefined, producerToken)
    )
    // 采购方确认收货 (status=4 已送达)
    await run('采购方确认收货', () =>
      request('POST', `/api/orders/${orderId}/status?status=4`, undefined, buyerToken)
    )
    // 订单完成 (status=5)
    await run('订单完成', () =>
      request('POST', `/api/orders/${orderId}/status?status=5`, undefined, buyerToken)
    )
  } else {
    skip('订单流转', '订单创建失败')
  }

  // ═══════════════════════════
  //  9. 售后 + 审核
  // ═══════════════════════════
  section('9. 售后 + 审核')

  await run('售后列表', () => request('GET', '/api/after-sales?page=1&size=5', undefined, adminToken))

  // 采购方创建售后
  const afterSaleCreate = await run('采购方创建售后', () =>
    request('POST', '/api/after-sales', {
      orderId: 401,
      sellerId: 1001,
      type: 1,
      reason: '联调测试退款',
      amount: 10.0,
    }, buyerToken)
  )
  // 查找售后记录
  const asList = await run('售后列表(查找)', () =>
    request('GET', '/api/after-sales?page=1&size=5&status=1', undefined, adminToken)
  )
  const asId = pickId(asList)
  if (asId) {
    await run('管理员审核售后(通过)', () =>
      request('POST', `/api/after-sales/${asId}/audit?status=2`, undefined, adminToken)
    )
  } else {
    skip('售后审核', '未获取到售后ID')
  }

  // ═══════════════════════════
  //  10. 日程管理
  // ═══════════════════════════
  section('10. 日程管理')

  await run('日程列表', () => request('GET', '/api/schedules?page=1&size=5', undefined, producerToken))

  await run('创建日程', () =>
    request('POST', '/api/schedules', {
      producerId: 1001,
      type: 1,
      startTime: '2025-06-01 10:00:00',
      endTime: '2025-06-01 12:00:00',
      location: '测试基地',
    }, producerToken)
  )
  const scheList = await run('查询日程', () =>
    request('GET', '/api/schedules?page=1&size=5', undefined, producerToken)
  )
  const scheId = pickId(scheList)
  if (scheId) {
    await run('更新日程', () => request('PUT', `/api/schedules/${scheId}`, { location: '修改基地' }, producerToken))
    await run('删除日程', () => request('DELETE', `/api/schedules/${scheId}`, undefined, producerToken))
  } else {
    skip('日程更新/删除', '未获取到日程ID')
  }

  // ═══════════════════════════
  //  11. 溯源批次 + 按批次号查询
  // ═══════════════════════════
  section('11. 溯源批次')

  await run('溯源列表', () => request('GET', '/api/traces?page=1&size=5', undefined, adminToken))
  await run('按商品ID筛选溯源', () => request('GET', '/api/traces?page=1&size=5&productId=101', undefined, adminToken))
  await run('按批次号查询', () => request('GET', '/api/traces/by-batch/BATCH-202501-01', undefined, adminToken))

  const batchNo = `BATCH-TEST-${Date.now()}`
  await run('创建溯源批次', () =>
    request('POST', '/api/traces', {
      productId: 101,
      producerId: 1001,
      batchNo,
      traceInfo: '{"test":"联调"}',
    }, adminToken)
  )
  const traceList = await run('搜索溯源', () =>
    request('GET', '/api/traces?page=1&size=5&productId=101', undefined, adminToken)
  )
  const traceId = pickId(traceList)
  if (traceId) {
    await run('更新溯源', () => request('PUT', `/api/traces/${traceId}`, { status: 1 }, adminToken))
    await run('删除溯源', () => request('DELETE', `/api/traces/${traceId}`, undefined, adminToken))
  } else {
    skip('溯源更新/删除', '未获取到溯源ID')
  }

  // ═══════════════════════════
  //  12. 资质管理 + 审核
  // ═══════════════════════════
  section('12. 资质管理 + 审核')

  await run('资质列表', () => request('GET', '/api/qualifications?page=1&size=5', undefined, adminToken))

  // 生产方提交资质
  await run('生产方提交资质', () =>
    request('POST', '/api/qualifications', {
      userId: 1001,
      type: '食品安全证书',
      number: `QA-TEST-${Date.now()}`,
    }, producerToken)
  )
  const qualList = await run('查询资质', () =>
    request('GET', '/api/qualifications?page=1&size=5&status=1', undefined, adminToken)
  )
  const qualId = pickId(qualList)
  if (qualId) {
    await run('管理员审核资质(通过)', () =>
      request('POST', `/api/qualifications/${qualId}/audit`, { status: 2, remark: '审核通过' }, adminToken)
    )
  } else {
    skip('资质审核', '未获取到资质ID')
  }

  // ═══════════════════════════
  //  13. 公告管理（创建→发布→删除）
  // ═══════════════════════════
  section('13. 公告管理')

  await run('公告列表', () => request('GET', '/api/notices?page=1&size=5', undefined, adminToken))

  const noticeTitle = `test-notice-${Date.now()}`
  await run('创建公告', () =>
    request('POST', '/api/notices', { title: noticeTitle, content: '联调测试公告内容' }, adminToken)
  )
  const noticeList = await run('搜索公告', () =>
    request('GET', `/api/notices?page=1&size=5&keyword=${encodeURIComponent(noticeTitle)}`, undefined, adminToken)
  )
  const noticeId = pickId(noticeList)
  if (noticeId) {
    await run('更新公告', () =>
      request('PUT', `/api/notices/${noticeId}`, { content: '修改公告内容' }, adminToken)
    )
    await run('发布公告', () => request('POST', `/api/notices/${noticeId}/publish`, undefined, adminToken))
    await run('删除公告', () => request('DELETE', `/api/notices/${noticeId}`, undefined, adminToken))
  } else {
    skip('公告更新/发布/删除', '未获取到公告ID')
  }

  // ═══════════════════════════
  //  14. 站内消息 + 会话
  // ═══════════════════════════
  section('14. 站内消息 + 会话')

  // 采购方给生产方发消息
  await run('采购方发送消息', () =>
    request('POST', '/api/messages', { toUserId: 1001, content: '联调测试消息', type: 1 }, buyerToken)
  )
  // 生产方给采购方回复
  await run('生产方回复消息', () =>
    request('POST', '/api/messages', { toUserId: 2001, content: '收到，联调回复', type: 1 }, producerToken)
  )

  // 会话列表
  const convList = await run('会话列表 (buyer)', () =>
    request('GET', '/api/conversations?page=1&size=5', undefined, buyerToken)
  )
  const convId = pickId(convList)
  if (convId) {
    await run('会话消息列表', () =>
      request('GET', `/api/conversations/${convId}/messages?page=1&size=20`, undefined, buyerToken)
    )
  } else {
    skip('会话消息列表', '无会话记录')
  }

  // 管理员也能看
  await run('会话列表 (admin)', () =>
    request('GET', '/api/conversations?page=1&size=5', undefined, adminToken)
  )

  // ═══════════════════════════
  //  15. 客服支持
  // ═══════════════════════════
  section('15. 客服支持')
  await run('获取客服信息', () => request('GET', '/api/support/agent', undefined, buyerToken))

  // ═══════════════════════════
  //  16. 审核记录
  // ═══════════════════════════
  section('16. 审核记录')
  await run('审核记录列表', () => request('GET', '/api/audits?page=1&size=10', undefined, adminToken))

  // ═══════════════════════════
  //  17. 统计数据
  // ═══════════════════════════
  section('17. 统计数据')
  await run('统计概览', () => request('GET', '/api/stats/overview', undefined, adminToken))

  // ═══════════════════════════
  //  18. 数据导出
  // ═══════════════════════════
  section('18. 数据导出')
  await run('导出订单(xlsx)', async () => {
    const url = `${BACKEND}/api/exports/orders`
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${adminToken}` },
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const ct = res.headers.get('content-type') || ''
    if (!ct.includes('spreadsheet') && !ct.includes('octet')) {
      throw new Error(`期望 xlsx 文件，实际 Content-Type: ${ct}`)
    }
    return { status: res.status, contentType: ct }
  })

  // ═══════════════════════════
  //  19. 注册新用户
  // ═══════════════════════════
  section('19. 注册流程')
  const newUsername = `test-reg-${Date.now()}`
  await run('注册新生产方', () =>
    request('POST', '/api/auth/register', {
      username: newUsername,
      password: '123456',
      role: 2,
      realName: '注册测试',
    })
  )
  await run('新用户登录', () =>
    request('POST', '/api/auth/login', { username: newUsername, password: '123456' })
  )
  await run('重复注册应失败', async () => {
    try {
      await request('POST', '/api/auth/register', {
        username: newUsername,
        password: '123456',
        role: 2,
        realName: '重复',
      })
      throw new Error('期望报错但成功了')
    } catch (e) {
      if (e.message.includes('期望报错')) throw e
      // 预期 409 Conflict，测试通过
      return { ok: true }
    }
  })

  // ═══════════════════════════
  //  20. 前端代理转发验证
  // ═══════════════════════════
  if (ADMIN_PROXY) {
    section('20a. 管理后台代理验证')
    await run('管理后台 → /api/auth/login', () =>
      request('POST', '/api/auth/login', { username: 'admin', password: '123456' }, undefined, ADMIN_PROXY)
    )
    await run('管理后台 → /api/products', () =>
      request('GET', '/api/products?page=1&size=3', undefined, adminToken, ADMIN_PROXY)
    )
    await run('管理后台 → /api/stats/overview', () =>
      request('GET', '/api/stats/overview', undefined, adminToken, ADMIN_PROXY)
    )
  }

  if (FRONT_PROXY) {
    section('20b. 用户前台代理验证')
    await run('用户前台 → /api/auth/login', () =>
      request('POST', '/api/auth/login', { username: 'buyer01', password: '123456' }, undefined, FRONT_PROXY)
    )
    await run('用户前台 → /api/products', () =>
      request('GET', '/api/products?page=1&size=3', undefined, buyerToken, FRONT_PROXY)
    )
  }

  // ════════════════════════════════════════
  //  结果汇总
  // ════════════════════════════════════════
  log('')
  log(`${COLORS.bold}╔══════════════════════════════════════════════════════════╗${COLORS.reset}`)
  log(`${COLORS.bold}║                    📊 测试结果汇总                      ║${COLORS.reset}`)
  log(`${COLORS.bold}╠══════════════════════════════════════════════════════════╣${COLORS.reset}`)
  log(`${COLORS.bold}║  ${COLORS.green}通过: ${String(passCount).padEnd(6)}${COLORS.reset}${COLORS.bold}  ${COLORS.red}失败: ${String(failCount).padEnd(6)}${COLORS.reset}${COLORS.bold}  ${COLORS.yellow}跳过: ${String(skipCount).padEnd(6)}${COLORS.reset}${COLORS.bold}            ║${COLORS.reset}`)
  log(`${COLORS.bold}╚══════════════════════════════════════════════════════════╝${COLORS.reset}`)

  if (failures.length > 0) {
    log(`\n${COLORS.red}${COLORS.bold}失败详情：${COLORS.reset}`)
    failures.forEach(({ step, msg }, i) => {
      log(`  ${i + 1}. ${COLORS.red}${step}${COLORS.reset}`)
      log(`     ${COLORS.dim}${msg.slice(0, 200)}${COLORS.reset}`)
    })
    log('')
    process.exit(1)
  } else {
    log(`\n${COLORS.green}${COLORS.bold}🎉 全部测试通过！前后端联调无问题。${COLORS.reset}\n`)
  }
}

main().catch((err) => {
  log(`\n${COLORS.red}脚本异常: ${err.message}${COLORS.reset}`)
  process.exit(1)
})
