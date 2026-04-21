<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { fetchOrderDetail, payOrder } from '../api'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const paying = ref(false)
const error = ref('')
const success = ref('')

const order = ref(null)
const items = ref([])
const method = ref('alipay')

const methodOptions = [
  { key: 'alipay', label: '支付宝', desc: '推荐·秒到账', color: '#1677ff' },
  { key: 'wechat', label: '微信支付', desc: '便捷扫码支付', color: '#09b83e' },
  { key: 'bank', label: '银行转账', desc: '对公账户·大额订单', color: '#f59e0b' }
]

const formatDate = (val) => (val ? String(val).replace('T', ' ').slice(0, 19) : '—')

const total = computed(() => Number(order.value?.totalAmount || 0).toFixed(2))

const loadOrder = async () => {
  loading.value = true
  error.value = ''
  try {
    const data = await fetchOrderDetail(route.params.id)
    order.value = data?.order || null
    items.value = data?.items || []
    if (order.value && order.value.status !== 1) {
      error.value = '该订单已支付或已取消，无需重复支付'
    }
  } catch (err) {
    error.value = err?.message || '订单加载失败'
  } finally {
    loading.value = false
  }
}

const handlePay = async () => {
  if (!order.value) return
  paying.value = true
  error.value = ''
  try {
    await payOrder(order.value.id)
    success.value = `支付成功！已通过「${methodOptions.find(m => m.key === method.value)?.label}」完成付款`
    setTimeout(() => router.push('/orders'), 1200)
  } catch (err) {
    error.value = err?.message || '支付失败'
  } finally {
    paying.value = false
  }
}

onMounted(loadOrder)
</script>

<template>
  <section class="section">
    <h2 class="section-title">订单支付</h2>
    <p class="section-subtitle">请核对订单信息并完成支付，支付后将通知生产者备货发货。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />
    <a-alert v-if="success" type="success" :title="success" show-icon style="margin-bottom: 16px;" />

    <a-spin :loading="loading" style="width: 100%;">
      <template v-if="order">
        <a-card class="card-surface" :bordered="false">
          <template #title>
            <div style="display: flex; align-items: center; gap: 10px;">
              <a-tag color="orange">待付款</a-tag>
              <span>订单号 {{ order.orderNo }}</span>
            </div>
          </template>

          <a-descriptions :column="2" bordered size="medium">
            <a-descriptions-item label="收货地址">{{ order.deliveryAddress }}</a-descriptions-item>
            <a-descriptions-item label="联系人">{{ order.contactName || '—' }}</a-descriptions-item>
            <a-descriptions-item label="下单时间">{{ formatDate(order.createdAt) }}</a-descriptions-item>
            <a-descriptions-item label="商品数量">{{ order.totalQuantity }}</a-descriptions-item>
          </a-descriptions>

          <div style="margin-top: 16px;" class="soft-panel">
            <div class="card-title" style="margin-bottom: 10px;">订单商品</div>
            <a-space direction="vertical" fill>
              <div v-for="item in items" :key="item.id" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                  <div style="font-weight: 600;">{{ item.productName }}</div>
                  <div class="card-desc">单价 ￥{{ item.price }} × {{ item.quantity }}</div>
                </div>
                <div style="color: #2b8a57; font-weight: 600;">￥{{ Number(item.amount).toFixed(2) }}</div>
              </div>
            </a-space>
          </div>
        </a-card>

        <a-card class="card-surface" :bordered="false" style="margin-top: 16px;" title="选择支付方式">
          <a-row :gutter="16">
            <a-col v-for="opt in methodOptions" :key="opt.key" :xs="24" :md="8">
              <div
                class="pay-method"
                :class="{ active: method === opt.key }"
                :style="{ '--pay-color': opt.color }"
                @click="method = opt.key"
              >
                <div style="font-size: 18px; font-weight: 700;">{{ opt.label }}</div>
                <div class="card-desc" style="margin-top: 4px;">{{ opt.desc }}</div>
                <div class="pay-check" v-if="method === opt.key">
                  <icon-check-circle-fill style="color: var(--pay-color);" />
                </div>
              </div>
            </a-col>
          </a-row>
        </a-card>

        <div class="pay-footer card-surface">
          <div>
            <div class="card-desc">应付金额</div>
            <div class="pay-total">￥{{ total }}</div>
          </div>
          <div style="display: flex; gap: 10px;">
            <a-button size="large" @click="router.push('/orders')">稍后支付</a-button>
            <a-button
              size="large"
              type="primary"
              :loading="paying"
              :disabled="order.status !== 1"
              @click="handlePay"
            >
              立即支付 ￥{{ total }}
            </a-button>
          </div>
        </div>
      </template>
      <a-empty v-else-if="!loading" description="未找到订单" />
    </a-spin>
  </section>
</template>

<style scoped>
.pay-method {
  position: relative;
  border: 2px solid rgba(43, 138, 87, 0.12);
  border-radius: 14px;
  padding: 18px 18px 20px;
  cursor: pointer;
  transition: all 0.18s ease;
  background: #fff;
}
.pay-method:hover {
  border-color: var(--pay-color);
  transform: translateY(-2px);
}
.pay-method.active {
  border-color: var(--pay-color);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
  background: linear-gradient(135deg, rgba(255,255,255,1), color-mix(in srgb, var(--pay-color) 10%, #fff));
}
.pay-check {
  position: absolute;
  top: 10px;
  right: 12px;
  font-size: 18px;
}
.pay-footer {
  margin-top: 16px;
  padding: 18px 22px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 14px;
}
.pay-total {
  font-size: 28px;
  font-weight: 700;
  color: #d63e3e;
}
</style>
