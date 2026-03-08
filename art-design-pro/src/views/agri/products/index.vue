<template>
  <CrudPage title="商品管理" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'name', label: '商品名称' },
    { prop: 'categoryId', label: '分类ID', width: 100 },
    { prop: 'unitId', label: '单位ID', width: 100 },
    { prop: 'origin', label: '产地' },
    {
      prop: 'traceable',
      label: '可溯源',
      width: 90,
      formatter: (row) => (row.traceable === 1 ? '是' : '否')
    },
    {
      prop: 'status',
      label: '状态',
      width: 90,
      formatter: (row) => (row.status === 1 ? '上架' : '下架')
    },
    { prop: 'ownerId', label: '生产方ID', width: 110 }
  ]

  const fields: CrudField[] = [
    { prop: 'name', label: '商品名称' },
    { prop: 'categoryId', label: '分类ID', type: 'number' },
    { prop: 'unitId', label: '单位ID', type: 'number' },
    { prop: 'origin', label: '产地' },
    {
      prop: 'traceable',
      label: '可溯源',
      type: 'select',
      defaultValue: 1,
      options: [
        { label: '是', value: 1 },
        { label: '否', value: 0 }
      ]
    },
    {
      prop: 'status',
      label: '状态',
      type: 'select',
      defaultValue: 1,
      options: [
        { label: '上架', value: 1 },
        { label: '下架', value: 2 }
      ]
    },
    { prop: 'ownerId', label: '生产方ID', type: 'number' },
    { prop: 'imageUrl', label: '图片地址' },
    { prop: 'description', label: '描述', type: 'textarea' }
  ]

  const api = {
    list: agriApi.getProducts,
    create: agriApi.createProduct,
    update: agriApi.updateProduct,
    remove: agriApi.deleteProduct
  }
</script>
