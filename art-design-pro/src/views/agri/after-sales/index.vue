<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="flex flex-wrap gap-2 mb-3">
        <ElSelect v-model="query.status" placeholder="状态" clearable style="width: 140px">
          <ElOption label="待审" :value="1" />
          <ElOption label="通过" :value="2" />
          <ElOption label="驳回" :value="3" />
          <ElOption label="完成" :value="4" />
        </ElSelect>
        <ElButton @click="reload">查询</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn prop="id" label="ID" width="80" />
        <ElTableColumn prop="orderId" label="订单ID" width="100" />
        <ElTableColumn prop="buyerId" label="采购方" width="100" />
        <ElTableColumn prop="sellerId" label="生产方" width="100" />
        <ElTableColumn prop="type" label="类型" width="110">
          <template #default="{ row }">{{ row.type === 1 ? '仅退款' : '退货退款' }}</template>
        </ElTableColumn>
        <ElTableColumn prop="amount" label="金额" width="100" />
        <ElTableColumn prop="status" label="状态" width="90">
          <template #default="{ row }">{{ statusText(row.status) }}</template>
        </ElTableColumn>
        <ElTableColumn label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <ElButton size="small" type="success" @click="audit(row, 2)">通过</ElButton>
            <ElButton size="small" type="danger" @click="audit(row, 3)">驳回</ElButton>
          </template>
        </ElTableColumn>
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
  import { ElMessage } from 'element-plus'
  import { agriApi } from '@/api/agri'

  const query = reactive({
    page: 1,
    size: 10,
    status: undefined as any
  })

  const records = ref<any[]>([])
  const total = ref(0)

  const statusText = (status: number) => {
    const map: Record<number, string> = { 1: '待审', 2: '通过', 3: '驳回', 4: '完成' }
    return map[status] || '未知'
  }

  const load = async () => {
    const data = await agriApi.getAfterSales(query)
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

  const audit = async (row: any, status: number) => {
    await agriApi.auditAfterSale(row.id, status)
    ElMessage.success('操作成功')
    load()
  }

  onMounted(load)
</script>
