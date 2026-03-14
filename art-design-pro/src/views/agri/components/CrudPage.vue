<template>
  <div class="art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <div class="font-medium mb-2">{{ title }}</div>
      <div class="flex flex-wrap gap-2 mb-3">
        <ElInput v-if="searchable" v-model="keyword" placeholder="关键词" style="max-width: 260px" />
        <ElButton @click="reload">查询</ElButton>
        <ElButton type="primary" @click="openDialog()">新增</ElButton>
      </div>

      <ElTable :data="records" border style="width: 100%">
        <ElTableColumn
          v-for="col in columns"
          :key="col.prop"
          :prop="col.prop"
          :label="col.label"
          :width="col.width"
          :formatter="col.formatter"
        />
        <ElTableColumn label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <ElButton size="small" @click="openDialog(row)">编辑</ElButton>
            <ElButton size="small" type="danger" @click="handleDelete(row)">删除</ElButton>
          </template>
        </ElTableColumn>
      </ElTable>

      <div class="flex justify-end mt-3">
        <ElPagination
          background
          layout="total, sizes, prev, pager, next"
          :total="total"
          :current-page="page"
          :page-size="size"
          @current-change="handlePageChange"
          @size-change="handleSizeChange"
        />
      </div>
    </ElCard>

    <ElDialog v-model="dialogVisible" :title="dialogTitle" width="520px">
      <ElForm :model="formData" label-width="90px">
        <ElFormItem v-for="field in fields" :key="field.prop" :label="field.label">
          <component
            :is="getFieldComponent(field)"
            v-model="formData[field.prop]"
            v-bind="getFieldProps(field)"
          >
            <template v-if="field.type === 'select'" #default>
              <ElOption
                v-for="opt in field.options || []"
                :key="opt.value"
                :label="opt.label"
                :value="opt.value"
              />
            </template>
          </component>
        </ElFormItem>
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

  export interface CrudColumn {
    prop: string
    label: string
    width?: number
    formatter?: (row: any) => string
  }

  export interface CrudFieldOption {
    label: string
    value: any
  }

  export interface CrudField {
    prop: string
    label: string
    type?: 'input' | 'textarea' | 'number' | 'select' | 'switch' | 'date' | 'datetime'
    options?: CrudFieldOption[]
    placeholder?: string
    readonly?: boolean
    defaultValue?: any
  }

  interface CrudApi {
    list: (params: any) => Promise<{ records: any[]; total: number }>
    create: (data: any) => Promise<any>
    update: (id: number, data: any) => Promise<any>
    remove: (id: number) => Promise<any>
  }

  const props = defineProps<{
    title: string
    columns: CrudColumn[]
    fields: CrudField[]
    api: CrudApi
    searchable?: boolean
    extraParams?: Record<string, any>
  }>()

  const page = ref(1)
  const size = ref(10)
  const total = ref(0)
  const records = ref<any[]>([])
  const keyword = ref('')

  const dialogVisible = ref(false)
  const dialogTitle = ref('新增')
  const formData = reactive<Record<string, any>>({})
  const editingId = ref<number | null>(null)

  const load = async () => {
    const params = {
      page: page.value,
      size: size.value,
      ...(props.searchable && keyword.value ? { keyword: keyword.value } : {}),
      ...(props.extraParams || {})
    }
    const data = await props.api.list(params)
    records.value = data.records || []
    total.value = data.total || 0
  }

  const reload = () => {
    page.value = 1
    load()
  }

  const handlePageChange = (p: number) => {
    page.value = p
    load()
  }

  const handleSizeChange = (s: number) => {
    size.value = s
    page.value = 1
    load()
  }

  const openDialog = (row?: any) => {
    dialogVisible.value = true
    dialogTitle.value = row ? '编辑' : '新增'
    editingId.value = row?.id ?? null
    props.fields.forEach((field) => {
      if (row) {
        formData[field.prop] = row[field.prop]
      } else {
        formData[field.prop] = field.defaultValue ?? ''
      }
    })
  }

  const submit = async () => {
    const payload: Record<string, any> = {}
    props.fields.forEach((field) => {
      payload[field.prop] = formData[field.prop]
    })
    if (editingId.value) {
      await props.api.update(editingId.value, payload)
      ElMessage.success('更新成功')
    } else {
      await props.api.create(payload)
      ElMessage.success('创建成功')
    }
    dialogVisible.value = false
    load()
  }

  const handleDelete = async (row: any) => {
    await ElMessageBox.confirm('确认删除该数据吗？', '提示', { type: 'warning' })
    await props.api.remove(row.id)
    ElMessage.success('删除成功')
    load()
  }

  const getFieldComponent = (field: CrudField) => {
    switch (field.type) {
      case 'textarea':
        return 'ElInput'
      case 'number':
        return 'ElInputNumber'
      case 'select':
        return 'ElSelect'
      case 'switch':
        return 'ElSwitch'
      case 'date':
        return 'ElDatePicker'
      case 'datetime':
        return 'ElDatePicker'
      default:
        return 'ElInput'
    }
  }

  const getFieldProps = (field: CrudField) => {
    const props: Record<string, any> = {
      placeholder: field.placeholder || `请输入${field.label}`,
      disabled: field.readonly
    }
    if (field.type === 'textarea') {
      props.type = 'textarea'
      props.rows = 3
    }
    if (field.type === 'date') {
      props.type = 'date'
      props.valueFormat = 'YYYY-MM-DD'
    }
    if (field.type === 'datetime') {
      props.type = 'datetime'
      props.valueFormat = 'YYYY-MM-DD HH:mm:ss'
    }
    if (field.type === 'select') {
      props.clearable = true
    }
    return props
  }

  onMounted(load)
  onActivated(load)
</script>
