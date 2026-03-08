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
export const login = (payload) => post('/auth/login', payload)
export const register = (payload) => post('/auth/register', payload)
export const fetchMe = () => get('/auth/me')
export const createListing = (payload) => post('/listings', payload)
export const sendMessage = (payload) => post('/messages', payload)
export const fetchSupportAgent = () => get('/support/agent')
export const fetchConversations = async (params) => unwrapPage(await get('/conversations', params))
export const fetchConversationMessages = async (id, params) => unwrapPage(await get(`/conversations/${id}/messages`, params))
