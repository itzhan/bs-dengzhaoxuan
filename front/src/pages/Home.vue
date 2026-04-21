<script setup>
import { computed, onMounted, ref } from 'vue'
import { coreFlow, platformHighlights, quickInsights } from '../data/home'
import { fetchListings, fetchNotices, fetchRecommend, fetchStatsOverview, fetchUnits, fetchProducts } from '../api'
import { productImageFor, productFallbackImage } from '../utils/productImage'

const loading = ref(true)
const error = ref('')
const stats = ref({})
const supplyList = ref([])
const demandList = ref([])
const notices = ref([])
const unitMap = ref({})
const productMap = ref({})
const recommendList = ref([])

const imageForListing = (item) => {
  const prod = productMap.value[item.productId]
  if (prod?.imageUrl) return prod.imageUrl
  return productFallbackImage(item.title || prod?.name || '农产品')
}

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
    const [statsData, supplyRes, demandRes, noticeRes, unitRes, productRes] = await Promise.all([
      fetchStatsOverview(),
      fetchListings({ page: 1, size: 4, type: 1 }),
      fetchListings({ page: 1, size: 4, type: 2 }),
      fetchNotices({ page: 1, size: 4, publishStatus: 2 }),
      fetchUnits({ page: 1, size: 200 }),
      fetchProducts({ page: 1, size: 500 })
    ])
    const productRecords = productRes?.records || []
    productMap.value = productRecords.reduce((acc, p) => { acc[p.id] = p; return acc }, {})
    stats.value = statsData || {}
    supplyList.value = supplyRes.records
    demandList.value = demandRes.records
    notices.value = noticeRes.records
    const unitRecords = unitRes?.records || []
    unitMap.value = unitRecords.reduce((acc, unit) => {
      acc[unit.id] = unit.symbol || unit.name
      return acc
    }, {})
    // 加载推荐商品
    try {
      const recData = await fetchRecommend(6)
      recommendList.value = recData || []
    } catch {}
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

  <section class="section" v-if="recommendList.length">
    <h2 class="section-title">为您推荐</h2>
    <p class="section-subtitle">基于协同过滤算法，根据订单数据智能推荐您可能感兴趣的商品。</p>
    <a-row :gutter="20">
      <a-col v-for="item in recommendList" :key="item.id" :xs="12" :md="8">
        <div class="soft-panel recommend-card" style="height: 100%;">
          <img class="recommend-img" :src="productImageFor(item)" @error="(e) => (e.target.src = productFallbackImage(item.name))" />
          <div class="card-title" style="margin-top: 10px;">{{ item.name }}</div>
          <div class="card-desc">{{ item.origin || '产地未知' }} · {{ item.description || '' }}</div>
          <a-tag color="green" style="margin-top: 8px;">{{ item.traceable ? '可溯源' : '普通商品' }}</a-tag>
        </div>
      </a-col>
    </a-row>
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
                <div v-for="item in supplyList" :key="item.id" class="soft-panel home-listing">
                  <img class="home-listing-img" :src="imageForListing(item)" @error="(e) => (e.target.src = productFallbackImage(item.title))" />
                  <div style="flex:1; min-width:0;">
                    <div class="card-title" style="display:flex; justify-content:space-between; align-items:center; gap:8px;">
                      <span style="overflow:hidden; text-overflow:ellipsis;">{{ item.title }}</span>
                      <a-tag color="green">{{ item.price ? `￥${item.price}/${formatUnit(item.unitId)}` : '价格面议' }}</a-tag>
                    </div>
                    <div class="card-desc" style="margin-top:4px;">{{ item.location || '产地待补充' }} · 数量 {{ item.quantity }} {{ formatUnit(item.unitId) }}</div>
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
    <p class="section-subtitle">以关键指标呈现平台能力，所有数据实时同步于运行监控系统。</p>
    <a-row :gutter="20">
      <a-col v-for="item in platformHighlights" :key="item.title" :xs="24" :sm="12" :md="6">
        <div class="highlight-card" :style="{ '--hl': item.color }">
          <div class="highlight-top">
            <div class="highlight-icon">
              <component :is="item.icon" />
            </div>
            <div class="highlight-trend" :class="{ up: item.trendUp }">
              <icon-arrow-rise v-if="item.trendUp" />
              <icon-arrow-fall v-else />
              <span>{{ item.trend }}</span>
            </div>
          </div>
          <div class="highlight-title">{{ item.title }}</div>
          <div class="highlight-metric">
            <span class="val">{{ item.value }}</span>
            <span class="unit">{{ item.unit }}</span>
          </div>
          <div class="highlight-metric-label">{{ item.metricLabel }}</div>
          <div class="highlight-bar"><div class="highlight-bar-fill" :style="{ width: item.progress + '%' }"></div></div>
          <p class="highlight-desc">{{ item.desc }}</p>
          <div class="highlight-tags">
            <span v-for="t in item.tags" :key="t" class="highlight-tag">{{ t }}</span>
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

