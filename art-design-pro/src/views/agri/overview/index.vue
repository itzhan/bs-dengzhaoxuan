<template>
  <div class="overview-page">
    <!-- 统计卡片 -->
    <ElRow :gutter="16" class="mb-4">
      <ElCol v-for="item in statCards" :key="item.label" :xs="12" :sm="12" :md="6">
        <ElCard shadow="never" class="stat-card" :style="{ borderLeft: `4px solid ${item.color}` }">
          <div class="stat-card-inner">
            <div>
              <div class="stat-label">{{ item.label }}</div>
              <div class="stat-value">{{ item.value }}</div>
            </div>
            <div class="stat-icon" :style="{ background: item.bgColor }">
              <ArtSvgIcon :icon="item.icon" class="text-xl" :style="{ color: item.color }" />
            </div>
          </div>
        </ElCard>
      </ElCol>
    </ElRow>

    <!-- 中间区域：最近订单 + 待审核 -->
    <ElRow :gutter="16" class="mb-4">
      <ElCol :xs="24" :md="14">
        <ElCard shadow="never">
          <template #header>
            <div class="card-header">
              <span class="card-header-title">
                <ArtSvgIcon icon="ri:shopping-cart-line" class="mr-2 text-lg" style="color: #8b5cf6;" />
                最近订单
              </span>
              <ElButton text type="primary" @click="$router.push('/agri/trade/orders')">查看全部</ElButton>
            </div>
          </template>
          <ElTable :data="recentOrders" style="width: 100%" size="small">
            <ElTableColumn prop="orderNo" label="订单号" min-width="160" />
            <ElTableColumn prop="buyerId" label="采购方" width="90" />
            <ElTableColumn prop="totalAmount" label="金额" width="100">
              <template #default="{ row }">
                <span style="color: #f59e0b; font-weight: 600;">¥{{ row.totalAmount }}</span>
              </template>
            </ElTableColumn>
            <ElTableColumn prop="status" label="状态" width="90">
              <template #default="{ row }">
                <ElTag :type="orderStatusType(row.status)" size="small">{{ orderStatusText(row.status) }}</ElTag>
              </template>
            </ElTableColumn>
            <ElTableColumn prop="createdAt" label="时间" width="100">
              <template #default="{ row }">
                {{ formatDate(row.createdAt) }}
              </template>
            </ElTableColumn>
          </ElTable>
          <ElEmpty v-if="!recentOrders.length" description="暂无订单数据" :image-size="60" />
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :md="10">
        <ElCard shadow="never" class="mb-4">
          <template #header>
            <div class="card-header">
              <span class="card-header-title">
                <ArtSvgIcon icon="ri:shield-check-line" class="mr-2 text-lg" style="color: #f59e0b;" />
                待办事项
              </span>
            </div>
          </template>
          <div class="todo-grid">
            <div class="todo-item" @click="$router.push('/agri/trade/listings')">
              <div class="todo-count" style="color: #3b82f6;">{{ pendingListings }}</div>
              <div class="todo-label">待审核发布</div>
              <ArtSvgIcon icon="ri:file-list-3-line" class="todo-icon" style="color: #93c5fd;" />
            </div>
            <div class="todo-item" @click="$router.push('/agri/operations/qualifications')">
              <div class="todo-count" style="color: #f59e0b;">{{ pendingQualifications }}</div>
              <div class="todo-label">待审核资质</div>
              <ArtSvgIcon icon="ri:medal-line" class="todo-icon" style="color: #fcd34d;" />
            </div>
            <div class="todo-item" @click="$router.push('/agri/trade/after-sales')">
              <div class="todo-count" style="color: #ef4444;">{{ pendingAfterSales }}</div>
              <div class="todo-label">待处理售后</div>
              <ArtSvgIcon icon="ri:customer-service-2-line" class="todo-icon" style="color: #fca5a5;" />
            </div>
            <div class="todo-item" @click="$router.push('/agri/trade/orders')">
              <div class="todo-count" style="color: #8b5cf6;">{{ pendingOrders }}</div>
              <div class="todo-label">待确认订单</div>
              <ArtSvgIcon icon="ri:time-line" class="todo-icon" style="color: #c4b5fd;" />
            </div>
          </div>
        </ElCard>
      </ElCol>
    </ElRow>

    <!-- 底部区域：最新公告 + 快速操作 -->
    <ElRow :gutter="16">
      <ElCol :xs="24" :md="14">
        <ElCard shadow="never">
          <template #header>
            <div class="card-header">
              <span class="card-header-title">
                <ArtSvgIcon icon="ri:notification-3-line" class="mr-2 text-lg" style="color: #10b981;" />
                最新公告
              </span>
              <ElButton text type="primary" @click="$router.push('/agri/operations/notices')">管理公告</ElButton>
            </div>
          </template>
          <div v-if="notices.length">
            <div v-for="item in notices" :key="item.id" class="notice-item">
              <div class="notice-dot" :class="item.publishStatus === 2 ? 'published' : 'draft'" />
              <div class="notice-content">
                <div class="notice-title">{{ item.title }}</div>
                <div class="notice-time">{{ formatDate(item.publishTime || item.createdAt) }}</div>
              </div>
              <ElTag v-if="item.publishStatus === 2" type="success" size="small">已发布</ElTag>
              <ElTag v-else size="small">未发布</ElTag>
            </div>
          </div>
          <ElEmpty v-else description="暂无公告" :image-size="60" />
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :md="10">
        <ElCard shadow="never">
          <template #header>
            <div class="card-header">
              <span class="card-header-title">
                <ArtSvgIcon icon="ri:apps-line" class="mr-2 text-lg" style="color: #6366f1;" />
                快速操作
              </span>
            </div>
          </template>
          <div class="quick-grid">
            <div class="quick-item" @click="$router.push('/agri/production/products')">
              <div class="quick-icon" style="background: rgba(59,130,246,0.1);">
                <ArtSvgIcon icon="ri:box-3-line" style="color: #3b82f6;" />
              </div>
              <span>商品管理</span>
            </div>
            <div class="quick-item" @click="$router.push('/agri/trade/listings')">
              <div class="quick-icon" style="background: rgba(16,185,129,0.1);">
                <ArtSvgIcon icon="ri:file-list-3-line" style="color: #10b981;" />
              </div>
              <span>供求信息</span>
            </div>
            <div class="quick-item" @click="$router.push('/agri/trade/orders')">
              <div class="quick-icon" style="background: rgba(139,92,246,0.1);">
                <ArtSvgIcon icon="ri:shopping-cart-line" style="color: #8b5cf6;" />
              </div>
              <span>订单管理</span>
            </div>
            <div class="quick-item" @click="$router.push('/agri/production/traces')">
              <div class="quick-icon" style="background: rgba(245,158,11,0.1);">
                <ArtSvgIcon icon="ri:qr-code-line" style="color: #f59e0b;" />
              </div>
              <span>溯源批次</span>
            </div>
            <div class="quick-item" @click="$router.push('/agri/system/users')">
              <div class="quick-icon" style="background: rgba(239,68,68,0.1);">
                <ArtSvgIcon icon="ri:user-3-line" style="color: #ef4444;" />
              </div>
              <span>用户管理</span>
            </div>
            <div class="quick-item" @click="$router.push('/agri/operations/messages')">
              <div class="quick-icon" style="background: rgba(99,102,241,0.1);">
                <ArtSvgIcon icon="ri:message-2-line" style="color: #6366f1;" />
              </div>
              <span>站内消息</span>
            </div>
          </div>
        </ElCard>
      </ElCol>
    </ElRow>
  </div>
