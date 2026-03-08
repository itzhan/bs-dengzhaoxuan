<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="flex flex-wrap gap-2 mb-3">
        <ElSelect v-model="query.status" placeholder="状态" clearable style="width: 140px">
          <ElOption label="待确认" :value="1" />
          <ElOption label="已确认" :value="2" />
          <ElOption label="配送中" :value="3" />
          <ElOption label="已送达" :value="4" />
          <ElOption label="已完成" :value="5" />
          <ElOption label="已取消" :value="6" />
          <ElOption label="售后中" :value="7" />
        </ElSelect>
        <ElInput v-model="query.keyword" placeholder="订单号" style="width: 220px" />
        <ElButton @click="reload">查询</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn prop="id" label="ID" width="80" />
        <ElTableColumn prop="orderNo" label="订单号" width="180" />
        <ElTableColumn prop="buyerId" label="采购方" width="100" />
        <ElTableColumn prop="sellerId" label="生产方" width="100" />
        <ElTableColumn prop="totalAmount" label="总金额" width="100" />
        <ElTableColumn prop="totalQuantity" label="总数量" width="100" />
        <ElTableColumn prop="status" label="状态" width="100">
          <template #default="{ row }">{{ statusText(row.status) }}</template>
        </ElTableColumn>
        <ElTableColumn prop="createdAt" label="创建时间" width="160" />
        <ElTableColumn label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <ElButton size="small" @click="showDetail(row)">详情</ElButton>
            <ElDropdown trigger="click">
              <ElButton size="small" type="success">改状态</ElButton>
              <template #dropdown>
                <ElDropdownMenu>
                  <ElDropdownItem @click="updateStatus(row, 2)">已确认</ElDropdownItem>
                  <ElDropdownItem @click="updateStatus(row, 3)">配送中</ElDropdownItem>
                  <ElDropdownItem @click="updateStatus(row, 4)">已送达</ElDropdownItem>
                  <ElDropdownItem @click="updateStatus(row, 5)">已完成</ElDropdownItem>
                  <ElDropdownItem @click="updateStatus(row, 6)">已取消</ElDropdownItem>
                </ElDropdownMenu>
              </template>
            </ElDropdown>
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

    <ElDialog v-model="detailVisible" title="订单详情" width="700px">
      <ElDescriptions :column="2" border>
        <ElDescriptionsItem label="订单号">{{ detail?.order?.orderNo }}</ElDescriptionsItem>
        <ElDescriptionsItem label="状态">{{ statusText(detail?.order?.status) }}</ElDescriptionsItem>
        <ElDescriptionsItem label="采购方">{{ detail?.order?.buyerId }}</ElDescriptionsItem>
        <ElDescriptionsItem label="生产方">{{ detail?.order?.sellerId }}</ElDescriptionsItem>
        <ElDescriptionsItem label="总金额">{{ detail?.order?.totalAmount }}</ElDescriptionsItem>
        <ElDescriptionsItem label="总数量">{{ detail?.order?.totalQuantity }}</ElDescriptionsItem>
        <ElDescriptionsItem label="收货地址" :span="2">{{ detail?.order?.deliveryAddress }}</ElDescriptionsItem>
      </ElDescriptions>
      <div class="mt-4">
        <ElTable :data="detail?.items || []" border>
          <ElTableColumn prop="productName" label="商品" />
          <ElTableColumn prop="quantity" label="数量" width="100" />
          <ElTableColumn prop="price" label="单价" width="100" />
          <ElTableColumn prop="amount" label="小计" width="100" />
        </ElTable>
      </div>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { ElMessage } from 'element-plus'
  import { agriApi } from '@/api/agri'

  const query = reactive({
    page: 1,
    size: 10,
    status: undefined as any,
    keyword: ''
  })

  const records = ref<any[]>([])
  const total = ref(0)

  const detailVisible = ref(false)
  const detail = ref<any>(null)

  const statusText = (status: number) => {
    const map: Record<number, string> = {
      1: '待确认',
      2: '已确认',
      3: '配送中',
      4: '已送达',
      5: '已完成',
      6: '已取消',
      7: '售后中'
    }
    return map[status] || '未知'
  }

  const load = async () => {
    const data = await agriApi.getOrders(query)
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

  const showDetail = async (row: any) => {
    detail.value = await agriApi.getOrderDetail(row.id)
    detailVisible.value = true
  }

  const updateStatus = async (row: any, status: number) => {
    await agriApi.updateOrderStatus(row.id, status)
    ElMessage.success('状态已更新')
    load()
  }

  onMounted(load)
</script>
