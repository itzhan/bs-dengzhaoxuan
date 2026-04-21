<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchOrders, fetchProducts, fetchOrderDetail, payOrder, shipOrder, confirmOrder } from '../api'
import { getUser, isLoggedIn } from '../utils/auth'
import { productFallbackImage } from '../utils/productImage'

const router = useRouter()
const loading = ref(true)
const error = ref('')
const success = ref('')
const orders = ref([])
const statusFilter = ref(null)
const productMap = ref({})
const orderItemsMap = ref({})
const busyId = ref(null)

const user = getUser()
const isProducer = computed(() => user?.role === 2)
const isBuyer = computed(() => user?.role === 3)
const isAdmin = computed(() => user?.role === 1)

const statusMap = {
  1: { text: '待付款', color: 'orange' },
  2: { text: '待发货', color: 'blue' },
  3: { text: '配送中', color: 'cyan' },
  4: { text: '已送达', color: 'green' },
  5: { text: '已完成', color: 'green' },
  6: { text: '已取消', color: 'red' },
  7: { text: '售后中', color: 'orange' }
}

const statusOptions = [
  { label: '全部', value: null },
  { label: '待付款', value: 1 },
  { label: '待发货', value: 2 },
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
    const [orderRes, productRes] = await Promise.all([
      fetchOrders({ page: 1, size: 200 }),
      fetchProducts({ page: 1, size: 500 })
    ])
    orders.value = orderRes.records || []
    const products = productRes.records || []
    productMap.value = products.reduce((acc, p) => { acc[p.id] = p; return acc }, {})
    // 拉取每个订单的商品明细（取首个商品用于展示）
    await Promise.all(orders.value.map(async (order) => {
      try {
        const detail = await fetchOrderDetail(order.id)
        orderItemsMap.value[order.id] = detail?.items || []
      } catch {}
    }))
  } catch (err) {
    error.value = err?.message || '订单加载失败'
  } finally {
    loading.value = false
  }
}

const firstImage = (orderId) => {
  const items = orderItemsMap.value[orderId] || []
  for (const it of items) {
    const prod = productMap.value[it.productId]
    if (prod?.imageUrl) return prod.imageUrl
  }
  return productFallbackImage(items[0]?.productName || String(orderId))
}

const handlePay = (order) => {
  router.push(`/payment/${order.id}`)
}

const handleShip = async (order) => {
  busyId.value = order.id
  error.value = ''
  try {
    await shipOrder(order.id)
    success.value = `订单 ${order.orderNo} 已发货`
    order.status = 3
  } catch (err) {
    error.value = err?.message || '发货失败'
  } finally {
    busyId.value = null
  }
}

const handleConfirm = async (order) => {
  busyId.value = order.id
  error.value = ''
  try {
    await confirmOrder(order.id)
    success.value = `订单 ${order.orderNo} 已确认收货，库存已同步`
    order.status = 5
  } catch (err) {
    error.value = err?.message || '确认收货失败'
  } finally {
    busyId.value = null
  }
}

onMounted(loadOrders)
</script>

<template>
  <section class="section">
    <h2 class="section-title">我的订单</h2>
    <p class="section-subtitle">
      <template v-if="isProducer">作为生产者，您可在「待发货」订单中点击发货。</template>
      <template v-else-if="isBuyer">作为采购商，您可在此支付订单并在收货后确认完成。</template>
      <template v-else>查看和管理系统内的全部订单。</template>
    </p>

    <a-alert v-if="error" type="warning" :title="error" show-icon closable style="margin-bottom: 16px;" @close="error = ''" />
    <a-alert v-if="success" type="success" :title="success" show-icon closable style="margin-bottom: 16px;" @close="success = ''" />

    <div class="card-surface" style="padding: 14px; margin-bottom: 16px;">
      <a-radio-group v-model="statusFilter" type="button">
        <a-radio v-for="opt in statusOptions" :key="String(opt.value)" :value="opt.value">{{ opt.label }}</a-radio>
      </a-radio-group>
    </div>

    <a-spin :loading="loading" style="width: 100%;">
      <a-space direction="vertical" fill v-if="filteredOrders.length">
        <a-card v-for="order in filteredOrders" :key="order.id" class="card-surface order-card" :bordered="false">
          <div class="order-row">
            <img class="order-img" :src="firstImage(order.id)" @error="(e) => (e.target.src = productFallbackImage(String(order.id)))" />
            <div class="order-main">
              <div class="card-title" style="display: flex; align-items: center; gap: 8px;">
                <span>{{ order.orderNo }}</span>
                <a-tag :color="statusMap[order.status]?.color || 'default'">{{ statusMap[order.status]?.text || '未知' }}</a-tag>
                <a-tag v-if="isProducer && order.sellerId === user?.id" color="arcoblue">生产方</a-tag>
                <a-tag v-else-if="isBuyer && order.buyerId === user?.id" color="green">采购方</a-tag>
              </div>
              <div class="card-desc" style="margin-top: 4px;">
                收货地址：{{ order.deliveryAddress }} · 联系人：{{ order.contactName || '无' }}
              </div>
              <div class="card-desc">下单时间：{{ formatDate(order.createdAt) }}</div>
              <div v-if="orderItemsMap[order.id]?.length" class="card-desc">
                含 {{ orderItemsMap[order.id].length }} 件商品
                ·
                {{ orderItemsMap[order.id].map(i => i.productName).join('、') }}
              </div>
            </div>
            <div class="order-right">
              <div style="font-size: 18px; font-weight: 600; color: #2b8a57;">￥{{ order.totalAmount }}</div>
              <div class="card-desc">数量 {{ order.totalQuantity }}</div>
              <div class="order-actions">
                <a-button
                  v-if="order.status === 1 && (isBuyer || isAdmin) && (order.buyerId === user?.id || isAdmin)"
                  type="primary"
                  size="small"
                  @click="handlePay(order)"
                >去支付</a-button>
                <a-button
                  v-if="order.status === 2 && (isProducer || isAdmin) && (order.sellerId === user?.id || isAdmin)"
                  type="primary"
                  status="success"
                  size="small"
                  :loading="busyId === order.id"
                  @click="handleShip(order)"
                >发货</a-button>
                <a-button
                  v-if="[3,4].includes(order.status) && (isBuyer || isAdmin) && (order.buyerId === user?.id || isAdmin)"
                  type="primary"
                  size="small"
                  :loading="busyId === order.id"
                  @click="handleConfirm(order)"
                >确认收货</a-button>
              </div>
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

<style scoped>
.order-row {
  display: flex;
  gap: 16px;
  align-items: center;
}
.order-img {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 10px;
  background: #f3f5f4;
  flex-shrink: 0;
}
.order-main { flex: 1; min-width: 0; }
.order-right { text-align: right; flex-shrink: 0; }
.order-actions {
  margin-top: 8px;
  display: flex;
  gap: 6px;
  justify-content: flex-end;
}
</style>
