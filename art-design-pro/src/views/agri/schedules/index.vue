<template>
  <CrudPage title="采收/配送日程" :columns="columns" :fields="fields" :api="api" />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'producerId', label: '生产方ID', width: 110 },
    {
      prop: 'type',
      label: '类型',
      width: 90,
      formatter: (row) => (row.type === 1 ? '采收' : '配送')
    },
    { prop: 'startTime', label: '开始时间', width: 160 },
    { prop: 'endTime', label: '结束时间', width: 160 },
    { prop: 'location', label: '地点' },
    { prop: 'orderId', label: '订单ID', width: 100 }
  ]

  const fields: CrudField[] = [
    { prop: 'producerId', label: '生产方ID', type: 'number' },
    {
      prop: 'type',
      label: '类型',
      type: 'select',
      defaultValue: 1,
      options: [
        { label: '采收', value: 1 },
        { label: '配送', value: 2 }
      ]
    },
    { prop: 'startTime', label: '开始时间', type: 'datetime' },
    { prop: 'endTime', label: '结束时间', type: 'datetime' },
    { prop: 'location', label: '地点' },
    { prop: 'routePlan', label: '路线规划', type: 'textarea' },
    { prop: 'orderId', label: '订单ID', type: 'number' }
  ]

  const api = {
    list: agriApi.getSchedules,
    create: agriApi.createSchedule,
    update: agriApi.updateSchedule,
    remove: agriApi.deleteSchedule
  }
</script>
