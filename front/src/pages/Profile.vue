<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchMe, fetchMyListings, fetchMyQualifications, fetchMyAfterSales } from '../api'
import { getUser, isLoggedIn } from '../utils/auth'

const router = useRouter()
const user = ref(null)
const loading = ref(true)
const error = ref('')

const FAVORITES_KEY = 'agri_favorites'
const favorites = ref([])

const myListings = ref([])
const myQualifications = ref([])
const myAfterSales = ref([])

const roleLabels = { 1: '管理员', 2: '生产方', 3: '采购方' }
const genderLabels = { 0: '未知', 1: '男', 2: '女' }

const listingStatusMap = { 1: { text: '待审核', color: 'orange' }, 2: { text: '审核通过', color: 'green' }, 3: { text: '已驳回', color: 'red' }, 4: { text: '上架中', color: 'green' }, 5: { text: '已下架', color: 'gray' } }
const qualStatusMap = { 1: { text: '待审核', color: 'orange' }, 2: { text: '审核通过', color: 'green' }, 3: { text: '已驳回', color: 'red' } }
const afterSaleStatusMap = { 1: { text: '待处理', color: 'orange' }, 2: { text: '通过', color: 'green' }, 3: { text: '已驳回', color: 'red' }, 4: { text: '已完成', color: 'green' } }

const loadFavorites = () => {
  try {
    const raw = localStorage.getItem(FAVORITES_KEY)
    favorites.value = raw ? JSON.parse(raw) : []
  } catch {
    favorites.value = []
  }
}

const removeFavorite = (index) => {
  favorites.value.splice(index, 1)
  localStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites.value))
}

const loadMyData = async (uid) => {
  try {
    const [listRes, qualRes, asRes] = await Promise.all([
      fetchMyListings({ page: 1, size: 100, publisherId: uid }),
      fetchMyQualifications({ page: 1, size: 100 }),
      fetchMyAfterSales({ page: 1, size: 100 })
    ])
    myListings.value = listRes.records || []
    myQualifications.value = qualRes.records || []
    myAfterSales.value = asRes.records || []
  } catch {}
}

onMounted(async () => {
  if (!isLoggedIn()) {
    router.push('/login')
    return
  }
  loading.value = true
  try {
    const data = await fetchMe()
    user.value = data || getUser()
  } catch {
    user.value = getUser()
  } finally {
    loading.value = false
  }
  loadFavorites()
  if (user.value?.id || user.value?.userId) {
    loadMyData(user.value.id || user.value.userId)
  }
})
</script>

<template>
  <section class="section">
    <h2 class="section-title">个人中心</h2>
    <p class="section-subtitle">查看账户信息和收藏记录。</p>

    <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 16px;" />

    <a-spin :loading="loading" style="width: 100%;">
      <a-tabs type="rounded" default-active-key="info">
        <a-tab-pane key="info" title="基本信息">
          <a-card class="card-surface" :bordered="false" v-if="user">
            <a-descriptions :column="2" bordered>
              <a-descriptions-item label="用户名">{{ user.username }}</a-descriptions-item>
              <a-descriptions-item label="角色">{{ roleLabels[user.role] || '未知' }}</a-descriptions-item>
              <a-descriptions-item label="真实姓名">{{ user.realName || '未填写' }}</a-descriptions-item>
              <a-descriptions-item label="性别">{{ genderLabels[user.gender] || '未知' }}</a-descriptions-item>
              <a-descriptions-item label="地址" :span="2">{{ user.address || '未填写' }}</a-descriptions-item>
            </a-descriptions>
          </a-card>
        </a-tab-pane>

        <a-tab-pane key="listings" title="我的发布">
          <a-card class="card-surface" :bordered="false">
            <template v-if="myListings.length">
              <a-space direction="vertical" fill>
                <div v-for="item in myListings" :key="item.id" class="soft-panel">
                  <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                      <div class="card-title">{{ item.title }}</div>
                      <div class="card-desc">{{ item.type === 1 ? '供给' : '求购' }} · {{ item.location || '未知产地' }}</div>
                    </div>
                    <a-tag :color="listingStatusMap[item.status]?.color || 'default'">
                      {{ listingStatusMap[item.status]?.text || '未知' }}
                    </a-tag>
                  </div>
                  <a-alert
                    v-if="item.status === 3 && item.remark"
                    type="error"
                    :title="`驳回原因：${item.remark}`"
                    show-icon
                    style="margin-top: 8px;"
                  />
                </div>
              </a-space>
            </template>
            <a-empty v-else description="暂无发布记录" />
          </a-card>
        </a-tab-pane>

        <a-tab-pane key="qualifications" title="我的资质">
          <a-card class="card-surface" :bordered="false">
            <template v-if="myQualifications.length">
              <a-space direction="vertical" fill>
                <div v-for="item in myQualifications" :key="item.id" class="soft-panel">
                  <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                      <div class="card-title">{{ item.type }} — {{ item.number }}</div>
                    </div>
                    <a-tag :color="qualStatusMap[item.status]?.color || 'default'">
                      {{ qualStatusMap[item.status]?.text || '未知' }}
                    </a-tag>
                  </div>
                  <a-alert
                    v-if="item.status === 3 && item.remark"
                    type="error"
                    :title="`驳回原因：${item.remark}`"
                    show-icon
                    style="margin-top: 8px;"
                  />
                </div>
              </a-space>
            </template>
            <a-empty v-else description="暂无资质记录" />
          </a-card>
        </a-tab-pane>

        <a-tab-pane key="aftersales" title="售后记录">
          <a-card class="card-surface" :bordered="false">
            <template v-if="myAfterSales.length">
              <a-space direction="vertical" fill>
                <div v-for="item in myAfterSales" :key="item.id" class="soft-panel">
                  <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                      <div class="card-title">订单 #{{ item.orderId }} — {{ item.type === 1 ? '仅退款' : '退货退款' }}</div>
                      <div class="card-desc">申请原因：{{ item.reason || '未填写' }} · 金额：￥{{ item.amount }}</div>
                    </div>
                    <a-tag :color="afterSaleStatusMap[item.status]?.color || 'default'">
                      {{ afterSaleStatusMap[item.status]?.text || '未知' }}
                    </a-tag>
                  </div>
                  <a-alert
                    v-if="item.status === 3 && item.remark"
                    type="error"
                    :title="`驳回原因：${item.remark}`"
                    show-icon
                    style="margin-top: 8px;"
                  />
                </div>
              </a-space>
            </template>
            <a-empty v-else description="暂无售后记录" />
          </a-card>
        </a-tab-pane>

        <a-tab-pane key="favorites" title="我的收藏">
          <a-card class="card-surface" :bordered="false">
            <template v-if="favorites.length">
              <a-space direction="vertical" fill>
                <div v-for="(item, idx) in favorites" :key="idx" class="soft-panel" style="display: flex; justify-content: space-between; align-items: center;">
                  <div>
                    <div class="card-title">{{ item.title }}</div>
                    <div class="card-desc">{{ item.location || '未知产地' }} · {{ item.price ? `￥${item.price}` : '面议' }}</div>
                  </div>
                  <div style="display: flex; gap: 8px;">
                    <a-button size="small" type="primary" @click="router.push(`/market/supply/${item.id}`)">查看</a-button>
                    <a-button size="small" status="danger" @click="removeFavorite(idx)">取消收藏</a-button>
                  </div>
                </div>
              </a-space>
            </template>
            <a-empty v-else description="暂无收藏" />
          </a-card>
        </a-tab-pane>
      </a-tabs>
    </a-spin>
  </section>
</template>
