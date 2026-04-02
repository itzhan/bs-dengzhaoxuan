<script setup>
import { computed, onMounted, ref } from 'vue'
import { fetchListings, fetchUnits, fetchTraceByBatch, fetchTraces } from '../api'

const FAVORITES_KEY = 'agri_favorites'

const activeTab = ref('supply')
const keyword = ref('')
const area = ref(null)
const unit = ref(null)
const loading = ref(true)
const error = ref('')

const supplyList = ref([])
const demandList = ref([])
const unitMap = ref({})
// 收藏响应式版本号
const favVersion = ref(0)

const toText = (val) => (typeof val === 'string' ? val : val == null ? '' : String(val))

const marketStats = computed(() => [
  { label: '供应信息', value: supplyList.value.length, unit: '条' },
  { label: '求购需求', value: demandList.value.length, unit: '条' },
  { label: '供需合计', value: supplyList.value.length + demandList.value.length, unit: '条' },
  { label: '数据更新时间', value: new Date().toLocaleDateString(), unit: '' }
])

const areaOptions = computed(() => {
  const values = new Set()
  ;[...supplyList.value, ...demandList.value].forEach((item) => {
    const locationText = toText(item.location)
    if (!locationText) return
    const label = locationText.split(/[·\s]/)[0]
    if (label) values.add(label)
  })
  return Array.from(values).map((value) => ({ label: value, value }))
})

const unitOptions = computed(() => {
  return Object.entries(unitMap.value).map(([id, label]) => ({ label, value: Number(id) }))
})

const formatUnit = (unitId) => unitMap.value[unitId] || '单位'

const filteredSupply = computed(() => {
  return supplyList.value.filter((item) => {
    const titleText = toText(item.title)
    const locationText = toText(item.location)
    const matchKeyword = keyword.value
      ? titleText.includes(keyword.value) || locationText.includes(keyword.value)
      : true
    const matchArea = area.value ? locationText.includes(area.value) : true
    const matchUnit = unit.value ? item.unitId === unit.value : true
    return matchKeyword && matchArea && matchUnit
  })
})

const filteredDemand = computed(() => {
  return demandList.value.filter((item) => {
    const titleText = toText(item.title)
    const locationText = toText(item.location)
    const matchKeyword = keyword.value
      ? titleText.includes(keyword.value) || locationText.includes(keyword.value)
      : true
    const matchArea = area.value ? locationText.includes(area.value) : true
    const matchUnit = unit.value ? item.unitId === unit.value : true
    return matchKeyword && matchArea && matchUnit
  })
})

const resetFilters = () => {
  keyword.value = ''
  area.value = null
  unit.value = null
}

const loadData = async () => {
  loading.value = true
  error.value = ''
  try {
    const [supplyRes, demandRes, unitRes] = await Promise.all([
      fetchListings({ page: 1, size: 100, type: 1 }),
      fetchListings({ page: 1, size: 100, type: 2 }),
      fetchUnits({ page: 1, size: 200 })
    ])
    supplyList.value = supplyRes.records
    demandList.value = demandRes.records
    const unitRecords = unitRes?.records || []
    unitMap.value = unitRecords.reduce((acc, unit) => {
      acc[unit.id] = unit.symbol || unit.name
      return acc
    }, {})
  } catch (err) {
    error.value = err?.message || '供需数据加载失败'
  } finally {
    loading.value = false
  }
}

const isFavorited = (itemId) => {
  // 依赖 favVersion 确保响应式更新
  void favVersion.value
  try {
    const raw = localStorage.getItem(FAVORITES_KEY)
    const favs = raw ? JSON.parse(raw) : []
    return favs.some((f) => f.id === itemId)
  } catch {
    return false
  }
}

