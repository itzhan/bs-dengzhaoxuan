<template>
  <div class="art-full-height">
    <ElRow :gutter="16">
      <ElCol :xs="24" :sm="12" :md="6">
        <ElCard shadow="never">
          <div class="text-gray-500">用户数</div>
          <div class="text-2xl font-semibold mt-2">{{ stats.userCount || 0 }}</div>
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :sm="12" :md="6">
        <ElCard shadow="never">
          <div class="text-gray-500">商品数</div>
          <div class="text-2xl font-semibold mt-2">{{ stats.productCount || 0 }}</div>
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :sm="12" :md="6">
        <ElCard shadow="never">
          <div class="text-gray-500">信息发布数</div>
          <div class="text-2xl font-semibold mt-2">{{ stats.listingCount || 0 }}</div>
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :sm="12" :md="6">
        <ElCard shadow="never">
          <div class="text-gray-500">订单数</div>
          <div class="text-2xl font-semibold mt-2">{{ stats.orderCount || 0 }}</div>
        </ElCard>
      </ElCol>
    </ElRow>
  </div>
</template>

<script setup lang="ts">
  import { agriApi } from '@/api/agri'

  const stats = ref<any>({})

  const load = async () => {
    stats.value = await agriApi.getStats()
  }

  onMounted(load)
</script>
