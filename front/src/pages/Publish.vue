<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { createListing, fetchUnits } from '../api'
import { getUser } from '../utils/auth'

const user = ref(getUser())
const loading = ref(false)
const error = ref('')
const success = ref('')

const unitOptions = ref([])

const form = reactive({
  type: 1,
  title: '',
  quantity: '',
  unitId: null,
  price: '',
  location: '',
  description: '',
  contactName: '',
  contactPhone: ''
})

const isProducer = computed(() => user.value?.role === 'PRODUCER')
const isBuyer = computed(() => user.value?.role === 'BUYER')

const typeOptions = computed(() => {
  if (isProducer.value) return [{ label: '供应信息', value: 1 }]
  if (isBuyer.value) return [{ label: '求购信息', value: 2 }]
  return [
    { label: '供应信息', value: 1 },
    { label: '求购信息', value: 2 }
  ]
})

const showContact = computed(() => form.type === 2)

const resetForm = () => {
  form.title = ''
  form.quantity = ''
  form.unitId = null
  form.price = ''
  form.location = ''
  form.description = ''
  form.contactName = ''
  form.contactPhone = ''
}

const handleSubmit = async () => {
  success.value = ''
  error.value = ''
  if (!user.value) {
    error.value = '请先登录后再发布信息'
    return
  }
  if (!form.title || !form.quantity || !form.unitId) {
    error.value = '请填写标题、数量与单位'
    return
  }
  if (showContact.value && (!form.contactName || !form.contactPhone)) {
    error.value = '求购信息需填写联系人与联系方式'
    return
  }
  loading.value = true
  try {
    await createListing({
      type: form.type,
      title: form.title,
      quantity: Number(form.quantity),
      unitId: form.unitId,
      price: form.price ? Number(form.price) : null,
      location: form.location,
      description: form.description,
      contactName: showContact.value ? form.contactName : null,
      contactPhone: showContact.value ? form.contactPhone : null
    })
    success.value = '发布成功，等待管理员审核'
    resetForm()
  } catch (err) {
    error.value = err?.message || '发布失败'
  } finally {
    loading.value = false
  }
}

const loadUnits = async () => {
  try {
    const res = await fetchUnits({ page: 1, size: 200 })
    unitOptions.value = (res.records || []).map((unit) => ({
      label: unit.symbol || unit.name,
      value: unit.id
    }))
  } catch {
    unitOptions.value = []
  }
}

const syncRole = () => {
  user.value = getUser()
  if (isProducer.value) form.type = 1
  if (isBuyer.value) form.type = 2
}

onMounted(() => {
  syncRole()
  loadUnits()
  window.addEventListener('auth-change', syncRole)
})
</script>

<template>
  <section class="section">
    <h2 class="section-title">发布供需信息</h2>
    <p class="section-subtitle">供应商发布供应信息，求购方发布需求信息。发布后进入审核流程。</p>

    <a-alert v-if="!user" type="info" title="请先登录后再发布" show-icon style="margin-bottom: 16px;" />
    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />
    <a-alert v-if="success" type="success" :title="success" show-icon style="margin-bottom: 16px;" />

    <a-card class="card-surface" :bordered="false">
      <a-form :model="form" layout="vertical">
        <a-form-item label="信息类型">
          <a-select v-model="form.type" :options="typeOptions" :disabled="isProducer || isBuyer" />
        </a-form-item>
        <a-form-item label="标题">
          <a-input v-model="form.title" placeholder="如：嵩山有机苹果供货" />
        </a-form-item>
        <a-row :gutter="16">
          <a-col :xs="24" :md="12">
            <a-form-item label="数量">
              <a-input v-model="form.quantity" placeholder="请输入数量" />
            </a-form-item>
          </a-col>
          <a-col :xs="24" :md="12">
            <a-form-item label="单位">
              <a-select v-model="form.unitId" placeholder="请选择单位" :options="unitOptions" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-row :gutter="16">
          <a-col :xs="24" :md="12">
            <a-form-item label="参考价格">
              <a-input v-model="form.price" placeholder="可选，单位/元" />
            </a-form-item>
          </a-col>
          <a-col :xs="24" :md="12">
            <a-form-item label="所在地区">
              <a-input v-model="form.location" placeholder="如：河南·郑州" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="描述说明">
          <a-textarea v-model="form.description" placeholder="补充产品规格、交付周期等" />
        </a-form-item>

        <template v-if="showContact">
          <a-row :gutter="16">
            <a-col :xs="24" :md="12">
              <a-form-item label="联系人">
                <a-input v-model="form.contactName" placeholder="请输入联系人" />
              </a-form-item>
            </a-col>
            <a-col :xs="24" :md="12">
              <a-form-item label="联系方式">
                <a-input v-model="form.contactPhone" placeholder="请输入手机号或电话" />
              </a-form-item>
            </a-col>
          </a-row>
        </template>

        <a-button type="primary" :loading="loading" :disabled="!user" @click="handleSubmit">提交发布</a-button>
      </a-form>
    </a-card>
  </section>
</template>