const toggleFavorite = (item) => {
  try {
    const raw = localStorage.getItem(FAVORITES_KEY)
    let favs = raw ? JSON.parse(raw) : []
    const idx = favs.findIndex((f) => f.id === item.id)
    if (idx >= 0) {
      favs.splice(idx, 1)
    } else {
      favs.push({ id: item.id, title: item.title, location: item.location, price: item.price, type: item.type })
    }
    localStorage.setItem(FAVORITES_KEY, JSON.stringify(favs))
    favVersion.value++
  } catch {}
}

// 溯源弹窗
const traceVisible = ref(false)
const traceLoading = ref(false)
const traceData = ref(null)
const traceError = ref('')

const traceInfoLabels = {
  farm: '产地/农场', pesticide: '农药使用', fertilizer: '肥料', irrigation: '灌溉方式',
  soil: '土壤类型', variety: '品种', origin: '产地', method: '种植方式',
  certification: '认证', storage: '储存方式', transport: '运输方式', temperature: '温控',
  inspector: '质检员', result: '检测结果', weight: '重量', grade: '等级'
}

const parsedTraceInfo = computed(() => {
  if (!traceData.value?.traceInfo) return null
  try {
    const obj = typeof traceData.value.traceInfo === 'string'
      ? JSON.parse(traceData.value.traceInfo) : traceData.value.traceInfo
    if (typeof obj !== 'object' || obj === null) return null
    return Object.entries(obj).map(([key, value]) => ({
      label: traceInfoLabels[key] || key,
      value: String(value)
    }))
  } catch { return null }
})

