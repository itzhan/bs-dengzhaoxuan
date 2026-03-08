/*
 * Simple API smoke test for agri-bridge backend.
 * Usage:
 *   API_BASE=http://localhost:8080 node scripts/api-smoke-test.mjs
 */

const baseUrl = process.env.API_BASE || 'http://localhost:8080'
const errors = []

function log(msg) {
  process.stdout.write(`${msg}\n`)
}

function recordError(step, err) {
  const message = err?.message || String(err)
  errors.push(`${step}: ${message}`)
  log(`[ERROR] ${step}: ${message}`)
}

async function runStep(step, fn) {
  try {
    const res = await fn()
    log(`[OK] ${step}`)
    return res
  } catch (err) {
    recordError(step, err)
    return null
  }
}

async function request(method, path, body, token) {
  const url = `${baseUrl}${path}`
  const headers = { 'Content-Type': 'application/json' }
  if (token) headers.Authorization = `Bearer ${token}`

  const options = { method, headers }
  if (body !== undefined) options.body = JSON.stringify(body)

  const res = await fetch(url, options)
  const text = await res.text()
  let json
  try {
    json = text ? JSON.parse(text) : null
  } catch {
    json = null
  }
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} ${res.statusText} ${path} -> ${text}`)
  }
  return json
}

function pickId(list) {
  return Array.isArray(list) && list.length > 0 ? list[0].id : null
}

async function main() {
  log(`API_BASE = ${baseUrl}`)

  const login = await runStep('login', () =>
    request('POST', '/api/auth/login', {
      username: 'admin',
      password: '123456'
    })
  )
  const token = login?.data?.token
  if (!token) {
    recordError('login', 'token missing, subsequent steps may fail')
  }

  await runStep('auth/me', () => request('GET', '/api/auth/me', undefined, token))

  // list endpoints
  await runStep('categories list', () => request('GET', '/api/categories?page=1&size=5', undefined, token))
  await runStep('units list', () => request('GET', '/api/units?page=1&size=5', undefined, token))
  await runStep('products list', () => request('GET', '/api/products?page=1&size=5', undefined, token))
  await runStep('listings list', () => request('GET', '/api/listings?page=1&size=5', undefined, token))
  await runStep('inventories list', () => request('GET', '/api/inventories?page=1&size=5', undefined, token))
  await runStep('orders list', () => request('GET', '/api/orders?page=1&size=5', undefined, token))
  await runStep('after-sales list', () => request('GET', '/api/after-sales?page=1&size=5', undefined, token))
  await runStep('schedules list', () => request('GET', '/api/schedules?page=1&size=5', undefined, token))
  await runStep('traces list', () => request('GET', '/api/traces?page=1&size=5', undefined, token))
  await runStep('qualifications list', () => request('GET', '/api/qualifications?page=1&size=5', undefined, token))
  await runStep('notices list', () => request('GET', '/api/notices?page=1&size=5', undefined, token))
  await runStep('conversations list', () => request('GET', '/api/conversations?page=1&size=5', undefined, token))
  await runStep('audits list', () => request('GET', '/api/audits?page=1&size=5', undefined, token))
  await runStep('stats overview', () => request('GET', '/api/stats/overview', undefined, token))

  // create/update/delete category
  const categoryName = `test-category-${Date.now()}`
  await runStep('create category', () =>
    request('POST', '/api/categories', { name: categoryName, parentId: 1, sortNo: 99 }, token)
  )
  const catList = await runStep('query category', () =>
    request('GET', `/api/categories?page=1&size=5&keyword=${encodeURIComponent(categoryName)}`, undefined, token)
  )
  const catId = pickId(catList?.data?.records)
  if (catId) {
    await runStep('update category', () => request('PUT', `/api/categories/${catId}`, { sortNo: 100 }, token))
    await runStep('delete category', () => request('DELETE', `/api/categories/${catId}`, undefined, token))
  } else {
    recordError('category id', 'not found, skip update/delete')
  }

  // create/update/delete unit
  const unitName = `test-unit-${Date.now()}`
  await runStep('create unit', () => request('POST', '/api/units', { name: unitName, symbol: 'u' }, token))
  const unitList = await runStep('query unit', () =>
    request('GET', `/api/units?page=1&size=5&keyword=${encodeURIComponent(unitName)}`, undefined, token)
  )
  const unitId = pickId(unitList?.data?.records)
  if (unitId) {
    await runStep('update unit', () => request('PUT', `/api/units/${unitId}`, { symbol: 'u2' }, token))
    await runStep('delete unit', () => request('DELETE', `/api/units/${unitId}`, undefined, token))
  } else {
    recordError('unit id', 'not found, skip update/delete')
  }

  // create/update/delete product
  const productName = `test-product-${Date.now()}`
  await runStep('create product', () =>
    request(
      'POST',
      '/api/products',
      { name: productName, categoryId: 1, unitId: 1, origin: 'test', traceable: 1, status: 1, ownerId: 1001 },
      token
    )
  )
  const prodList = await runStep('query product', () =>
    request('GET', `/api/products?page=1&size=5&keyword=${encodeURIComponent(productName)}`, undefined, token)
  )
  const prodId = pickId(prodList?.data?.records)
  if (prodId) {
    await runStep('update product', () => request('PUT', `/api/products/${prodId}`, { origin: 'test2' }, token))
    await runStep('delete product', () => request('DELETE', `/api/products/${prodId}`, undefined, token))
  } else {
    recordError('product id', 'not found, skip update/delete')
  }

  // create/update/delete listing
  const listingTitle = `test-listing-${Date.now()}`
  await runStep('create listing', () =>
    request(
      'POST',
      '/api/listings',
      { type: 1, title: listingTitle, quantity: 10, unitId: 1, price: 9.9, location: 'test', description: 'test' },
      token
    )
  )
  const listList = await runStep('query listing', () =>
    request('GET', `/api/listings?page=1&size=5&keyword=${encodeURIComponent(listingTitle)}`, undefined, token)
  )
  const listingId = pickId(listList?.data?.records)
  if (listingId) {
    await runStep('update listing', () => request('PUT', `/api/listings/${listingId}`, { price: 8.8 }, token))
    await runStep('delete listing', () => request('DELETE', `/api/listings/${listingId}`, undefined, token))
  } else {
    recordError('listing id', 'not found, skip update/delete')
  }

  // create/update/delete inventory
  await runStep('create inventory', () =>
    request('POST', '/api/inventories', { producerId: 1001, productId: 101, quantity: 3, unitId: 2, location: 'test' }, token)
  )
  const invList = await runStep('query inventory', () => request('GET', '/api/inventories?page=1&size=5', undefined, token))
  const invId = pickId(invList?.data?.records)
  if (invId) {
    await runStep('update inventory', () => request('PUT', `/api/inventories/${invId}`, { quantity: 5 }, token))
    await runStep('delete inventory', () => request('DELETE', `/api/inventories/${invId}`, undefined, token))
  } else {
    recordError('inventory id', 'not found, skip update/delete')
  }

  // create/update/delete schedule
  await runStep('create schedule', () =>
    request('POST', '/api/schedules', { producerId: 1001, type: 1, startTime: '2025-01-01 10:00:00', endTime: '2025-01-01 12:00:00', location: 'test' }, token)
  )
  const scheduleList = await runStep('query schedule', () => request('GET', '/api/schedules?page=1&size=5', undefined, token))
  const scheduleId = pickId(scheduleList?.data?.records)
  if (scheduleId) {
    await runStep('update schedule', () => request('PUT', `/api/schedules/${scheduleId}`, { location: 'test2' }, token))
    await runStep('delete schedule', () => request('DELETE', `/api/schedules/${scheduleId}`, undefined, token))
  } else {
    recordError('schedule id', 'not found, skip update/delete')
  }

  // create/update/delete trace batch
  const batchNo = `BATCH-${Date.now()}`
  await runStep('create trace', () =>
    request('POST', '/api/traces', { productId: 101, producerId: 1001, batchNo, traceInfo: '{"test":true}' }, token)
  )
  const traceList = await runStep('query trace', () => request('GET', `/api/traces?page=1&size=5&productId=101`, undefined, token))
  const traceId = pickId(traceList?.data?.records)
  if (traceId) {
    await runStep('update trace', () => request('PUT', `/api/traces/${traceId}`, { status: 1 }, token))
    await runStep('delete trace', () => request('DELETE', `/api/traces/${traceId}`, undefined, token))
  } else {
    recordError('trace id', 'not found, skip update/delete')
  }

  // create/publish/delete notice
  const noticeTitle = `test-notice-${Date.now()}`
  await runStep('create notice', () => request('POST', '/api/notices', { title: noticeTitle, content: 'test' }, token))
  const noticeList = await runStep('query notice', () =>
    request('GET', `/api/notices?page=1&size=5&keyword=${encodeURIComponent(noticeTitle)}`, undefined, token)
  )
  const noticeId = pickId(noticeList?.data?.records)
  if (noticeId) {
    await runStep('publish notice', () => request('POST', `/api/notices/${noticeId}/publish`, undefined, token))
    await runStep('delete notice', () => request('DELETE', `/api/notices/${noticeId}`, undefined, token))
  } else {
    recordError('notice id', 'not found, skip update/delete')
  }

  // send a message to a producer (creates conversation if not exists)
  await runStep('send message', () => request('POST', '/api/messages', { toUserId: 1001, content: 'test message', type: 1 }, token))

  if (errors.length > 0) {
    log('\n=== FAILED STEPS ===')
    errors.forEach((e) => log(`- ${e}`))
    throw new Error(`Smoke tests finished with ${errors.length} error(s).`)
  } else {
    log('All smoke tests passed.')
  }
}

main().catch((err) => {
  console.error('[api-smoke-test] Failed:', err.message)
  process.exit(1)
})
