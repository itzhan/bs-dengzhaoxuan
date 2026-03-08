const RAW_BASE = import.meta.env.VITE_API_BASE || '/api'
const API_BASE = RAW_BASE.endsWith('/') ? RAW_BASE.slice(0, -1) : RAW_BASE

const buildUrl = (path, params) => {
  const normalized = path.startsWith('/') ? path : `/${path}`
  const url = new URL(`${API_BASE}${normalized}`, window.location.origin)
  if (params) {
    Object.entries(params).forEach(([key, value]) => {
      if (value === undefined || value === null || value === '') return
      url.searchParams.append(key, value)
    })
  }
  return url.toString()
}

const withAuth = (headers = {}) => {
  const token = localStorage.getItem('agri_token')
  if (token) {
    return { ...headers, Authorization: `Bearer ${token}` }
  }
  return headers
}

const request = async (method, path, { params, body } = {}) => {
  const response = await fetch(buildUrl(path, params), {
    method,
    headers: withAuth({
      'Content-Type': 'application/json'
    }),
    body: body ? JSON.stringify(body) : undefined
  })

  const payload = await response.json().catch(() => ({}))
  if (!response.ok || payload.code !== 200) {
    const message = payload.message || '请求失败'
    throw new Error(message)
  }
  return payload.data
}

export const get = (path, params) => request('GET', path, { params })
export const post = (path, body) => request('POST', path, { body })