const showTrace = async (item) => {
  traceVisible.value = true
  traceLoading.value = true
  traceData.value = null
  traceError.value = ''
  try {
    const traces = await fetchTraces({ productId: item.productId, page: 1, size: 1 })
    const records = traces?.records || []
    if (records.length && records[0].batchNo) {
      traceData.value = await fetchTraceByBatch(records[0].batchNo)
    } else {
      traceError.value = '该商品暂无溯源记录'
    }
  } catch {
    traceError.value = '溯源信息查询失败'
  } finally {
    traceLoading.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <section class="section">
    <h2 class="section-title">供需大厅</h2>
    <p class="section-subtitle">公开展示平台最新供需信息，支持按区域、关键词与单位筛选。</p>

    <div class="stat-grid" style="margin-bottom: 24px;">
      <div v-for="item in marketStats" :key="item.label" class="stat-card">
        <div style="color: var(--ink-500); font-size: 13px;">{{ item.label }}</div>
        <div style="font-size: 22px; font-weight: 600; margin-top: 6px;">
          {{ item.value }}<span style="font-size: 13px; color: var(--ink-500); margin-left: 4px;">{{ item.unit }}</span>
        </div>
      </div>
    </div>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <div class="card-surface" style="padding: 18px; margin-bottom: 20px;">
      <a-row :gutter="16" align="center">
        <a-col :xs="24" :sm="12" :md="8">
          <a-input v-model="keyword" allow-clear placeholder="输入关键词，如苹果/红薯" />
        </a-col>
        <a-col :xs="12" :sm="6" :md="6">
          <a-select v-model="area" allow-clear placeholder="选择区域" :options="areaOptions" />
        </a-col>
        <a-col :xs="12" :sm="6" :md="4">
          <a-select v-model="unit" allow-clear placeholder="单位" :options="unitOptions" />
        </a-col>
        <a-col :xs="24" :md="6" style="display: flex; gap: 10px;">
          <a-button type="primary" @click="resetFilters">清空筛选</a-button>
          <a-button @click="$router.push('/trace')">溯源查询</a-button>
        </a-col>
      </a-row>
    </div>

    <a-tabs v-model:active-key="activeTab" type="rounded">
      <a-tab-pane key="supply" title="供应信息">
        <a-spin :loading="loading" style="width: 100%;">
          <a-row :gutter="20" v-if="filteredSupply.length">
            <a-col v-for="item in filteredSupply" :key="item.id" :xs="24" :md="12">
              <a-card class="card-surface" :bordered="false">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                  <div>
                    <div class="card-title">{{ item.title }}</div>
                    <div class="card-desc">{{ item.location || '产地待补充' }} · 数量 {{ item.quantity }} {{ formatUnit(item.unitId) }}</div>
                  </div>
                  <a-tag color="green">{{ item.price ? `￥${item.price}/${formatUnit(item.unitId)}` : '价格面议' }}</a-tag>
                </div>
                <div style="margin-top: 12px; display: flex; gap: 8px;">
                  <a-button type="primary" @click="$router.push(`/market/supply/${item.id}`)">查看详情</a-button>
                  <a-button @click="toggleFavorite(item)">
                    <template #icon><icon-heart-fill v-if="isFavorited(item.id)" /><icon-heart v-else /></template>
                    {{ isFavorited(item.id) ? '已收藏' : '收藏' }}
                  </a-button>
                  <a-button @click="showTrace(item)">查看溯源</a-button>
                </div>
              </a-card>
            </a-col>
          </a-row>
          <a-empty v-else description="暂无供应信息" />
        </a-spin>
      </a-tab-pane>
      <a-tab-pane key="demand" title="求购需求">
        <a-spin :loading="loading" style="width: 100%;">
          <a-row :gutter="20" v-if="filteredDemand.length">
            <a-col v-for="item in filteredDemand" :key="item.id" :xs="24" :md="12">
              <a-card class="card-surface" :bordered="false">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                  <div>
                    <div class="card-title">{{ item.title }}</div>
                    <div class="card-desc">{{ item.location || '区域待补充' }} · 数量 {{ item.quantity }} {{ formatUnit(item.unitId) }}</div>
                    <div class="card-desc" v-if="item.contactPhone">联系人：{{ item.contactName || '未填写' }} · {{ item.contactPhone }}</div>
                  </div>
                  <a-tag color="orange">{{ item.price ? `￥${item.price}/${formatUnit(item.unitId)}` : '价格面议' }}</a-tag>
                </div>
                <div style="margin-top: 12px; display: flex; gap: 8px;">
                  <a-button type="primary" @click="$router.push(`/market/demand/${item.id}`)">查看详情</a-button>
                </div>
              </a-card>
            </a-col>
          </a-row>
          <a-empty v-else description="暂无求购需求" />
        </a-spin>
      </a-tab-pane>
    </a-tabs>

    <!-- 溯源弹窗 -->
    <a-modal v-model:visible="traceVisible" title="溯源信息" :footer="false" width="520px">
      <a-spin :loading="traceLoading" style="width: 100%;">
        <a-alert v-if="traceError" type="warning" :title="traceError" show-icon />
        <template v-if="traceData">
          <a-descriptions :column="1" bordered size="small" style="margin-bottom: 16px;">
            <a-descriptions-item label="批次编号">{{ traceData.batchNo }}</a-descriptions-item>
            <a-descriptions-item label="生产日期">{{ traceData.productionDate || '—' }}</a-descriptions-item>
            <a-descriptions-item label="采收日期">{{ traceData.harvestDate || '—' }}</a-descriptions-item>
            <a-descriptions-item label="保质期至">{{ traceData.expiryDate || '—' }}</a-descriptions-item>
          </a-descriptions>
          <template v-if="parsedTraceInfo">
            <div style="font-weight: 600; margin-bottom: 8px;">溯源详情</div>
            <a-descriptions :column="1" bordered size="small">
              <a-descriptions-item v-for="info in parsedTraceInfo" :key="info.label" :label="info.label">
                {{ info.value }}
              </a-descriptions-item>
            </a-descriptions>
          </template>
          <div v-else-if="traceData.traceInfo" class="card-desc" style="margin-top: 8px;">{{ traceData.traceInfo }}</div>
        </template>
      </a-spin>
    </a-modal>
  </section>
</template>
