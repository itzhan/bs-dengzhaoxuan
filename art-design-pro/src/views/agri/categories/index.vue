<template>
  <CrudPage title="分类管理" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'name', label: '名称' },
    { prop: 'parentId', label: '父级ID', width: 100 },
    { prop: 'sortNo', label: '排序', width: 100 }
  ]

  const fields: CrudField[] = [
    { prop: 'name', label: '名称' },
    { prop: 'parentId', label: '父级ID', type: 'number', defaultValue: 0 },
    { prop: 'sortNo', label: '排序', type: 'number', defaultValue: 0 }
  ]

  const api = {
    list: agriApi.getCategories,
    create: agriApi.createCategory,
    update: agriApi.updateCategory,
    remove: agriApi.deleteCategory
  }
</script>
