<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { fetchListingById, fetchUnits, fetchProducts } from '../api'
import { productFallbackImage } from '../utils/productImage'

const route = useRoute()
const loading = ref(true)
const error = ref('')
const detail = ref(null)
const unitMap = ref({})
const product = ref(null)

const heroImage = () => {
  if (product.value?.imageUrl) return product.value.imageUrl
  return productFallbackImage(detail.value?.title || product.value?.name || '农产品')
}

const CART_KEY = 'agri_cart'
const FAVORITES_KEY = 'agri_favorites'

const statusMap = {
  1: '待审',
  2: '审核通过',
  3: '已驳回',
  4: '已上架',
  5: '已下架',
  6: '已过期'
}

const typeLabel = computed(() => {
  if (!detail.value) return ''
  return detail.value.type === 2 ? '求购需求' : '供应信息'
})

const formatUnit = (unitId) => unitMap.value[unitId] || '单位'
const formatDateTime = (val) => (val ? String(val).replace('T', ' ') : '')

const isFavorited = ref(false)

const checkFavorite = () => {
  try {
    const raw = localStorage.getItem(FAVORITES_KEY)
    const favs = raw ? JSON.parse(raw) : []
    isFavorited.value = favs.some((f) => f.id === detail.value?.id)
  } catch {
    isFavorited.value = false
  }
}

const toggleFavorite = () => {
  if (!detail.value) return
  try {
    const raw = localStorage.getItem(FAVORITES_KEY)
    let favs = raw ? JSON.parse(raw) : []
    const idx = favs.findIndex((f) => f.id === detail.value.id)
    if (idx >= 0) {
      favs.splice(idx, 1)
      isFavorited.value = false
    } else {
      favs.push({
        id: detail.value.id,
        title: detail.value.title,
        location: detail.value.location,
        price: detail.value.price,
        type: detail.value.type
      })
      isFavorited.value = true
    }
    localStorage.setItem(FAVORITES_KEY, JSON.stringify(favs))
  } catch {}
}

const addToCart = () => {
  if (!detail.value) return
  try {
    const raw = localStorage.getItem(CART_KEY)
    let cart = raw ? JSON.parse(raw) : []
    const existing = cart.find((c) => c.productId === detail.value.productId && c.listingId === detail.value.id)
    if (existing) {
      existing.qty += 1
    } else {
      cart.push({
        listingId: detail.value.id,
        productId: detail.value.productId,
        productName: detail.value.title,
        price: detail.value.price || 0,
        unitId: detail.value.unitId,
        sellerId: detail.value.publisherId,
        qty: 1
      })
    }
    localStorage.setItem(CART_KEY, JSON.stringify(cart))
    window.$message?.success?.('已加入购物车') || alert('已加入购物车')
  } catch {}
}

const metaRows = computed(() => {
  if (!detail.value) return []
  const rows = [
    { label: '供需类型', value: typeLabel.value },
    { label: '数量', value: `${detail.value.quantity || 0} ${formatUnit(detail.value.unitId)}` },
    { label: '参考价格', value: detail.value.price ? `￥${detail.value.price}/${formatUnit(detail.value.unitId)}` : '价格面议' },
    { label: '所在地', value: detail.value.location || '待补充' },
    { label: '有效期', value: detail.value.endTime ? formatDateTime(detail.value.endTime) : '长期有效' },
    { label: '状态', value: statusMap[detail.value.status] || '未知' }
  ]
  if (detail.value.type === 2) {
    rows.push({ label: '联系人', value: detail.value.contactName || '待补充' })
    rows.push({ label: '联系方式', value: detail.value.contactPhone || '待补充' })
  }
  return rows
})

const loadData = async () => {
  loading.value = true
  error.value = ''
  try {
    const [detailRes, unitRes] = await Promise.all([
      fetchListingById(route.params.id),
      fetchUnits({ page: 1, size: 200 })
    ])
    detail.value = detailRes
    const unitRecords = unitRes?.records || []
    unitMap.value = unitRecords.reduce((acc, unit) => {
      acc[unit.id] = unit.symbol || unit.name
      return acc
    }, {})
    if (detailRes?.productId) {
      try {
        const prodRes = await fetchProducts({ page: 1, size: 500 })
        product.value = (prodRes.records || []).find(p => p.id === detailRes.productId) || null
      } catch {}
    }
    checkFavorite()
  } catch (err) {
    error.value = err?.message || '详情加载失败'
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <section class="section">
    <a-card class="card-surface" :bordered="false">
      <template #title>
        <div style="display: flex; align-items: center; gap: 10px;">
          <a-tag :color="detail?.type === 2 ? 'orange' : 'green'">{{ typeLabel || '供需信息' }}</a-tag>
          <span style="font-weight: 600; font-size: 18px;">{{ detail?.title || '供需详情' }}</span>
        </div>
      </template>
      <template #extra>
        <div style="display: flex; gap: 8px;">
          <a-button v-if="detail && detail.type === 1" type="primary" @click="addToCart">
            <template #icon><icon-shopping-cart /></template>
            加入购物车
          </a-button>
          <a-button @click="toggleFavorite" :type="isFavorited ? 'primary' : 'secondary'" :status="isFavorited ? 'warning' : undefined">
            <template #icon><icon-heart-fill v-if="isFavorited" /><icon-heart v-else /></template>
            {{ isFavorited ? '已收藏' : '收藏' }}
          </a-button>
          <a-button @click="$router.push('/market')">返回供需大厅</a-button>
        </div>
      </template>

      <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

      <a-spin :loading="loading" style="width: 100%;">
        <div v-if="detail" style="display: grid; gap: 18px;">
          <div class="soft-panel" style="padding: 0; overflow: hidden;">
            <img
              :src="heroImage()"
              @error="(e) => (e.target.src = productFallbackImage(detail.title))"
              style="width: 100%; height: 320px; object-fit: cover; display: block;"
            />
          </div>
          <div class="soft-panel">
            <div class="card-title">基础信息</div>
            <a-row :gutter="16" style="margin-top: 12px;">
              <a-col v-for="row in metaRows" :key="row.label" :xs="12" :md="6">
                <div style="color: var(--ink-500); font-size: 13px;">{{ row.label }}</div>
                <div style="font-weight: 600; margin-top: 4px;">{{ row.value }}</div>
              </a-col>
            </a-row>
          </div>

          <div class="soft-panel">
            <div class="card-title">供需说明</div>
            <p class="card-desc" style="margin-top: 8px;">
              {{ detail.description || '暂无补充说明，平台已完成基础信息核验。' }}
            </p>
          </div>

          <div class="soft-panel">
            <div class="card-title">履约建议</div>
            <a-steps direction="vertical" size="small" :current="2">
              <a-step title="需求沟通" description="确认质量标准、交付周期与结算方式" />
              <a-step title="合同确认" description="签署电子合同，锁定数量与价格" />
              <a-step title="履约交付" description="冷链配送，平台监控节点与温控" />
              <a-step title="售后与评价" description="完成验收并输出交易评价" />
            </a-steps>
          </div>
        </div>
        <a-empty v-else description="未找到该供需信息" />
      </a-spin>
    </a-card>
  </section>
</template>
