import { get, post } from './http'

const unwrapPage = (data) => {
  if (!data) return { total: 0, records: [] }
  return {
    total: data.total || 0,
    records: data.records || []
  }
}

export const fetchListings = async (params) => unwrapPage(await get('/listings', params))
export const fetchListingById = (id) => get(`/listings/${id}`)
export const fetchNotices = async (params) => unwrapPage(await get('/notices', params))
export const fetchStatsOverview = () => get('/stats/overview')
export const fetchUnits = async (params) => unwrapPage(await get('/units', params))
export const fetchTraceByBatch = (batchNo) => get(`/traces/by-batch/${batchNo}`)
export const fetchTraces = async (params) => unwrapPage(await get('/traces', params))
export const login = (payload) => post('/auth/login', payload)
export const register = (payload) => post('/auth/register', payload)
export const fetchMe = () => get('/auth/me')
export const createListing = (payload) => post('/listings', payload)
export const sendMessage = (payload) => post('/messages', payload)
export const fetchSupportAgent = () => get('/support/agent')
export const fetchConversations = async (params) => unwrapPage(await get('/conversations', params))
export const fetchConversationMessages = async (id, params) => unwrapPage(await get(`/conversations/${id}/messages`, params))

// 推荐
export const fetchRecommend = (size = 6) => get('/recommend', { size })

// AI 智能客服
export const askAi = (question) => post('/ai/chat', { question })

// 订单
export const fetchOrders = async (params) => unwrapPage(await get('/orders', params))
export const fetchOrderDetail = (id) => get(`/orders/${id}`)
export const createOrder = (payload) => post('/orders', payload)

// 商品
export const fetchProducts = async (params) => unwrapPage(await get('/products', params))

// 分类
export const fetchCategories = async (params) => unwrapPage(await get('/categories', params))

// 我的发布 & 资质
export const fetchMyListings = async (params) => unwrapPage(await get('/listings', params))
export const fetchMyQualifications = async (params) => unwrapPage(await get('/qualifications', params))
export const fetchMyAfterSales = async (params) => unwrapPage(await get('/after-sales', params))

