<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '../api'

const router = useRouter()
const loading = ref(false)
const error = ref('')

const form = reactive({
  username: '',
  password: '',
  confirm: '',
  realName: '',
  role: 2
})

const roleOptions = [
  { label: '供应商（生产方）', value: 2 },
  { label: '求购方（采购用户）', value: 3 }
]

const handleRegister = async () => {
  if (!form.username || !form.password) {
    error.value = '请填写用户名和密码'
    return
  }
  if (form.password !== form.confirm) {
    error.value = '两次密码输入不一致'
    return
  }
  loading.value = true
  error.value = ''
  try {
    await register({
      username: form.username,
      password: form.password,
      role: form.role,
      realName: form.realName
    })
    router.push('/login')
  } catch (err) {
    error.value = err?.message || '注册失败'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="section">
    <a-row justify="center">
      <a-col :xs="24" :md="10" :lg="8">
        <a-card class="card-surface" :bordered="false">
          <template #title>用户注册</template>
          <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />
          <a-form :model="form" layout="vertical">
            <a-form-item label="用户名">
              <a-input v-model="form.username" placeholder="请输入用户名" />
            </a-form-item>
            <a-form-item label="真实姓名">
              <a-input v-model="form.realName" placeholder="请输入真实姓名" />
            </a-form-item>
            <a-form-item label="角色">
              <a-select v-model="form.role" :options="roleOptions" />
            </a-form-item>
            <a-form-item label="密码">
              <a-input-password v-model="form.password" placeholder="请输入密码" />
            </a-form-item>
            <a-form-item label="确认密码">
              <a-input-password v-model="form.confirm" placeholder="再次输入密码" />
            </a-form-item>
            <a-button type="primary" long :loading="loading" @click="handleRegister">注册</a-button>
            <div style="margin-top: 12px; color: var(--ink-500);">
              已有账号？<a @click="$router.push('/login')">去登录</a>
            </div>
          </a-form>
        </a-card>
      </a-col>
    </a-row>
  </section>
</template>
