<template>
  <CrudPage title="单位管理" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'name', label: '名称' },
    { prop: 'symbol', label: '符号', width: 120 }
  ]

  const fields: CrudField[] = [
    { prop: 'name', label: '名称' },
    { prop: 'symbol', label: '符号' }
  ]

  const api = {
    list: agriApi.getUnits,
    create: agriApi.createUnit,
    update: agriApi.updateUnit,
    remove: agriApi.deleteUnit
  }
</script>
