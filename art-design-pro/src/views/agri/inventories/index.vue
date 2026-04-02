<template>
  <CrudPage title="库存管理" :columns="columns" :fields="fields" :api="api" />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'
  import { useLookup } from '../composables/useLookup'

  const { productMap, unitMap, userMap, productOptions, unitOptions, producerOptions, loadProducts, loadUnits, loadUsers } = useLookup()
  onMounted(() => Promise.all([loadProducts(), loadUnits(), loadUsers()]))

  const columns = computed<CrudColumn[]>(() => [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'producerId', label: '生产方', width: 110, formatter: (row) => userMap.value[row.producerId] || row.producerId },
    { prop: 'productId', label: '商品', width: 120, formatter: (row) => productMap.value[row.productId] || row.productId },
    { prop: 'quantity', label: '库存数量', width: 100 },
    { prop: 'unitId', label: '单位', width: 80, formatter: (row) => unitMap.value[row.unitId] || row.unitId },
    { prop: 'location', label: '存放位置' }
  ])

  const fields = computed<CrudField[]>(() => [
    { prop: 'producerId', label: '生产方', type: 'select', options: producerOptions.value },
    { prop: 'productId', label: '商品', type: 'select', options: productOptions.value },
    { prop: 'quantity', label: '库存数量', type: 'number' },
    { prop: 'unitId', label: '单位', type: 'select', options: unitOptions.value },
    { prop: 'location', label: '存放位置' }
  ])

  const api = {
    list: agriApi.getInventories,
    create: agriApi.createInventory,
    update: agriApi.updateInventory,
    remove: agriApi.deleteInventory
  }
</script>
