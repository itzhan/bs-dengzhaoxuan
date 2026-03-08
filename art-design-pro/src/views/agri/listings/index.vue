<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="flex flex-wrap gap-2 mb-3">
        <ElSelect v-model="query.type" placeholder="类型" clearable style="width: 120px">
          <ElOption label="供给" :value="1" />
          <ElOption label="求购" :value="2" />
        </ElSelect>
        <ElSelect v-model="query.status" placeholder="状态" clearable style="width: 140px">
          <ElOption label="待审" :value="1" />
          <ElOption label="通过" :value="2" />
          <ElOption label="驳回" :value="3" />
          <ElOption label="上架" :value="4" />
          <ElOption label="下架" :value="5" />
        </ElSelect>
        <ElInput v-model="query.keyword" placeholder="标题关键词" style="width: 220px" />
        <ElButton @click="reload">查询</ElButton>
        <ElButton type="primary" @click="openDialog()">新增</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn prop="id" label="ID" width="80" />
        <ElTableColumn prop="type" label="类型" width="90">
          <template #default="{ row }">{{ row.type === 1 ? '供给' : '求购' }}</template>
        </ElTableColumn>
        <ElTableColumn prop="title" label="标题" min-width="200" />
        <ElTableColumn prop="quantity" label="数量" width="100" />
        <ElTableColumn prop="unitId" label="单位" width="80" />
        <ElTableColumn prop="price" label="价格" width="90" />
        <ElTableColumn prop="status" label="状态" width="90">
          <template #default="{ row }">{{ statusText(row.status) }}</template>
        </ElTableColumn>
        <ElTableColumn prop="publisherId" label="发布人" width="100" />
        <ElTableColumn label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <ElButton size="small" @click="openDialog(row)">编辑</ElButton>
            <ElButton size="small" type="danger" @click="remove(row)">删除</ElButton>
            <ElDropdown v-if="isAdmin" trigger="click">
              <ElButton size="small" type="success">审核</ElButton>
              <template #dropdown>
                <ElDropdownMenu>
                  <ElDropdownItem @click="audit(row, 2)">通过</ElDropdownItem>
                  <ElDropdownItem @click="audit(row, 3)">驳回</ElDropdownItem>
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

    <ElDialog v-model="dialogVisible" :title="dialogTitle" width="540px">
      <ElForm :model="form" label-width="90px">
        <ElFormItem label="类型">
          <ElSelect v-model="form.type" placeholder="请选择">
            <ElOption label="供给" :value="1" />
            <ElOption label="求购" :value="2" />
          </ElSelect>
        </ElFormItem>
        <ElFormItem label="标题"><ElInput v-model="form.title" /></ElFormItem>
        <ElFormItem label="商品ID"><ElInput v-model="form.productId" /></ElFormItem>
        <ElFormItem label="数量"><ElInputNumber v-model="form.quantity" /></ElFormItem>
        <ElFormItem label="单位ID"><ElInput v-model="form.unitId" /></ElFormItem>
        <ElFormItem label="价格"><ElInputNumber v-model="form.price" /></ElFormItem>
        <ElFormItem label="地点"><ElInput v-model="form.location" /></ElFormItem>
        <ElFormItem label="描述"><ElInput v-model="form.description" type="textarea" rows="3" /></ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" @click="submit">保存</ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { agriApi } from '@/api/agri'
  import { useUserStore } from '@/store/modules/user'

  const userStore = useUserStore()
  const isAdmin = computed(() => userStore.info?.roles?.includes('R_ADMIN'))

  const query = reactive({
    page: 1,
    size: 10,
    type: undefined as any,
    status: undefined as any,
    keyword: ''
  })

  const records = ref<any[]>([])
  const total = ref(0)

  const dialogVisible = ref(false)
  const dialogTitle = ref('新增')
  const editingId = ref<number | null>(null)

  const form = reactive<any>({
    type: 1,
    title: '',
    productId: undefined,
    quantity: 0,
    unitId: undefined,
    price: 0,
    location: '',
    description: ''
  })

  const statusText = (status: number) => {
    const map: Record<number, string> = { 1: '待审', 2: '通过', 3: '驳回', 4: '上架', 5: '下架' }
    return map[status] || '未知'
  }

  const load = async () => {
    const data = await agriApi.getListings(query)
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

  const openDialog = (row?: any) => {
    dialogVisible.value = true
    dialogTitle.value = row ? '编辑' : '新增'
    editingId.value = row?.id ?? null
    if (row) {
      Object.assign(form, row)
    } else {
      Object.assign(form, {
        type: 1,
        title: '',
        productId: undefined,
        quantity: 0,
        unitId: undefined,
        price: 0,
        location: '',
        description: ''
      })
    }
  }

  const submit = async () => {
    const payload = { ...form }
    if (editingId.value) {
      await agriApi.updateListing(editingId.value, payload)
      ElMessage.success('更新成功')
    } else {
      await agriApi.createListing(payload)
      ElMessage.success('创建成功')
    }
    dialogVisible.value = false
    load()
  }

  const remove = async (row: any) => {
    await ElMessageBox.confirm('确认删除该数据吗？', '提示', { type: 'warning' })
    await agriApi.deleteListing(row.id)
    ElMessage.success('删除成功')
    load()
  }

  const audit = async (row: any, status: number) => {
    await agriApi.auditListing(row.id, { status })
    ElMessage.success('审核完成')
    load()
  }

  onMounted(load)
</script>
