import request from '@/utils/http'
import { AppRouteRecord } from '@/types/router'

export interface PageResult<T> {
  records: T[]
  total: number
  page?: number
  size?: number
}

export const agriApi = {
  // 基础数据
  getCategories(params: any) {
    return request.get<PageResult<any>>({ url: '/api/categories', params })
  },
  createCategory(data: any) {
    return request.post<void>({ url: '/api/categories', params: data })
  },
  updateCategory(id: number, data: any) {
    return request.put<void>({ url: `/api/categories/${id}`, params: data })
  },
  deleteCategory(id: number) {
    return request.delete<void>({ url: `/api/categories/${id}` })
  },

  getUnits(params: any) {
    return request.get<PageResult<any>>({ url: '/api/units', params })
  },
  createUnit(data: any) {
    return request.post<void>({ url: '/api/units', params: data })
  },
  updateUnit(id: number, data: any) {
    return request.put<void>({ url: `/api/units/${id}`, params: data })
  },
  deleteUnit(id: number) {
    return request.delete<void>({ url: `/api/units/${id}` })
  },

  getProducts(params: any) {
    return request.get<PageResult<any>>({ url: '/api/products', params })
  },
  createProduct(data: any) {
    return request.post<void>({ url: '/api/products', params: data })
  },
  updateProduct(id: number, data: any) {
    return request.put<void>({ url: `/api/products/${id}`, params: data })
  },
  deleteProduct(id: number) {
    return request.delete<void>({ url: `/api/products/${id}` })
  },

  getListings(params: any) {
    return request.get<PageResult<any>>({ url: '/api/listings', params })
  },
  createListing(data: any) {
    return request.post<void>({ url: '/api/listings', params: data })
  },
  updateListing(id: number, data: any) {
    return request.put<void>({ url: `/api/listings/${id}`, params: data })
  },
  deleteListing(id: number) {
    return request.delete<void>({ url: `/api/listings/${id}` })
  },
  auditListing(id: number, data: { status: number; remark?: string }) {
    return request.post<void>({ url: `/api/listings/${id}/audit`, params: data })
  },

  getInventories(params: any) {
    return request.get<PageResult<any>>({ url: '/api/inventories', params })
  },
  createInventory(data: any) {
    return request.post<void>({ url: '/api/inventories', params: data })
  },
  updateInventory(id: number, data: any) {
    return request.put<void>({ url: `/api/inventories/${id}`, params: data })
  },
  deleteInventory(id: number) {
    return request.delete<void>({ url: `/api/inventories/${id}` })
  },

  getOrders(params: any) {
    return request.get<PageResult<any>>({ url: '/api/orders', params })
  },
  getOrderDetail(id: number) {
    return request.get<any>({ url: `/api/orders/${id}` })
  },
  createOrder(data: any) {
    return request.post<number>({ url: '/api/orders', params: data })
  },
  updateOrderStatus(id: number, status: number) {
    return request.post<void>({ url: `/api/orders/${id}/status`, params: { status } })
  },

  getAfterSales(params: any) {
    return request.get<PageResult<any>>({ url: '/api/after-sales', params })
  },
  createAfterSale(data: any) {
    return request.post<void>({ url: '/api/after-sales', params: data })
  },
  auditAfterSale(id: number, status: number) {
    return request.post<void>({ url: `/api/after-sales/${id}/audit`, params: { status } })
  },

  getSchedules(params: any) {
    return request.get<PageResult<any>>({ url: '/api/schedules', params })
  },
  createSchedule(data: any) {
    return request.post<void>({ url: '/api/schedules', params: data })
  },
  updateSchedule(id: number, data: any) {
    return request.put<void>({ url: `/api/schedules/${id}`, params: data })
  },
  deleteSchedule(id: number) {
    return request.delete<void>({ url: `/api/schedules/${id}` })
  },

  getTraces(params: any) {
    return request.get<PageResult<any>>({ url: '/api/traces', params })
  },
  getTraceByBatch(batchNo: string) {
    return request.get<any>({ url: `/api/traces/by-batch/${batchNo}` })
  },
  createTrace(data: any) {
    return request.post<void>({ url: '/api/traces', params: data })
  },
  updateTrace(id: number, data: any) {
    return request.put<void>({ url: `/api/traces/${id}`, params: data })
  },
  deleteTrace(id: number) {
    return request.delete<void>({ url: `/api/traces/${id}` })
  },

  getQualifications(params: any) {
    return request.get<PageResult<any>>({ url: '/api/qualifications', params })
  },
  createQualification(data: any) {
    return request.post<void>({ url: '/api/qualifications', params: data })
  },
  updateQualification(id: number, data: any) {
    return request.put<void>({ url: `/api/qualifications/${id}`, params: data })
  },
  auditQualification(id: number, data: { status: number; remark?: string }) {
    return request.post<void>({ url: `/api/qualifications/${id}/audit`, params: data })
  },

  getConversations(params: any) {
    return request.get<PageResult<any>>({ url: '/api/conversations', params })
  },
  getMessages(id: number, params: any) {
    return request.get<PageResult<any>>({ url: `/api/conversations/${id}/messages`, params })
  },
  sendMessage(data: any) {
    return request.post<void>({ url: '/api/messages', params: data })
  },

  getNotices(params: any) {
    return request.get<PageResult<any>>({ url: '/api/notices', params })
  },
  createNotice(data: any) {
    return request.post<void>({ url: '/api/notices', params: data })
  },
  updateNotice(id: number, data: any) {
    return request.put<void>({ url: `/api/notices/${id}`, params: data })
  },
  publishNotice(id: number) {
    return request.post<void>({ url: `/api/notices/${id}/publish` })
  },
  deleteNotice(id: number) {
    return request.delete<void>({ url: `/api/notices/${id}` })
  },

  getAudits(params: any) {
    return request.get<PageResult<any>>({ url: '/api/audits', params })
  },

  getUsers(params: any) {
    return request.get<PageResult<any>>({ url: '/api/users', params })
  },
  createUser(data: any) {
    return request.post<void>({ url: '/api/users', params: data })
  },
  updateUser(id: number, data: any) {
    return request.put<void>({ url: `/api/users/${id}`, params: data })
  },
  deleteUser(id: number) {
    return request.delete<void>({ url: `/api/users/${id}` })
  },

  getStats() {
    return request.get<any>({ url: '/api/stats/overview' })
  },

  exportOrders(params: any) {
    return request.get<Blob>({
      url: '/api/exports/orders',
      params,
      responseType: 'blob' as any
    })
  }
}

export async function fetchMenuList(): Promise<AppRouteRecord[]> {
  return []
}
