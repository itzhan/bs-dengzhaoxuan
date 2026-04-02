<script setup>
import { computed, onMounted, ref } from 'vue'
import { fetchStatsOverview, fetchCategories } from '../api'

const stats = ref({})
const categoryMap = ref({})
const loading = ref(true)
const error = ref('')

const kpiStats = computed(() => [
  { title: '平台注册用户', value: stats.value.userCount ?? 0, change: '持续增长' },
  { title: '商品数据量', value: stats.value.productCount ?? 0, change: '持续更新' },
  { title: '供需信息量', value: stats.value.listingCount ?? 0, change: '实时同步' },
  { title: '累计订单数', value: stats.value.orderCount ?? 0, change: '持续撮合' }
])

const roleData = computed(() => {
  const dist = stats.value.roleDistribution || {}
  return Object.entries(dist).map(([name, value]) => ({ name, value }))
})

const orderStatusData = computed(() => {
  const dist = stats.value.orderStatusDistribution || {}
  return Object.entries(dist).map(([name, value]) => ({ name, value }))
})

const categoryData = computed(() => {
  const dist = stats.value.categoryDistribution || {}
  return Object.entries(dist).map(([id, value]) => ({
    name: categoryMap.value[id] || `分类#${id}`,
    value
  }))
})

const regionData = computed(() => {
  const dist = stats.value.regionDistribution || {}
  return Object.entries(dist).map(([region, count]) => ({
    region,
    supply: count,
    demand: Math.max(1, Math.round(count * 0.7))
  }))
})

const loadData = async () => {
  loading.value = true
  error.value = ''
  try {
    const [statsData, catData] = await Promise.all([
      fetchStatsOverview(),
      fetchCategories({ page: 1, size: 1000 })
    ])
    stats.value = statsData || {}
    const map = {}
    ;(catData.records || []).forEach((c) => { map[c.id] = c.name })
    categoryMap.value = map
  } catch (err) {
    error.value = err?.message || '数据加载失败'
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <section class="section">
    <h2 class="section-title">平台数据看板</h2>
    <p class="section-subtitle">聚合交易、品类、区域与角色数据，展示平台运行态势。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <a-spin :loading="loading" style="width: 100%;">
      <div class="stat-grid" style="margin-bottom: 20px;">
        <div v-for="item in kpiStats" :key="item.title" class="stat-card">
          <div style="color: var(--ink-500); font-size: 13px;">{{ item.title }}</div>
          <div style="font-size: 22px; font-weight: 600; margin-top: 6px;">{{ item.value }}</div>
          <div style="color: var(--brand-600); font-size: 12px; margin-top: 4px;">{{ item.change }}</div>
        </div>
      </div>

      <div v-if="stats.totalAmount" class="soft-panel" style="margin-bottom: 20px; text-align: center;">
        <div style="color: var(--ink-500); font-size: 13px;">平台交易总金额</div>
        <div style="font-size: 28px; font-weight: 700; color: #2b8a57; margin-top: 6px;">￥{{ Number(stats.totalAmount).toLocaleString() }}</div>
      </div>
    </a-spin>

    <a-row :gutter="20">
      <a-col :xs="24" :md="12">
        <a-card title="用户角色分布" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill>
            <div v-for="item in roleData" :key="item.name">
              <div style="display: flex; justify-content: space-between; font-size: 13px;">
                <span>{{ item.name }}</span>
                <span>{{ item.value }} 人</span>
              </div>
              <a-progress :percent="roleData.length ? Math.round(item.value / (stats.userCount || 1) * 100) : 0" :show-text="false" status="success" />
            </div>
            <a-empty v-if="!roleData.length" description="暂无数据" />
          </a-space>
        </a-card>
      </a-col>
      <a-col :xs="24" :md="12">
        <a-card title="区域用户分布" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill v-if="regionData.length">
            <div v-for="item in regionData" :key="item.region">
              <div style="display: flex; justify-content: space-between; font-size: 13px;">
                <span>{{ item.region }}</span>
                <span>{{ item.supply }} 人</span>
              </div>
              <a-progress :percent="regionData.length ? Math.round(item.supply / (stats.userCount || 1) * 100) : 0" :show-text="false" status="success" />
            </div>
          </a-space>
          <a-empty v-else description="暂无数据" />
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="20" style="margin-top: 20px;">
      <a-col :xs="24" :md="14">
        <a-card title="订单状态分布" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill>
            <div v-for="item in orderStatusData" :key="item.name" class="soft-panel">
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                  <div class="card-title">{{ item.name }}</div>
                </div>
                <a-tag color="green">{{ item.value }} 单</a-tag>
              </div>
              <a-progress :percent="stats.orderCount ? Math.round(item.value / stats.orderCount * 100) : 0" :show-text="false" status="success" />
            </div>
            <a-empty v-if="!orderStatusData.length" description="暂无数据" />
          </a-space>
        </a-card>
      </a-col>
      <a-col :xs="24" :md="10">
        <a-card title="平台服务指标" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill>
            <div class="soft-panel">
              <div class="card-title">资质审核及时率</div>
              <a-progress :percent="95" status="success" />
            </div>
            <div class="soft-panel">
              <div class="card-title">订单响应速度</div>
              <a-progress :percent="90" status="success" />
            </div>
            <div class="soft-panel">
              <div class="card-title">售后满意度</div>
              <a-progress :percent="93" status="success" />
            </div>
          </a-space>
        </a-card>
      </a-col>
    </a-row>
  </section>
</template>
