<template>
  <CrudPage title="用户管理" :columns="columns" :fields="fields" :api="api" searchable />
</template>

<script setup lang="ts">
  import CrudPage, { type CrudColumn, type CrudField } from '../components/CrudPage.vue'
  import { agriApi } from '@/api/agri'

  const columns: CrudColumn[] = [
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'username', label: '用户名', width: 140 },
    { prop: 'realName', label: '姓名', width: 120 },
    {
      prop: 'role',
      label: '角色',
      width: 100,
      formatter: (row) => ({ 1: '管理员', 2: '生产方', 3: '采购方' }[row.role] || row.role)
    },
    {
      prop: 'status',
      label: '状态',
      width: 80,
      formatter: (row) => (row.status === 1 ? '启用' : '禁用')
    },
    { prop: 'createdAt', label: '创建时间', width: 160 }
  ]

  const fields: CrudField[] = [
    { prop: 'username', label: '用户名' },
    { prop: 'password', label: '密码' },
    {
      prop: 'role',
      label: '角色',
      type: 'select',
      options: [
        { label: '管理员', value: 1 },
        { label: '生产方', value: 2 },
        { label: '采购方', value: 3 }
      ]
    },
    {
      prop: 'status',
      label: '状态',
      type: 'select',
      defaultValue: 1,
      options: [
        { label: '启用', value: 1 },
        { label: '禁用', value: 2 }
      ]
    },
    { prop: 'realName', label: '姓名' },
    { prop: 'gender', label: '性别', type: 'number' },
    { prop: 'address', label: '地址' }
  ]

  const api = {
    list: agriApi.getUsers,
    create: agriApi.createUser,
    update: agriApi.updateUser,
    remove: agriApi.deleteUser
  }
</script>
