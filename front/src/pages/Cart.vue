<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { createOrder, fetchUnits } from '../api'
import { getUser, isLoggedIn } from '../utils/auth'

const router = useRouter()
const CART_KEY = 'agri_cart'

const cartItems = ref([])
const unitMap = ref({})
const loading = ref(false)
const error = ref('')
const success = ref('')

// 表单
const deliveryAddress = ref('')
const contactName = ref('')
const remark = ref('')

const totalAmount = computed(() =>
  cartItems.value.reduce((sum, item) => sum + (item.price || 0) * item.qty, 0)
)

const totalQuantity = computed(() =>
  cartItems.value.reduce((sum, item) => sum + item.qty, 0)
)

const formatUnit = (unitId) => unitMap.value[unitId] || '单位'

const loadCart = () => {
  try {
    const raw = localStorage.getItem(CART_KEY)
    cartItems.value = raw ? JSON.parse(raw) : []
  } catch {
    cartItems.value = []
  }
}

const saveCart = () => {
  localStorage.setItem(CART_KEY, JSON.stringify(cartItems.value))
}

const updateQty = (index, val) => {
  if (val < 1) val = 1
  cartItems.value[index].qty = val
  saveCart()
}

const removeItem = (index) => {
  cartItems.value.splice(index, 1)
  saveCart()
}

const clearCart = () => {
  cartItems.value = []
  saveCart()
}

const handleSubmit = async () => {
  if (!isLoggedIn()) {
    error.value = '请登录后下单'
    return
  }
  if (!cartItems.value.length) {
    error.value = '购物车为空'
    return
  }
  if (!deliveryAddress.value) {
    error.value = '请填写收货地址'
    return
  }

  // 按卖家分组下单
  const sellerGroups = {}
  for (const item of cartItems.value) {
    const sid = item.sellerId || 0
    if (!sellerGroups[sid]) sellerGroups[sid] = []
    sellerGroups[sid].push(item)
  }

  loading.value = true
  error.value = ''
  success.value = ''

  try {
    const createdIds = []
    for (const [sellerId, items] of Object.entries(sellerGroups)) {
      const orderId = await createOrder({
        sellerId: Number(sellerId),
        deliveryAddress: deliveryAddress.value,
        contactName: contactName.value || getUser()?.username || '',
        remark: remark.value,
        items: items.map(item => ({
          productId: item.productId,
          productName: item.productName,
          quantity: item.qty,
          unitId: item.unitId,
          price: item.price || 0
        }))
      })
      if (orderId) createdIds.push(orderId)
    }
    success.value = '下单成功！正在跳转至支付页面…'
    clearCart()
    if (createdIds.length === 1) {
      setTimeout(() => router.push(`/payment/${createdIds[0]}`), 600)
    } else if (createdIds.length > 1) {
      // 多个卖家生成多笔订单，先跳转第一笔，其余可在我的订单页继续支付
      setTimeout(() => router.push(`/payment/${createdIds[0]}`), 600)
    }
  } catch (err) {
    error.value = err?.message || '下单失败'
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  loadCart()
  try {
    const unitRes = await fetchUnits({ page: 1, size: 200 })
    const unitRecords = unitRes?.records || []
    unitMap.value = unitRecords.reduce((acc, u) => {
      acc[u.id] = u.symbol || u.name
      return acc
    }, {})
  } catch {}
})
</script>

<template>
  <section class="section">
    <h2 class="section-title">购物车</h2>
    <p class="section-subtitle">已选商品列表，确认无误后提交订单。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />
    <a-alert v-if="success" type="success" :title="success" show-icon style="margin-bottom: 16px;" />

    <template v-if="cartItems.length">
      <a-card class="card-surface" :bordered="false">
        <a-space direction="vertical" fill>
          <div v-for="(item, idx) in cartItems" :key="idx" class="soft-panel" style="display: flex; justify-content: space-between; align-items: center;">
            <div style="flex: 1;">
              <div class="card-title">{{ item.productName }}</div>
              <div class="card-desc">
                单价：{{ item.price ? `￥${item.price}/${formatUnit(item.unitId)}` : '面议' }}
                · 小计：￥{{ ((item.price || 0) * item.qty).toFixed(2) }}
              </div>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
              <a-input-number v-model="item.qty" :min="1" :max="99999" size="small" style="width: 100px;" @change="(val) => updateQty(idx, val)" />
              <span style="color: var(--ink-500); font-size: 12px;">{{ formatUnit(item.unitId) }}</span>
              <a-button type="text" status="danger" size="small" @click="removeItem(idx)">
                <template #icon><icon-delete /></template>
              </a-button>
            </div>
          </div>
        </a-space>

        <div style="margin-top: 16px; padding: 14px; background: rgba(246,250,246,0.8); border-radius: 12px;">
          <div style="display: flex; justify-content: space-between; font-size: 15px; font-weight: 600;">
            <span>合计数量：{{ totalQuantity }}</span>
            <span style="color: #2b8a57;">合计金额：￥{{ totalAmount.toFixed(2) }}</span>
          </div>
        </div>
      </a-card>

      <a-card class="card-surface" :bordered="false" style="margin-top: 16px;" title="收货信息">
        <a-form :model="{}" layout="vertical">
          <a-form-item label="收货地址" required>
            <a-input v-model="deliveryAddress" placeholder="请输入收货地址" />
          </a-form-item>
          <a-form-item label="联系人">
            <a-input v-model="contactName" placeholder="请输入联系人姓名" />
          </a-form-item>
          <a-form-item label="备注">
            <a-textarea v-model="remark" :rows="2" placeholder="备注信息（选填）" />
          </a-form-item>
        </a-form>
        <div style="display: flex; gap: 10px; justify-content: flex-end;">
          <a-button @click="clearCart">清空购物车</a-button>
          <a-button type="primary" :loading="loading" @click="handleSubmit">提交订单</a-button>
        </div>
      </a-card>
    </template>

    <a-empty v-else description="购物车为空">
      <a-button type="primary" @click="router.push('/market')">前往供需大厅</a-button>
    </a-empty>
  </section>
</template>
