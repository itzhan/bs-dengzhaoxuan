<script setup>
import { nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { askAi, fetchConversationMessages, fetchConversations, fetchSupportAgent, login, sendMessage } from '../api'
import { getUser, setAuth } from '../utils/auth'

const visible = ref(false)
const loading = ref(false)
const error = ref('')
const success = ref('')
const agent = ref(null)
const user = ref(getUser())
const messages = ref([])
const conversationId = ref(null)
const historyLoading = ref(false)
const messageText = ref('')
const messagesRef = ref(null)
let pollTimer = null

// AI 客服状态
const aiMode = ref(false)
const aiMessages = ref([
  { role: 'ai', content: '您好！我是智能客服助手，可以回答关于注册登录、采购下单、供应发布、溯源查询、售后处理等问题。请问有什么可以帮您？' }
])
const aiInput = ref('')
const aiLoading = ref(false)
const aiMessagesRef = ref(null)

const loginLoading = ref(false)
const loginError = ref('')
const loginForm = reactive({
  username: '',
  password: ''
})

const loadAgent = async () => {
  try {
    agent.value = await fetchSupportAgent()
  } catch {
    agent.value = null
  }
}

const loadConversation = async () => {
  if (!user.value || !agent.value?.userId) return
  historyLoading.value = true
  try {
    const res = await fetchConversations({ page: 1, size: 50 })
    const records = res.records || []
    const found = records.find((item) => {
      return (
        (item.userAId === user.value.id && item.userBId === agent.value.userId) ||
        (item.userBId === user.value.id && item.userAId === agent.value.userId)
      )
    })
    conversationId.value = found?.id || null
    if (conversationId.value) {
      const msgRes = await fetchConversationMessages(conversationId.value, { page: 1, size: 50 })
      messages.value = msgRes.records || []
      await nextTick()
      scrollToBottom()
    } else {
      messages.value = []
    }
  } catch (err) {
    error.value = err?.message || '加载对话失败'
  } finally {
    historyLoading.value = false
  }
}

const scrollToBottom = () => {
  const el = messagesRef.value
  if (el) {
    el.scrollTop = el.scrollHeight
  }
}

const handleSend = async () => {
  if (!user.value) {
    error.value = '请先登录后再留言'
    return
  }
  if (!messageText.value) {
    error.value = '请输入留言内容'
    return
  }
  if (!agent.value?.userId) {
    error.value = '客服暂不可用'
    return
  }
  loading.value = true
  error.value = ''
  success.value = ''
  try {
    await sendMessage({
      toUserId: agent.value.userId,
      content: messageText.value,
      type: 1
    })
    messages.value.push({
      id: `local-${Date.now()}`,
      senderId: user.value.id,
      content: messageText.value,
      sentAt: new Date().toISOString()
    })
    messageText.value = ''
    success.value = '已发送'
    await loadConversation()
  } catch (err) {
    error.value = err?.message || '发送失败'
  } finally {
    loading.value = false
  }
}

const handleAiSend = async () => {
  const q = aiInput.value.trim()
  if (!q) return
  aiMessages.value.push({ role: 'user', content: q })
  aiInput.value = ''
  aiLoading.value = true
  try {
    const res = await askAi(q)
    aiMessages.value.push({ role: 'ai', content: res?.answer || '抱歉，暂时无法回答。' })
  } catch {
    aiMessages.value.push({ role: 'ai', content: '网络错误，请稍后重试。' })
  } finally {
    aiLoading.value = false
    nextTick(() => {
      if (aiMessagesRef.value) aiMessagesRef.value.scrollTop = aiMessagesRef.value.scrollHeight
    })
  }
}

const handleLogin = async () => {
  if (!loginForm.username || !loginForm.password) {
    loginError.value = '请输入用户名和密码'
    return
  }
  loginLoading.value = true
  loginError.value = ''
  try {
    const data = await login(loginForm)
    setAuth(data.token, {
      id: data.userId,
      username: data.username,
      role: data.role
    })
    user.value = getUser()
    loginForm.username = ''
    loginForm.password = ''
    await loadConversation()
  } catch (err) {
    loginError.value = err?.message || '登录失败'
  } finally {
    loginLoading.value = false
  }
}

const syncUser = () => {
  user.value = getUser()
}

const toggleVisible = () => {
  visible.value = !visible.value
}

const startPolling = () => {
  if (pollTimer) return
  pollTimer = window.setInterval(() => {
    if (!visible.value || !user.value) return
    loadConversation()
  }, 8000)
}

const stopPolling = () => {
  if (pollTimer) {
    window.clearInterval(pollTimer)
    pollTimer = null
  }
}

watch(visible, async (val) => {
  if (val) {
    error.value = ''
    success.value = ''
    await loadAgent()
    await loadConversation()
    startPolling()
  } else {
    stopPolling()
  }
})

watch(
  () => messages.value.length,
  () => {
    nextTick(scrollToBottom)
  }
)

onMounted(() => {
  loadAgent()
  window.addEventListener('auth-change', syncUser)
})

onBeforeUnmount(() => {
  stopPolling()
})
</script>

<template>
  <div class="support-widget">
    <a-button type="primary" shape="circle" class="support-btn" @click="toggleVisible">
      <template #icon>
        <icon-message />
      </template>
    </a-button>

    <transition name="float-fade">
      <div v-if="visible" class="support-float">
        <div class="support-header">
          <div class="support-title">{{ aiMode ? 'AI 智能客服' : '在线客服' }}</div>
          <div class="support-actions">
            <a-button size="mini" :type="aiMode ? 'primary' : 'secondary'" @click="aiMode = !aiMode">
              {{ aiMode ? '人工客服' : 'AI客服' }}
            </a-button>
            <a-button v-if="!aiMode" size="mini" @click="loadConversation">刷新</a-button>
            <a-button size="mini" type="text" @click="visible = false">
              <icon-close />
            </a-button>
          </div>
        </div>

        <div class="support-body">
          <!-- AI 智能客服模式 -->
          <template v-if="aiMode">
            <div class="support-hint">基于关键词匹配的智能问答系统，可回答平台常见问题。</div>
            <div class="chat-box">
              <div class="chat-messages" ref="aiMessagesRef">
                <div v-for="(msg, idx) in aiMessages" :key="idx" class="chat-row" :class="{ 'chat-row-self': msg.role === 'user' }">
                  <div class="chat-bubble">
                    <div class="chat-content" style="white-space: pre-line;">{{ msg.content }}</div>
                  </div>
                </div>
                <div v-if="aiLoading" class="chat-loading">正在思考...</div>
              </div>
              <div class="chat-input">
                <a-textarea v-model="aiInput" :rows="2" placeholder="输入问题，如“怎么下单”“溯源查询”" @keydown.enter.prevent="handleAiSend" />
                <a-button type="primary" :loading="aiLoading" @click="handleAiSend">发送</a-button>
              </div>
            </div>
          </template>

          <!-- 人工客服模式 -->
          <template v-else>
          <div class="support-hint">点击发送即可留言，客服会在管理端回复。</div>
          <a-alert v-if="error" type="warning" :title="error" show-icon style="margin-bottom: 8px;" />
          <a-alert v-if="success" type="success" :title="success" show-icon style="margin-bottom: 8px;" />

          <div v-if="user" class="chat-box">
            <div class="chat-messages" ref="messagesRef">
              <div v-if="historyLoading" class="chat-loading">加载对话中...</div>
              <div v-else-if="!messages.length" class="chat-empty">暂无消息，开始留言吧～</div>
              <div
                v-for="item in messages"
                :key="item.id"
                class="chat-row"
                :class="{ 'chat-row-self': item.senderId === user.id }"
              >
                <div class="chat-bubble">
                  <div class="chat-content">{{ item.content }}</div>
                  <div class="chat-time">{{ String(item.sentAt || '').slice(11, 16) }}</div>
                </div>
              </div>
            </div>

            <div class="chat-input">
              <div style="display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 6px; grid-column: 1 / -1;">
                <a-button v-for="text in ['已发货', '价格已确认', '可以配送', '请提供资质', '订单已处理']" :key="text" size="mini" @click="messageText = text">{{ text }}</a-button>
              </div>
              <a-textarea v-model="messageText" :rows="2" placeholder="请输入留言内容" />
              <a-button type="primary" :loading="loading" @click="handleSend">发送</a-button>
            </div>
          </div>

          <div v-else class="login-box">
            <div class="support-login-title">登录后即可留言</div>
            <a-alert v-if="loginError" type="warning" :title="loginError" show-icon style="margin-bottom: 8px;" />
            <a-input v-model="loginForm.username" placeholder="请输入用户名" />
            <a-input-password v-model="loginForm.password" placeholder="请输入密码" />
            <a-button type="primary" long :loading="loginLoading" @click="handleLogin">登录</a-button>
          </div>
          </template>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.support-widget {
  position: fixed;
  right: 24px;
  bottom: 24px;
  z-index: 50;
}

.support-btn {
  width: 52px;
  height: 52px;
  border-radius: 18px;
  box-shadow: 0 14px 26px rgba(31, 111, 67, 0.22);
  background: linear-gradient(135deg, #2b8a57, #3ca266);
  border: none;
}

.support-float {
  position: absolute;
  right: 0;
  bottom: 68px;
  width: 360px;
  max-height: 70vh;
  background: rgba(255, 255, 255, 0.96);
  border-radius: 18px;
  border: 1px solid rgba(31, 111, 67, 0.12);
  box-shadow: 0 18px 40px rgba(31, 111, 67, 0.25);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.support-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  background: linear-gradient(135deg, rgba(60, 162, 102, 0.2), rgba(243, 230, 207, 0.7));
}

.support-title {
  font-weight: 600;
  color: var(--ink-900);
}

.support-actions {
  display: flex;
  gap: 6px;
}

.support-body {
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.support-hint {
  color: var(--ink-500);
  font-size: 12px;
}

.chat-box {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.chat-messages {
  background: rgba(246, 250, 246, 0.8);
  border-radius: 14px;
  padding: 10px;
  height: 260px;
  overflow-y: auto;
}

.chat-loading,
.chat-empty {
  color: var(--ink-500);
  font-size: 12px;
  text-align: center;
  padding: 12px 0;
}

.chat-row {
  display: flex;
  margin-bottom: 8px;
}

.chat-row-self {
  justify-content: flex-end;
}

.chat-bubble {
  max-width: 80%;
  background: white;
  border-radius: 14px;
  padding: 8px 10px;
  border: 1px solid rgba(31, 111, 67, 0.12);
  box-shadow: 0 8px 16px rgba(31, 111, 67, 0.08);
}

.chat-row-self .chat-bubble {
  background: rgba(60, 162, 102, 0.15);
}

.chat-content {
  font-size: 13px;
  line-height: 1.5;
  color: var(--ink-900);
  word-break: break-word;
}

.chat-time {
  margin-top: 4px;
  font-size: 11px;
  color: var(--ink-500);
  text-align: right;
}

.chat-input {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 8px;
  align-items: end;
}

.login-box {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.support-login-title {
  color: var(--ink-700);
  font-weight: 600;
  font-size: 14px;
}

.float-fade-enter-active,
.float-fade-leave-active {
  transition: all 0.2s ease;
}

.float-fade-enter-from,
.float-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

@media (max-width: 640px) {
  .support-float {
    right: -6px;
    width: 92vw;
  }
}
</style>
