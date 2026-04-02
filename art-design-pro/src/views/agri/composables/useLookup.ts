import { ref, computed } from 'vue'
import { agriApi } from '@/api/agri'

const categories = ref<any[]>([])
const units = ref<any[]>([])
const products = ref<any[]>([])
const users = ref<any[]>([])
const orders = ref<any[]>([])

let loaded = { categories: false, units: false, products: false, users: false, orders: false }

async function loadCategories() {
  if (loaded.categories) return
  const data = await agriApi.getCategories({ page: 1, size: 1000 })
  categories.value = data.records || []
  loaded.categories = true
}

async function loadUnits() {
  if (loaded.units) return
  const data = await agriApi.getUnits({ page: 1, size: 1000 })
  units.value = data.records || []
  loaded.units = true
}

async function loadProducts() {
  if (loaded.products) return
  const data = await agriApi.getProducts({ page: 1, size: 1000 })
  products.value = data.records || []
  loaded.products = true
}

async function loadUsers() {
  if (loaded.users) return
  const data = await agriApi.getUsers({ page: 1, size: 1000 })
  users.value = data.records || []
  loaded.users = true
}

async function loadOrders() {
  if (loaded.orders) return
  const data = await agriApi.getOrders({ page: 1, size: 1000 })
  orders.value = data.records || []
  loaded.orders = true
}

export function useLookup() {
  const categoryMap = computed(() =>
    Object.fromEntries(categories.value.map((c) => [c.id, c.name]))
  )
  const unitMap = computed(() =>
    Object.fromEntries(units.value.map((u) => [u.id, u.name]))
  )
  const productMap = computed(() =>
    Object.fromEntries(products.value.map((p) => [p.id, p.name]))
  )
  const userMap = computed(() =>
    Object.fromEntries(users.value.map((u) => [u.id, u.realName || u.username]))
  )

  const categoryOptions = computed(() =>
    categories.value.map((c) => ({ label: c.name, value: c.id }))
  )
  const unitOptions = computed(() =>
    units.value.map((u) => ({ label: `${u.name}(${u.symbol})`, value: u.id }))
  )
  const productOptions = computed(() =>
    products.value.map((p) => ({ label: p.name, value: p.id }))
  )
  const producerOptions = computed(() =>
    users.value.filter((u) => u.role === 2).map((u) => ({ label: u.realName || u.username, value: u.id }))
  )
  const buyerOptions = computed(() =>
    users.value.filter((u) => u.role === 3).map((u) => ({ label: u.realName || u.username, value: u.id }))
  )
  const orderMap = computed(() =>
    Object.fromEntries(orders.value.map((o) => [o.id, o.orderNo]))
  )
  const orderOptions = computed(() =>
    orders.value.map((o) => ({ label: o.orderNo, value: o.id }))
  )

  return {
    categories,
    units,
    products,
    users,
    orders,
    categoryMap,
    unitMap,
    productMap,
    userMap,
    orderMap,
    categoryOptions,
    unitOptions,
    productOptions,
    producerOptions,
    buyerOptions,
    orderOptions,
    loadCategories,
    loadUnits,
    loadProducts,
    loadUsers,
    loadOrders
  }
}
