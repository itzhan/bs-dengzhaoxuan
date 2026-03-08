<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { clearAuth, getUser } from '../utils/auth'

const route = useRoute()
const router = useRouter()
const drawerVisible = ref(false)
const user = ref(getUser())

const menuItems = [
  { key: '/', label: '首页' },
  { key: '/market', label: '供需大厅' },
  { key: '/data', label: '数据看板' },
  { key: '/trace', label: '溯源查询' },
  { key: '/news', label: '公告资讯' },
  { key: '/about', label: '关于平台' }
]

const activeKey = computed(() => {
  if (route.path.startsWith('/market')) return '/market'
  return route.path
})

const resolveMenuKey = (value) => {
  if (typeof value === 'string') return value
  if (value && typeof value === 'object') {
    return value.key || value.path || value.value || ''
  }
  return ''
}

const handleSelect = (value) => {
  const target = resolveMenuKey(value)
  if (!target) return
  drawerVisible.value = false
  router.push(target).catch(() => {})
}

const handleLogout = () => {
  clearAuth()
  router.push('/')
}

const syncUser = () => {
  user.value = getUser()
}

onMounted(() => {
  window.addEventListener('auth-change', syncUser)
})
</script>

<template>
  <header class="top-nav">
    <div class="nav-inner">
      <div class="brand" @click="router.push('/')">
        <div class="brand-mark"></div>
        <div>
          <div class="brand-title">农产品产销对接</div>
          <div class="brand-sub">展示服务平台</div>
        </div>
      </div>

      <a-menu
        class="menu-desktop"
        mode="horizontal"
        :selected-keys="[activeKey]"
        @menu-item-click="handleSelect"
      >
        <a-menu-item v-for="item in menuItems" :key="item.key">{{ item.label }}</a-menu-item>
      </a-menu>

      <div class="nav-actions">
        <a-button type="primary" class="call-btn" @click="router.push('/publish')">发布信息</a-button>
        <a-button class="ghost-btn" @click="router.push('/trace')">溯源查询</a-button>
        <template v-if="user">
          <a-dropdown>
            <a-button class="ghost-btn">{{ user.username }}</a-button>
            <template #content>
              <a-doption @click="router.push('/publish')">我的发布</a-doption>
              <a-doption @click="handleLogout">退出登录</a-doption>
            </template>
          </a-dropdown>
        </template>
        <template v-else>
          <a-button class="ghost-btn" @click="router.push('/login')">登录</a-button>
          <a-button class="ghost-btn" @click="router.push('/register')">注册</a-button>
        </template>
      </div>

      <a-button class="menu-mobile" shape="circle" @click="drawerVisible = true">
        <template #icon>
          <icon-menu />
        </template>
      </a-button>
    </div>

    <a-drawer
      placement="right"
      width="80%"
      :visible="drawerVisible"
      @cancel="drawerVisible = false"
      :footer="false"
    >
      <template #title>导航</template>
      <a-menu :selected-keys="[activeKey]" @menu-item-click="handleSelect">
        <a-menu-item v-for="item in menuItems" :key="item.key">{{ item.label }}</a-menu-item>
      </a-menu>
      <div style="margin-top: 16px; display: flex; flex-direction: column; gap: 10px;">
        <a-button type="primary" @click="router.push('/publish')">发布信息</a-button>
        <a-button v-if="user" @click="handleLogout">退出登录</a-button>
        <template v-else>
          <a-button @click="router.push('/login')">登录</a-button>
          <a-button @click="router.push('/register')">注册</a-button>
        </template>
      </div>
    </a-drawer>
  </header>
</template>

<style scoped>
.top-nav {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(12px);
  background: rgba(255, 255, 255, 0.82);
  border-bottom: 1px solid rgba(31, 111, 67, 0.12);
}

.nav-inner {
  width: min(1240px, 92vw);
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 12px 0;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.brand-mark {
  width: 38px;
  height: 38px;
  border-radius: 14px;
  background: linear-gradient(145deg, #2b8a57, #8fd3a8);
  box-shadow: 0 8px 16px rgba(31, 111, 67, 0.25);
}

.brand-title {
  font-weight: 700;
  font-size: 16px;
  color: var(--ink-900);
}

.brand-sub {
  font-size: 12px;
  color: var(--ink-500);
}

.menu-desktop {
  flex: 1;
  min-width: 0;
  background: transparent;
  border-bottom: none;
}

.nav-actions {
  display: flex;
  gap: 10px;
}

.call-btn {
  background: linear-gradient(135deg, #2b8a57, #3ca266);
  border: none;
}

.ghost-btn {
  border-color: rgba(31, 111, 67, 0.35);
  color: var(--brand-700);
}

.menu-mobile {
  display: none;
}

@media (max-width: 980px) {
  .menu-desktop,
  .nav-actions {
    display: none;
  }

  .menu-mobile {
    display: inline-flex;
    margin-left: auto;
  }
}
</style>
