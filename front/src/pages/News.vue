<script setup>
import { computed, onMounted, ref } from 'vue'
import { fetchNotices } from '../api'

const keyword = ref('')
const loading = ref(true)
const error = ref('')
const notices = ref([])

const filteredNews = computed(() => {
  return notices.value.filter((item) => {
    return keyword.value ? item.title?.includes(keyword.value) : true
  })
})

const formatDate = (val) => (val ? String(val).slice(0, 10) : '')

const loadData = async () => {
  loading.value = true
  error.value = ''
  try {
    const noticeRes = await fetchNotices({ page: 1, size: 20, publishStatus: 2 })
    notices.value = noticeRes.records
  } catch (err) {
    error.value = err?.message || '公告加载失败'
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <section class="section">
    <h2 class="section-title">公告资讯</h2>
    <p class="section-subtitle">展示平台最新动态、政策资讯与行业观察。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <div class="card-surface" style="padding: 18px; margin-bottom: 20px;">
      <a-row :gutter="16" align="center">
        <a-col :xs="24" :md="16">
          <a-input v-model="keyword" allow-clear placeholder="搜索公告标题" />
        </a-col>
        <a-col :xs="24" :md="8" style="display: flex; gap: 10px;">
          <a-button type="primary" @click="keyword = ''">清空搜索</a-button>
        </a-col>
      </a-row>
    </div>

    <a-spin :loading="loading" style="width: 100%;">
      <a-list v-if="filteredNews.length" :bordered="false">
        <a-list-item v-for="item in filteredNews" :key="item.id">
          <a-card class="card-surface" :bordered="false" style="width: 100%;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div style="font-weight: 600; font-size: 16px;">{{ item.title }}</div>
                <div style="color: var(--ink-500); font-size: 12px; margin-top: 4px;">{{ formatDate(item.publishTime) }}</div>
              </div>
              <a-tag color="green">平台公告</a-tag>
            </div>
            <p class="card-desc" style="margin-top: 10px;">{{ item.content || '暂无详情内容' }}</p>
          </a-card>
        </a-list-item>
      </a-list>
      <a-empty v-else description="暂无公告" />
    </a-spin>
  </section>
</template>
