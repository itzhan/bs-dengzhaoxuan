<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../api'
import { setAuth } from '../utils/auth'

const router = useRouter()
const loading = ref(false)
const error = ref('')

const form = reactive({
  username: '',
  password: ''
})

const handleLogin = async () => {
  if (!form.username || !form.password) {
    error.value = '请输入用户名和密码'
    return
  }
  loading.value = true
  error.value = ''
  try {
    const data = await login(form)
    setAuth(data.token, {
      id: data.userId,
      username: data.username,
      role: data.role
    })
    router.push('/')
  } catch (err) {
    error.value = err?.message || '登录失败'
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
          <template #title>用户登录</template>
          <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />
          <a-form :model="form" layout="vertical">
            <a-form-item label="用户名">
              <a-input v-model="form.username" placeholder="请输入用户名" />
            </a-form-item>
            <a-form-item label="密码">
              <a-input-password v-model="form.password" placeholder="请输入密码" />
            </a-form-item>
            <a-button type="primary" long :loading="loading" @click="handleLogin">登录</a-button>
            <div style="margin-top: 12px; color: var(--ink-500);">
              还没有账号？<a @click="$router.push('/register')">立即注册</a>
            </div>
          </a-form>
        </a-card>
      </a-col>
    </a-row>
  </section>
</template>