</template>

<script setup lang="ts">
  import { agriApi } from '@/api/agri'

  const stats = ref<any>({})
  const recentOrders = ref<any[]>([])
  const notices = ref<any[]>([])
  const pendingListings = ref(0)
  const pendingQualifications = ref(0)
  const pendingAfterSales = ref(0)
  const pendingOrders = ref(0)

  const statCards = computed(() => [
    {
      label: '用户总数',
      value: stats.value.userCount || 0,
      icon: 'ri:user-3-line',
      color: '#3b82f6',
      bgColor: 'rgba(59,130,246,0.1)'
    },
    {
      label: '商品总数',
      value: stats.value.productCount || 0,
      icon: 'ri:box-3-line',
      color: '#10b981',
      bgColor: 'rgba(16,185,129,0.1)'
    },
    {
      label: '信息发布量',
      value: stats.value.listingCount || 0,
      icon: 'ri:file-list-3-line',
      color: '#f59e0b',
      bgColor: 'rgba(245,158,11,0.1)'
    },
    {
      label: '订单总量',
      value: stats.value.orderCount || 0,
      icon: 'ri:shopping-cart-line',
      color: '#8b5cf6',
      bgColor: 'rgba(139,92,246,0.1)'
    }
  ])

  const orderStatusText = (status: number) => {
    const map: Record<number, string> = {
      1: '待确认', 2: '已确认', 3: '配送中', 4: '已送达', 5: '已完成', 6: '已取消', 7: '售后中'
    }
    return map[status] || '未知'
  }

  const orderStatusType = (status: number) => {
    const map: Record<number, string> = {
      1: 'warning', 2: 'primary', 3: 'primary', 4: 'success', 5: 'success', 6: 'info', 7: 'danger'
    }
    return (map[status] || 'info') as any
  }

  const formatDate = (val: string) => val ? String(val).slice(0, 10) : ''

  const load = async () => {
    try {
      const [statsData, ordersData, noticesData, listingsData, qualData, afterSaleData] = await Promise.all([
        agriApi.getStats(),
        agriApi.getOrders({ page: 1, size: 5 }),
        agriApi.getNotices({ page: 1, size: 5 }),
        agriApi.getListings({ page: 1, size: 1, status: 1 }),
        agriApi.getQualifications({ page: 1, size: 1, status: 1 }),
        agriApi.getAfterSales({ page: 1, size: 1, status: 1 })
      ])
      stats.value = statsData || {}
      recentOrders.value = ordersData?.records || []
      notices.value = noticesData?.records || []
      pendingListings.value = listingsData?.total || 0
      pendingQualifications.value = qualData?.total || 0
      pendingAfterSales.value = afterSaleData?.total || 0
      // 待确认订单：status=1
      const pendingOrderData = await agriApi.getOrders({ page: 1, size: 1, status: 1 })
      pendingOrders.value = pendingOrderData?.total || 0
    } catch (e) {
      console.error('Dashboard load error:', e)
    }
  }

  onMounted(load)
  onActivated(load)
