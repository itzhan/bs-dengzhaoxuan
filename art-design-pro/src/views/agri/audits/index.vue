<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="flex flex-wrap gap-2 mb-3">
        <ElSelect v-model="query.targetType" placeholder="类型" clearable style="width: 140px">
          <ElOption label="发布" :value="1" />
          <ElOption label="资质" :value="2" />
        </ElSelect>
        <ElButton @click="reload">查询</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn prop="id" label="ID" width="80" />
        <ElTableColumn prop="targetType" label="类型" width="90">
          <template #default="{ row }">{{ row.targetType === 1 ? '发布' : '资质' }}</template>
        </ElTableColumn>
        <ElTableColumn prop="targetId" label="目标ID" width="100" />
        <ElTableColumn prop="status" label="结果" width="90">
          <template #default="{ row }">{{ row.status === 1 ? '通过' : '驳回' }}</template>
        </ElTableColumn>
        <ElTableColumn prop="remark" label="备注" />
        <ElTableColumn prop="auditorId" label="审核人" width="100" />
        <ElTableColumn prop="auditTime" label="时间" width="160" />
      </ElTable>

      <div class="flex justify-end mt-3">
        <ElPagination
          background
          layout="total, sizes, prev, pager, next"
          :total="total"
          :current-page="query.page"
          :page-size="query.size"
          @current-change="pageChange"
          @size-change="sizeChange"
        />
      </div>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { agriApi } from '@/api/agri'

  const query = reactive({
    page: 1,
    size: 10,
    targetType: undefined as any
  })

  const records = ref<any[]>([])
  const total = ref(0)

  const load = async () => {
    const data = await agriApi.getAudits(query)
    records.value = data.records || []
    total.value = data.total || 0
  }

  const reload = () => {
    query.page = 1
    load()
  }

  const pageChange = (p: number) => {
    query.page = p
    load()
  }

  const sizeChange = (s: number) => {
    query.size = s
    query.page = 1
    load()
  }

  onMounted(load)
</script>
