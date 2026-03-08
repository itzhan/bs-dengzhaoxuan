<script setup>
import zhCN from '@arco-design/web-vue/es/locale/lang/zh-cn'
import TopNav from './components/TopNav.vue'
import SiteFooter from './components/SiteFooter.vue'
import SupportWidget from './components/SupportWidget.vue'
</script>

<template>
  <a-config-provider :locale="zhCN">
    <div class="app-shell">
      <TopNav />
      <main class="page-wrap">
        <router-view v-slot="{ Component, route }">
          <transition name="fade" mode="out-in">
            <component :is="Component" :key="route.fullPath" />
          </transition>
        </router-view>
      </main>
      <SiteFooter />
      <SupportWidget />
    </div>
  </a-config-provider>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
