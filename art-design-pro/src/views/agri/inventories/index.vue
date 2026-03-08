<template>
  <CrudPage title="库存管理" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'producerId', label: '生产方ID', width: 110 },
    { prop: 'productId', label: '商品ID', width: 100 },
    { prop: 'quantity', label: '库存数量', width: 100 },
    { prop: 'unitId', label: '单位ID', width: 90 },
    { prop: 'location', label: '存放位置' }
  ]

  const fields: CrudField[] = [
    { prop: 'producerId', label: '生产方ID', type: 'number' },
    { prop: 'productId', label: '商品ID', type: 'number' },
    { prop: 'quantity', label: '库存数量', type: 'number' },
    { prop: 'unitId', label: '单位ID', type: 'number' },
    { prop: 'location', label: '存放位置' }
  ]

  const api = {
    list: agriApi.getInventories,
    create: agriApi.createInventory,
    update: agriApi.updateInventory,
    remove: agriApi.deleteInventory
  }
</script>