<style scoped>
.recommend-card { display: flex; flex-direction: column; }
.recommend-img {
  width: 100%; aspect-ratio: 5 / 3; object-fit: cover;
  border-radius: 10px; background: #f3f5f4;
}
.home-listing { display: flex; gap: 12px; align-items: center; }
.home-listing-img {
  width: 84px; height: 84px; object-fit: cover;
  border-radius: 10px; background: #f3f5f4; flex-shrink: 0;
}

.highlight-card {
  position: relative;
  height: 100%;
  padding: 20px;
  border-radius: 16px;
  background: linear-gradient(160deg, color-mix(in srgb, var(--hl) 18%, #fff) 0%, #ffffff 60%);
  border: 1px solid color-mix(in srgb, var(--hl) 28%, #e7efe9);
  box-shadow: 0 10px 24px -18px color-mix(in srgb, var(--hl) 60%, #000);
  overflow: hidden;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}
.highlight-card::after {
  content: '';
  position: absolute;
  right: -40px; top: -40px;
  width: 130px; height: 130px;
  border-radius: 50%;
  background: color-mix(in srgb, var(--hl) 18%, transparent);
  pointer-events: none;
}
.highlight-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 18px 32px -20px color-mix(in srgb, var(--hl) 70%, #000);
}
.highlight-top {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 14px;
}
.highlight-icon {
  width: 40px; height: 40px; border-radius: 12px;
  background: var(--hl); color: #fff;
  display: inline-flex; align-items: center; justify-content: center;
  font-size: 20px;
  box-shadow: 0 6px 14px -6px var(--hl);
}
.highlight-trend {
  display: inline-flex; align-items: center; gap: 4px;
  padding: 3px 10px; border-radius: 999px; font-size: 12px;
  background: #fee4e2; color: #b42318;
}
.highlight-trend.up { background: #e3f5e9; color: #0b7a3b; }
.highlight-title { font-size: 15px; font-weight: 600; color: var(--ink-700, #1f2a25); }
.highlight-metric { margin-top: 6px; display: flex; align-items: baseline; gap: 4px; }
.highlight-metric .val { font-size: 32px; font-weight: 700; color: var(--hl); }
.highlight-metric .unit { font-size: 14px; color: var(--ink-500, #5b6a64); font-weight: 600; }
.highlight-metric-label { color: var(--ink-500, #5b6a64); font-size: 12px; margin-top: 2px; }
.highlight-bar {
  margin-top: 10px; height: 6px; border-radius: 999px;
  background: color-mix(in srgb, var(--hl) 12%, #eef3f0);
  overflow: hidden;
}
.highlight-bar-fill {
  height: 100%; border-radius: 999px;
  background: linear-gradient(90deg, var(--hl), color-mix(in srgb, var(--hl) 60%, #fff));
  transition: width 0.4s ease;
}
.highlight-desc {
  margin: 12px 0 10px; font-size: 12.5px; color: var(--ink-500, #5b6a64); line-height: 1.6;
}
.highlight-tags { display: flex; flex-wrap: wrap; gap: 6px; }
.highlight-tag {
  font-size: 11px; padding: 3px 9px; border-radius: 999px;
  background: color-mix(in srgb, var(--hl) 14%, #f5faf7);
  color: color-mix(in srgb, var(--hl) 75%, #1f2a25);
  border: 1px solid color-mix(in srgb, var(--hl) 30%, transparent);
}
</style>
