<script setup>
import { computed, onMounted, ref } from 'vue'
import { categoryShare, regionSupply, routePerformance } from '../data/analytics'
import { fetchStatsOverview } from '../api'

const stats = ref({})
const loading = ref(true)
const error = ref('')

const kpiStats = computed(() => [
  { title: '平台注册用户', value: stats.value.userCount ?? 0, change: '持续增长' },
  { title: '商品数据量', value: stats.value.productCount ?? 0, change: '持续更新' },
  { title: '供需信息量', value: stats.value.listingCount ?? 0, change: '实时同步' },
  { title: '累计订单数', value: stats.value.orderCount ?? 0, change: '持续撮合' }
])

const loadData = async () => {
  loading.value = true
  error.value = ''
  try {
    stats.value = (await fetchStatsOverview()) || {}
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
    <p class="section-subtitle">聚合交易、品类、区域与物流履约数据，展示平台运行态势。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <a-spin :loading="loading" style="width: 100%;">
      <div class="stat-grid" style="margin-bottom: 20px;">
        <div v-for="item in kpiStats" :key="item.title" class="stat-card">
          <div style="color: var(--ink-500); font-size: 13px;">{{ item.title }}</div>
          <div style="font-size: 22px; font-weight: 600; margin-top: 6px;">{{ item.value }}</div>
          <div style="color: var(--brand-600); font-size: 12px; margin-top: 4px;">{{ item.change }}</div>
        </div>
      </div>
    </a-spin>

    <a-row :gutter="20">
      <a-col :xs="24" :md="12">
        <a-card title="品类结构" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill>
            <div v-for="item in categoryShare" :key="item.name">
              <div style="display: flex; justify-content: space-between; font-size: 13px;">
                <span>{{ item.name }}</span>
                <span>{{ item.value }}%</span>
              </div>
              <a-progress :percent="item.value" :show-text="false" status="success" />
            </div>
          </a-space>
        </a-card>
      </a-col>
      <a-col :xs="24" :md="12">
        <a-card title="区域供需热度" :bordered="false" class="card-surface">
          <a-table :data="regionSupply" :pagination="false" size="small">
            <a-table-column title="区域" data-index="region" />
            <a-table-column title="供应指数" data-index="supply" />
            <a-table-column title="需求指数" data-index="demand" />
          </a-table>
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="20" style="margin-top: 20px;">
      <a-col :xs="24" :md="14">
        <a-card title="履约路线表现" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill>
            <div v-for="item in routePerformance" :key="item.route" class="soft-panel">
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                  <div class="card-title">{{ item.route }}</div>
                  <div class="card-desc">平均运输时长：{{ item.time }}</div>
                </div>
                <a-tag color="green">{{ item.score }}分</a-tag>
              </div>
              <a-progress :percent="item.score" :show-text="false" status="success" />
            </div>
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