</script>

<style scoped>
.overview-page {
  padding: 0;
}

.stat-card {
  transition: transform 0.2s, box-shadow 0.2s;
}
.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.stat-card-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stat-label {
  font-size: 13px;
  color: var(--el-text-color-secondary);
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  margin-top: 4px;
  color: var(--el-text-color-primary);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header-title {
  display: flex;
  align-items: center;
  font-weight: 600;
  font-size: 15px;
}

.todo-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.todo-item {
  position: relative;
  padding: 16px;
  border-radius: 8px;
  background: var(--el-fill-color-lighter);
  cursor: pointer;
  transition: background 0.2s;
  overflow: hidden;
}
.todo-item:hover {
  background: var(--el-fill-color);
}

.todo-count {
  font-size: 26px;
  font-weight: 700;
  line-height: 1.2;
}

.todo-label {
  font-size: 12px;
  color: var(--el-text-color-secondary);
  margin-top: 4px;
}

.todo-icon {
  position: absolute;
  right: 10px;
  bottom: 10px;
  font-size: 28px;
  opacity: 0.3;
}

.notice-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid var(--el-border-color-lighter);
}
.notice-item:last-child {
  border-bottom: none;
}

.notice-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
.notice-dot.published {
  background: #10b981;
}
.notice-dot.draft {
  background: #d1d5db;
}

.notice-content {
  flex: 1;
  min-width: 0;
}

.notice-title {
  font-size: 14px;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notice-time {
  font-size: 12px;
  color: var(--el-text-color-secondary);
  margin-top: 2px;
}

.quick-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.quick-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 16px 8px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s;
  font-size: 13px;
  color: var(--el-text-color-regular);
}
.quick-item:hover {
  background: var(--el-fill-color-lighter);
}

.quick-icon {
  width: 42px;
  height: 42px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
}

.mb-4 {
  margin-bottom: 16px;
}
</style>
