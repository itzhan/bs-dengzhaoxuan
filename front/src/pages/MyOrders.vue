<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchOrders } from '../api'
import { getUser, isLoggedIn } from '../utils/auth'

const router = useRouter()
const loading = ref(true)
const error = ref('')
const orders = ref([])
const statusFilter = ref(null)

const user = getUser()

const statusMap = {
  1: { text: '待确认', color: 'orange' },
  2: { text: '已确认', color: 'blue' },
  3: { text: '配送中', color: 'cyan' },
  4: { text: '已送达', color: 'green' },
  5: { text: '已完成', color: 'green' },
  6: { text: '已取消', color: 'red' },
  7: { text: '售后中', color: 'orange' }
}

const statusOptions = [
  { label: '全部', value: null },
  { label: '待确认', value: 1 },
  { label: '已确认', value: 2 },
  { label: '配送中', value: 3 },
  { label: '已送达', value: 4 },
  { label: '已完成', value: 5 },
  { label: '已取消', value: 6 }
]

const filteredOrders = computed(() => {
  if (statusFilter.value === null) return orders.value
  return orders.value.filter(o => o.status === statusFilter.value)
})

const formatDate = (val) => val ? String(val).replace('T', ' ').slice(0, 16) : ''

const loadOrders = async () => {
  if (!isLoggedIn()) {
    router.push('/login')
    return
  }
  loading.value = true
  error.value = ''
  try {
    const res = await fetchOrders({ page: 1, size: 200 })
    orders.value = res.records || []
  } catch (err) {
    error.value = err?.message || '订单加载失败'
  } finally {
    loading.value = false
  }
}

onMounted(loadOrders)
</script>

<template>
  <section class="section">
    <h2 class="section-title">我的订单</h2>
    <p class="section-subtitle">查看和管理您的历史订单。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <div class="card-surface" style="padding: 14px; margin-bottom: 16px;">
      <a-radio-group v-model="statusFilter" type="button">
        <a-radio v-for="opt in statusOptions" :key="String(opt.value)" :value="opt.value">{{ opt.label }}</a-radio>
      </a-radio-group>
    </div>

    <a-spin :loading="loading" style="width: 100%;">
      <a-space direction="vertical" fill v-if="filteredOrders.length">
        <a-card v-for="order in filteredOrders" :key="order.id" class="card-surface" :bordered="false">
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
              <div class="card-title" style="display: flex; align-items: center; gap: 8px;">
                <span>{{ order.orderNo }}</span>
                <a-tag :color="statusMap[order.status]?.color || 'default'">{{ statusMap[order.status]?.text || '未知' }}</a-tag>
              </div>
              <div class="card-desc" style="margin-top: 4px;">
                收货地址：{{ order.deliveryAddress }} · 联系人：{{ order.contactName || '无' }}
              </div>
              <div class="card-desc">
                下单时间：{{ formatDate(order.createdAt) }}
              </div>
            </div>
            <div style="text-align: right;">
              <div style="font-size: 18px; font-weight: 600; color: #2b8a57;">￥{{ order.totalAmount }}</div>
              <div class="card-desc">数量 {{ order.totalQuantity }}</div>
            </div>
          </div>
        </a-card>
      </a-space>
      <a-empty v-else description="暂无订单">
        <a-button type="primary" @click="router.push('/market')">前往采购</a-button>
      </a-empty>
    </a-spin>
  </section>
</template>
