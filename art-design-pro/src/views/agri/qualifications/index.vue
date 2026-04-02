<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="flex flex-wrap gap-2 mb-3">
        <ElSelect v-model="query.status" placeholder="状态" clearable style="width: 140px">
          <ElOption label="待审" :value="1" />
          <ElOption label="通过" :value="2" />
          <ElOption label="驳回" :value="3" />
        </ElSelect>
        <ElButton @click="reload">查询</ElButton>
        <ElButton type="primary" @click="openDialog()">提交资质</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn prop="id" label="ID" width="80" />
        <ElTableColumn prop="userId" label="用户" width="120">
          <template #default="{ row }">{{ userMap[row.userId] || row.userId }}</template>
        </ElTableColumn>
        <ElTableColumn prop="type" label="类型" width="140" />
        <ElTableColumn prop="number" label="编号" width="180" />
        <ElTableColumn prop="status" label="状态" width="90">
          <template #default="{ row }">{{ statusText(row.status) }}</template>
        </ElTableColumn>
        <ElTableColumn prop="remark" label="审核意见" />
        <ElTableColumn label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <ElButton size="small" @click="openDialog(row)">编辑</ElButton>
            <ElButton v-if="isAdmin" size="small" type="success" @click="audit(row, 2)">通过</ElButton>
            <ElButton v-if="isAdmin" size="small" type="danger" @click="openRejectDialog(row)">驳回</ElButton>
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

    <ElDialog v-model="dialogVisible" :title="dialogTitle" width="520px">
      <ElForm :model="form" label-width="90px">
        <ElFormItem label="类型"><ElInput v-model="form.type" /></ElFormItem>
        <ElFormItem label="编号"><ElInput v-model="form.number" /></ElFormItem>
        <ElFormItem label="文件URL"><ElInput v-model="form.fileUrl" /></ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" @click="submit">保存</ElButton>
      </template>
    </ElDialog>

    <ElDialog v-model="rejectDialogVisible" title="驳回原因" width="420px">
      <ElForm label-width="80px">
        <ElFormItem label="驳回原因">
          <ElInput v-model="rejectRemark" type="textarea" rows="3" placeholder="请填写驳回原因（必填）" />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="rejectDialogVisible = false">取消</ElButton>
        <ElButton type="danger" @click="submitReject">确认驳回</ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { ElMessage } from 'element-plus'
  import { agriApi } from '@/api/agri'
  import { useUserStore } from '@/store/modules/user'
  import { useLookup } from '../composables/useLookup'

  const userStore = useUserStore()
  const isAdmin = computed(() => userStore.info?.roles?.includes('R_ADMIN'))

  const { userMap, loadUsers } = useLookup()
  onMounted(() => loadUsers())

  const query = reactive({
    page: 1,
    size: 10,
    status: undefined as any
  })

  const records = ref<any[]>([])
  const total = ref(0)
  const dialogVisible = ref(false)
  const dialogTitle = ref('提交资质')
  const editingId = ref<number | null>(null)

  const form = reactive<any>({
    type: '',
    number: '',
    fileUrl: ''
  })

  const statusText = (status: number) => {
    const map: Record<number, string> = { 1: '待审', 2: '通过', 3: '驳回' }
    return map[status] || '未知'
  }

  const load = async () => {
    const data = await agriApi.getQualifications(query)
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
    dialogTitle.value = row ? '编辑资质' : '提交资质'
    editingId.value = row?.id ?? null
    if (row) {
      Object.assign(form, {
        type: row.type ?? '',
        number: row.number ?? '',
        fileUrl: row.fileUrl ?? ''
      })
    } else {
      Object.assign(form, { type: '', number: '', fileUrl: '' })
    }
  }

  const submit = async () => {
    const payload = { type: form.type, number: form.number, fileUrl: form.fileUrl }
    if (editingId.value) {
      await agriApi.updateQualification(editingId.value, payload)
      ElMessage.success('更新成功')
    } else {
      await agriApi.createQualification(payload)
      ElMessage.success('提交成功')
    }
    dialogVisible.value = false
    load()
  }

  const audit = async (row: any, status: number, remark?: string) => {
    await agriApi.auditQualification(row.id, { status, remark })
    ElMessage.success('审核完成')
    load()
  }

  const rejectDialogVisible = ref(false)
  const rejectRemark = ref('')
  const rejectingRow = ref<any>(null)

  const openRejectDialog = (row: any) => {
    rejectingRow.value = row
    rejectRemark.value = ''
    rejectDialogVisible.value = true
  }

  const submitReject = async () => {
    if (!rejectRemark.value.trim()) {
      ElMessage.warning('请填写驳回原因')
      return
    }
    await audit(rejectingRow.value, 3, rejectRemark.value.trim())
    rejectDialogVisible.value = false
  }

  onMounted(load)
  onActivated(load)
</script>
