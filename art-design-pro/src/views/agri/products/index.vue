<template>
  <CrudPage title="商品管理" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'
  import { useLookup } from '../composables/useLookup'

  const { categoryMap, unitMap, userMap, categoryOptions, unitOptions, producerOptions, loadCategories, loadUnits, loadUsers } = useLookup()
  onMounted(() => Promise.all([loadCategories(), loadUnits(), loadUsers()]))

  const columns = computed<CrudColumn[]>(() => [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'name', label: '商品名称' },
    { prop: 'categoryId', label: '分类', width: 100, formatter: (row) => categoryMap.value[row.categoryId] || row.categoryId },
    { prop: 'unitId', label: '单位', width: 80, formatter: (row) => unitMap.value[row.unitId] || row.unitId },
    { prop: 'origin', label: '产地' },
    { prop: 'traceable', label: '可溯源', width: 90, formatter: (row) => (row.traceable === 1 ? '是' : '否') },
    { prop: 'status', label: '状态', width: 90, formatter: (row) => (row.status === 1 ? '上架' : '下架') },
    { prop: 'ownerId', label: '生产方', width: 110, formatter: (row) => userMap.value[row.ownerId] || row.ownerId }
  ])

  const fields = computed<CrudField[]>(() => [
    { prop: 'name', label: '商品名称' },
    { prop: 'categoryId', label: '分类', type: 'select', options: categoryOptions.value },
    { prop: 'unitId', label: '单位', type: 'select', options: unitOptions.value },
    { prop: 'origin', label: '产地' },
    { prop: 'traceable', label: '可溯源', type: 'select', defaultValue: 1, options: [{ label: '是', value: 1 }, { label: '否', value: 0 }] },
    { prop: 'status', label: '状态', type: 'select', defaultValue: 1, options: [{ label: '上架', value: 1 }, { label: '下架', value: 2 }] },
    { prop: 'ownerId', label: '生产方', type: 'select', options: producerOptions.value },
    { prop: 'imageUrl', label: '图片地址' },
    { prop: 'description', label: '描述', type: 'textarea' }
  ])

  const api = {
    list: agriApi.getProducts,
    create: agriApi.createProduct,
    update: agriApi.updateProduct,
    remove: agriApi.deleteProduct
  }
</script>
