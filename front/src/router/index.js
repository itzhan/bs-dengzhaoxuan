import { createRouter, createWebHistory } from 'vue-router'

import Home from '../pages/Home.vue'
import Market from '../pages/Market.vue'
import MarketDetail from '../pages/MarketDetail.vue'
import DataBoard from '../pages/DataBoard.vue'
import Trace from '../pages/Trace.vue'
import News from '../pages/News.vue'
import About from '../pages/About.vue'
import Login from '../pages/Login.vue'
import Register from '../pages/Register.vue'
import Publish from '../pages/Publish.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: Home },
    { path: '/market', name: 'market', component: Market },
    { path: '/market/:type/:id', name: 'market-detail', component: MarketDetail },
    { path: '/data', name: 'data', component: DataBoard },
    { path: '/trace', name: 'trace', component: Trace },
    { path: '/news', name: 'news', component: News },
    { path: '/about', name: 'about', component: About },
    { path: '/login', name: 'login', component: Login },
    { path: '/register', name: 'register', component: Register },
    { path: '/publish', name: 'publish', component: Publish }
  ],
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
