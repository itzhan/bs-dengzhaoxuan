import { AppRouteRecord } from '@/types/router'

export const agriRoutes: AppRouteRecord = {
  path: '/agri',
  name: 'Agri',
  component: '/index/index',
  meta: {
    title: '产销对接',
    icon: 'ri:leaf-line',
    roles: ['R_ADMIN', 'R_PRODUCER', 'R_BUYER']
  },
  children: [
    {
      path: 'overview',
      name: 'AgriOverview',
      component: '/agri/overview',
      meta: {
        title: '数据概览',
        icon: 'ri:dashboard-line',
        keepAlive: false
      }
    },
    {
      path: 'trade',
      name: 'AgriTrade',
      component: '',
      meta: { title: '交易管理', icon: 'ri:shopping-bag-3-line' },
      children: [
        {
          path: 'listings',
          name: 'AgriListings',
          component: '/agri/listings',
          meta: { title: '供求信息', icon: 'ri:file-list-3-line' }
        },
        {
          path: 'orders',
          name: 'AgriOrders',
          component: '/agri/orders',
          meta: { title: '订单管理', icon: 'ri:shopping-cart-line' }
        },
        {
          path: 'after-sales',
          name: 'AgriAfterSales',
          component: '/agri/after-sales',
          meta: { title: '售后管理', icon: 'ri:customer-service-2-line' }
        }
      ]
    },
    {
      path: 'production',
      name: 'AgriProduction',
      component: '',
      meta: { title: '生产管理', icon: 'ri:seedling-line', roles: ['R_ADMIN', 'R_PRODUCER'] },
      children: [
        {
          path: 'products',
          name: 'AgriProducts',
          component: '/agri/products',
          meta: { title: '商品管理', icon: 'ri:box-3-line', roles: ['R_ADMIN', 'R_PRODUCER'] }
        },
        {
          path: 'inventories',
          name: 'AgriInventories',
          component: '/agri/inventories',
          meta: { title: '库存管理', icon: 'ri:archive-line', roles: ['R_ADMIN', 'R_PRODUCER'] }
        },
        {
          path: 'schedules',
          name: 'AgriSchedules',
          component: '/agri/schedules',
          meta: { title: '日程管理', icon: 'ri:calendar-line', roles: ['R_ADMIN', 'R_PRODUCER'] }
        },
        {
          path: 'traces',
          name: 'AgriTraces',
          component: '/agri/traces',
          meta: { title: '溯源批次', icon: 'ri:qr-code-line', roles: ['R_ADMIN', 'R_PRODUCER'] }
        }
      ]
    },
    {
      path: 'operations',
      name: 'AgriOperations',
      component: '',
      meta: { title: '运营管理', icon: 'ri:settings-3-line' },
      children: [
        {
          path: 'qualifications',
          name: 'AgriQualifications',
          component: '/agri/qualifications',
          meta: { title: '资质审核', icon: 'ri:shield-check-line' }
        },
        {
          path: 'notices',
          name: 'AgriNotices',
          component: '/agri/notices',
          meta: { title: '公告管理', icon: 'ri:notification-3-line' }
        },
        {
          path: 'messages',
          name: 'AgriMessages',
          component: '/agri/messages',
          meta: { title: '站内消息', icon: 'ri:message-2-line' }
        }
      ]
    },
    {
      path: 'system',
      name: 'AgriSystem',
      component: '',
      meta: { title: '系统设置', icon: 'ri:admin-line', roles: ['R_ADMIN'] },
      children: [
        {
          path: 'categories',
          name: 'AgriCategories',
          component: '/agri/categories',
          meta: { title: '分类管理', icon: 'ri:list-check', roles: ['R_ADMIN'] }
        },
        {
          path: 'units',
          name: 'AgriUnits',
          component: '/agri/units',
          meta: { title: '单位管理', icon: 'ri:ruler-line', roles: ['R_ADMIN'] }
        },
        {
          path: 'users',
          name: 'AgriUsers',
          component: '/agri/users',
          meta: { title: '用户管理', icon: 'ri:user-3-line', roles: ['R_ADMIN'] }
        },
        {
          path: 'audits',
          name: 'AgriAudits',
          component: '/agri/audits',
          meta: { title: '审核记录', icon: 'ri:history-line', roles: ['R_ADMIN'] }
        }
      ]
    }
  ]
}
