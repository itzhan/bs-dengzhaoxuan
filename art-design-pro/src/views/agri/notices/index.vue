<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="flex flex-wrap gap-2 mb-3">
        <ElSelect v-model="query.publishStatus" placeholder="状态" clearable style="width: 140px">
          <ElOption label="草稿" :value="1" />
          <ElOption label="已发布" :value="2" />
        </ElSelect>
        <ElInput v-model="query.keyword" placeholder="标题关键词" style="width: 220px" />
        <ElButton @click="reload">查询</ElButton>
        <ElButton v-if="isAdmin" type="primary" @click="openDialog()">新增公告</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn prop="id" label="ID" width="80" />
        <ElTableColumn prop="title" label="标题" min-width="200" />
        <ElTableColumn prop="publishStatus" label="状态" width="100">
          <template #default="{ row }">{{ row.publishStatus === 2 ? '已发布' : '草稿' }}</template>
        </ElTableColumn>
        <ElTableColumn prop="publishTime" label="发布时间" width="160" />
        <ElTableColumn label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <ElButton v-if="isAdmin" size="small" @click="openDialog(row)">编辑</ElButton>
            <ElButton v-if="isAdmin" size="small" type="success" @click="publish(row)">发布</ElButton>
            <ElButton v-if="isAdmin" size="small" type="danger" @click="remove(row)">删除</ElButton>
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

    <ElDialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <ElForm :model="form" label-width="90px">
        <ElFormItem label="标题"><ElInput v-model="form.title" /></ElFormItem>
        <ElFormItem label="内容"><ElInput v-model="form.content" type="textarea" rows="5" /></ElFormItem>
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
    publishStatus: undefined as any,
    keyword: ''
  })

  const records = ref<any[]>([])
  const total = ref(0)
  const dialogVisible = ref(false)
  const dialogTitle = ref('新增公告')
  const editingId = ref<number | null>(null)

  const form = reactive<any>({
    title: '',
    content: ''
  })

  const load = async () => {
    const data = await agriApi.getNotices(query)
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
    dialogTitle.value = row ? '编辑公告' : '新增公告'
    editingId.value = row?.id ?? null
    if (row) {
      Object.assign(form, {
        title: row.title ?? '',
        content: row.content ?? ''
      })
    } else {
      Object.assign(form, { title: '', content: '' })
    }
  }

  const submit = async () => {
    const payload = { title: form.title, content: form.content }
    if (editingId.value) {
      await agriApi.updateNotice(editingId.value, payload)
      ElMessage.success('更新成功')
    } else {
      await agriApi.createNotice(payload)
      ElMessage.success('创建成功')
    }
    dialogVisible.value = false
    load()
  }

  const publish = async (row: any) => {
    await agriApi.publishNotice(row.id)
    ElMessage.success('已发布')
    load()
  }

  const remove = async (row: any) => {
    await ElMessageBox.confirm('确认删除该公告吗？', '提示', { type: 'warning' })
    await agriApi.deleteNotice(row.id)
    ElMessage.success('删除成功')
    load()
  }

  onMounted(load)
  onActivated(load)
</script>
