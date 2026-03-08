<template>
  <CrudPage title="溯源批次" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'batchNo', label: '批次号', width: 140 },
    { prop: 'productId', label: '商品ID', width: 100 },
    { prop: 'producerId', label: '生产方ID', width: 110 },
    { prop: 'productionDate', label: '生产日期', width: 120 },
    { prop: 'harvestDate', label: '采收日期', width: 120 },
    { prop: 'expiryDate', label: '过期日期', width: 120 },
    { prop: 'qrCodeUrl', label: '二维码' }
  ]

  const fields: CrudField[] = [
    { prop: 'batchNo', label: '批次号' },
    { prop: 'productId', label: '商品ID', type: 'number' },
    { prop: 'producerId', label: '生产方ID', type: 'number' },
    { prop: 'productionDate', label: '生产日期', type: 'date' },
    { prop: 'harvestDate', label: '采收日期', type: 'date' },
    { prop: 'expiryDate', label: '过期日期', type: 'date' },
    { prop: 'traceInfo', label: '溯源信息(JSON)', type: 'textarea' },
    { prop: 'qrCodeUrl', label: '二维码链接' }
  ]

  const api = {
    list: agriApi.getTraces,
    create: agriApi.createTrace,
    update: agriApi.updateTrace,
    remove: agriApi.deleteTrace
  }
</script>
