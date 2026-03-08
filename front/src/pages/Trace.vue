<script setup>
import { computed, ref } from 'vue'
import { fetchTraceByBatch } from '../api'

const queryCode = ref('')
const loading = ref(false)
const error = ref('')
const trace = ref(null)

const timeline = computed(() => {
  if (!trace.value) return []
  const items = []
  if (trace.value.productionDate) {
    items.push({ title: '生产日期', time: trace.value.productionDate, desc: '完成种植/生产记录' })
  }
  if (trace.value.harvestDate) {
    items.push({ title: '采收日期', time: trace.value.harvestDate, desc: '完成采收与分级' })
  }
  if (trace.value.expiryDate) {
    items.push({ title: '保质期至', time: trace.value.expiryDate, desc: '建议在此日期前完成销售' })
  }
  return items
})

const handleSearch = async () => {
  if (!queryCode.value) {
    error.value = '请输入溯源批次编号'
    return
  }
  loading.value = true
  error.value = ''
  try {
    trace.value = await fetchTraceByBatch(queryCode.value)
  } catch (err) {
    error.value = err?.message || '未查询到溯源信息'
    trace.value = null
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="section">
    <h2 class="section-title">溯源查询</h2>
    <p class="section-subtitle">输入批次编号或扫描二维码，获取从采收到配送的全链路记录。</p>

    <div class="card-surface" style="padding: 20px; margin-bottom: 20px;">
      <a-row :gutter="16" align="center">
        <a-col :xs="24" :md="16">
          <a-input v-model="queryCode" allow-clear placeholder="请输入溯源批次编号" />
        </a-col>
        <a-col :xs="24" :md="8" style="display: flex; gap: 10px;">
          <a-button type="primary" :loading="loading" @click="handleSearch">立即查询</a-button>
          <a-button @click="queryCode = 'HN-SS-2025-AP-001'">填入示例</a-button>
        </a-col>
      </a-row>
    </div>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <a-row :gutter="20" v-if="trace">
      <a-col :xs="24" :md="14">
        <a-card title="溯源时间线" :bordered="false" class="card-surface">
          <a-timeline v-if="timeline.length">
            <a-timeline-item v-for="item in timeline" :key="item.title">
              <div style="font-weight: 600;">{{ item.title }}</div>
              <div style="color: var(--ink-500); font-size: 12px;">{{ item.time }}</div>
              <div class="card-desc">{{ item.desc }}</div>
            </a-timeline-item>
          </a-timeline>
          <a-empty v-else description="暂无时间节点" />
        </a-card>
      </a-col>
      <a-col :xs="24" :md="10">
        <a-card title="溯源批次信息" :bordered="false" class="card-surface">
          <a-space direction="vertical" fill>
            <div class="soft-panel">
              <div class="card-title">批次编号</div>
              <div>{{ trace.batchNo }}</div>
            </div>
            <div class="soft-panel">
              <div class="card-title">溯源说明</div>
              <div class="card-desc">{{ trace.traceInfo || '暂无补充说明' }}</div>
            </div>
            <div class="soft-panel">
              <div class="card-title">溯源状态</div>
              <a-tag color="green" size="large">已完成记录</a-tag>
              <p class="card-desc" style="margin-top: 8px;">二维码链接：{{ trace.qrCodeUrl || '暂未生成' }}</p>
            </div>
          </a-space>
        </a-card>
      </a-col>
    </a-row>

    <a-empty v-else description="请输入批次编号进行查询" />
  </section>
</template>
