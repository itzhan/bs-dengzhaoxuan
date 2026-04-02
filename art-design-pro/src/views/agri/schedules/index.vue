<template>
  <CrudPage title="采收/配送日程" :columns="columns" :fields="fields" :api="api" />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'
  import { useLookup } from '../composables/useLookup'

  const { userMap, orderMap, producerOptions, orderOptions, loadUsers, loadOrders } = useLookup()
  onMounted(() => Promise.all([loadUsers(), loadOrders()]))

  const columns = computed<CrudColumn[]>(() => [
    { prop: 'producerId', label: '生产方', width: 110, formatter: (row) => userMap.value[row.producerId] || row.producerId },
    { prop: 'type', label: '类型', width: 90, formatter: (row) => (row.type === 1 ? '采收' : '配送') },
    { prop: 'startTime', label: '开始时间', width: 160 },
    { prop: 'endTime', label: '结束时间', width: 160 },
    { prop: 'location', label: '地点' },
    { prop: 'orderId', label: '关联订单', width: 160, formatter: (row) => orderMap.value[row.orderId] || (row.orderId ? `订单#${row.orderId}` : '—') }
  ])

  const fields = computed<CrudField[]>(() => [
    { prop: 'producerId', label: '生产方', type: 'select', options: producerOptions.value },
    { prop: 'type', label: '类型', type: 'select', defaultValue: 1, options: [{ label: '采收', value: 1 }, { label: '配送', value: 2 }] },
    { prop: 'startTime', label: '开始时间', type: 'datetime' },
    { prop: 'endTime', label: '结束时间', type: 'datetime' },
    { prop: 'location', label: '地点' },
    { prop: 'routePlan', label: '路线规划', type: 'textarea' },
    { prop: 'orderId', label: '关联订单', type: 'select', options: orderOptions.value }
  ])

  const api = {
    list: agriApi.getSchedules,
    create: agriApi.createSchedule,
    update: agriApi.updateSchedule,
    remove: agriApi.deleteSchedule
  }
</script>
