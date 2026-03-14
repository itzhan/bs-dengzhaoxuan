<script setup>
import { computed, onMounted, ref } from 'vue'
import { coreFlow, platformHighlights, quickInsights } from '../data/home'
import { fetchListings, fetchNotices, fetchStatsOverview, fetchUnits } from '../api'

const loading = ref(true)
const error = ref('')
const stats = ref({})
const supplyList = ref([])
const demandList = ref([])
const notices = ref([])
const unitMap = ref({})

const heroStats = computed(() => [
  { label: '平台注册用户', value: stats.value.userCount ?? 0, unit: '人' },
  { label: '累计商品数量', value: stats.value.productCount ?? 0, unit: '个' },
  { label: '供需信息总量', value: stats.value.listingCount ?? 0, unit: '条' },
  { label: '撮合订单总量', value: stats.value.orderCount ?? 0, unit: '单' }
])

const formatUnit = (unitId) => unitMap.value[unitId] || '单位'
const formatDate = (val) => (val ? String(val).slice(0, 10) : '')

const loadData = async () => {
  loading.value = true
  error.value = ''
  try {
    const [statsData, supplyRes, demandRes, noticeRes, unitRes] = await Promise.all([
      fetchStatsOverview(),
      fetchListings({ page: 1, size: 4, type: 1 }),
      fetchListings({ page: 1, size: 4, type: 2 }),
      fetchNotices({ page: 1, size: 4, publishStatus: 2 }),
      fetchUnits({ page: 1, size: 200 })
    ])
    stats.value = statsData || {}
    supplyList.value = supplyRes.records
    demandList.value = demandRes.records
    notices.value = noticeRes.records
    const unitRecords = unitRes?.records || []
    unitMap.value = unitRecords.reduce((acc, unit) => {
      acc[unit.id] = unit.symbol || unit.name
      return acc
    }, {})
  } catch (err) {
    error.value = err?.message || '数据加载失败'
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <section class="section hero">
    <div class="hero-card">
      <div>
        <span class="gradient-badge"><icon-apps /> 数字化产销对接</span>
        <h1 class="hero-title">让每一份农产品找到最合适的市场</h1>
        <p class="hero-text">
          平台聚合产地、采购与物流资源，以信息透明、交易可信、履约高效为核心，
          打通“生产-采购-配送-溯源”全链路，让产销对接更简单、更安心。
        </p>
        <div class="hero-actions">
          <a-button type="primary" size="large" @click="$router.push('/market')">查看供需大厅</a-button>
          <a-button size="large" @click="$router.push('/data')">进入数据看板</a-button>
        </div>
      </div>
      <div class="stat-grid">
        <div v-for="item in heroStats" :key="item.label" class="stat-card">
          <div style="color: var(--ink-500); font-size: 13px;">{{ item.label }}</div>
          <div style="font-size: 24px; font-weight: 600; margin-top: 6px;">
            {{ item.value }} <span style="font-size: 14px; color: var(--ink-500);">{{ item.unit }}</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="section">
    <a-alert v-if="error" type="warning" :title="error" show-icon />
  </section>

  <section class="section">
    <h2 class="section-title">产销协同四步走</h2>
    <p class="section-subtitle">从发布到交付，平台覆盖关键节点，提升效率与品质稳定性。</p>
    <div class="flow-grid">
      <div v-for="step in coreFlow" :key="step.title" class="flow-card">
        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
          <div class="flow-icon-wrap">
            <component :is="step.icon" style="font-size: 22px; color: #2b8a57;" />
          </div>
          <div class="gradient-badge">{{ step.title }}</div>
        </div>
        <div class="card-desc">{{ step.desc }}</div>
      </div>
    </div>
  </section>

  <section class="section">
    <h2 class="section-title">实时供需速览</h2>
    <p class="section-subtitle">精选平台最新供应与求购信息，快速掌握市场动态。</p>
    <a-spin :loading="loading" style="width: 100%;">
      <a-row :gutter="20">
        <a-col :xs="24" :md="12">
          <a-card title="优质供应" :bordered="false" class="card-surface">
            <template v-if="supplyList.length">
              <a-space direction="vertical" fill>
                <div v-for="item in supplyList" :key="item.id" class="soft-panel">
                  <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                      <div class="card-title">{{ item.title }}</div>
                      <div class="card-desc">{{ item.location || '产地待补充' }} · 数量 {{ item.quantity }} {{ formatUnit(item.unitId) }}</div>
                    </div>
                    <a-tag color="green">{{ item.price ? `￥${item.price}/${formatUnit(item.unitId)}` : '价格面议' }}</a-tag>
                  </div>
                </div>
              </a-space>
            </template>
            <a-empty v-else description="暂无供应信息" />
          </a-card>
        </a-col>
        <a-col :xs="24" :md="12">
          <a-card title="最新求购" :bordered="false" class="card-surface">
            <template v-if="demandList.length">
              <a-space direction="vertical" fill>
                <div v-for="item in demandList" :key="item.id" class="soft-panel">
                  <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                      <div class="card-title">{{ item.title }}</div>
                      <div class="card-desc">{{ item.location || '区域待补充' }} · 数量 {{ item.quantity }} {{ formatUnit(item.unitId) }}</div>
                    </div>
                    <a-tag color="orange">{{ item.price ? `￥${item.price}/${formatUnit(item.unitId)}` : '价格面议' }}</a-tag>
                  </div>
                </div>
              </a-space>
            </template>
            <a-empty v-else description="暂无求购信息" />
          </a-card>
        </a-col>
      </a-row>
    </a-spin>
  </section>

  <section class="section">
    <h2 class="section-title">平台能力亮点</h2>
    <p class="section-subtitle">围绕交易、履约、溯源与服务持续迭代。</p>
    <a-row :gutter="20">
      <a-col v-for="item in platformHighlights" :key="item.title" :xs="24" :md="12">
        <div class="soft-panel" style="height: 100%; display: flex; gap: 14px; align-items: flex-start;">
          <div class="flow-icon-wrap" style="flex-shrink: 0; margin-top: 2px;">
            <component :is="item.icon" style="font-size: 22px; color: #2b8a57;" />
          </div>
          <div>
            <div class="card-title">{{ item.title }}</div>
            <p class="card-desc">{{ item.desc }}</p>
          </div>
        </div>
      </a-col>
    </a-row>
  </section>

  <section class="section">
    <a-row :gutter="20">
      <a-col :xs="24" :md="14">
        <div class="card-surface" style="padding: 22px;">
          <h3 class="section-title" style="font-size: 24px;">市场洞察</h3>
          <div class="badge-row">
            <span v-for="item in quickInsights" :key="item" class="data-pill">{{ item }}</span>
          </div>
        </div>
      </a-col>
      <a-col :xs="24" :md="10">
        <a-card title="平台公告" :bordered="false" class="card-surface">
          <a-spin :loading="loading">
            <a-list v-if="notices.length" :bordered="false">
              <a-list-item v-for="item in notices" :key="item.id">
                <div>
                  <div style="font-weight: 600;">{{ item.title }}</div>
                  <div style="color: var(--ink-500); font-size: 12px;">{{ formatDate(item.publishTime) }}</div>
                </div>
              </a-list-item>
            </a-list>
            <a-empty v-else description="暂无公告" />
          </a-spin>
        </a-card>
      </a-col>
    </a-row>
  </section>
</template>
