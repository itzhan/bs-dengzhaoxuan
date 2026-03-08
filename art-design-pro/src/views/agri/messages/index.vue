<template>
  <div class="art-full-height">
    <ElRow :gutter="16">
      <ElCol :span="8">
        <ElCard shadow="never" class="h-full">
          <div class="font-medium mb-2">会话列表</div>
          <ElTable
            :data="conversations"
            height="520"
            @row-click="selectConversation"
            highlight-current-row
          >
            <ElTableColumn prop="id" label="#" width="60" />
            <ElTableColumn prop="lastMessage" label="最近消息" />
            <ElTableColumn prop="lastTime" label="时间" width="140" />
          </ElTable>
        </ElCard>
      </ElCol>
      <ElCol :span="16">
        <ElCard shadow="never" class="h-full flex flex-col">
          <div class="font-medium mb-2">消息</div>
          <div class="flex-1 overflow-auto">
            <ElTable :data="messages" height="420" border>
              <ElTableColumn prop="senderId" label="发送人" width="120" />
              <ElTableColumn prop="content" label="内容" />
              <ElTableColumn prop="sentAt" label="时间" width="160" />
            </ElTable>
          </div>
          <div class="mt-3 flex gap-2">
            <ElInput v-model="content" placeholder="输入消息" />
            <ElButton type="primary" @click="send">发送</ElButton>
          </div>
        </ElCard>
      </ElCol>
    </ElRow>
  </div>
</template>

<script setup lang="ts">
  import { ElMessage } from 'element-plus'
  import { agriApi } from '@/api/agri'
  import { useUserStore } from '@/store/modules/user'

  const userStore = useUserStore()
  const conversations = ref<any[]>([])
  const messages = ref<any[]>([])
  const activeConversation = ref<any>(null)
  const content = ref('')

  const loadConversations = async () => {
    const data = await agriApi.getConversations({ page: 1, size: 50 })
    conversations.value = data.records || []
    if (!activeConversation.value && conversations.value.length > 0) {
      selectConversation(conversations.value[0])
    }
  }

  const loadMessages = async (id: number) => {
    const data = await agriApi.getMessages(id, { page: 1, size: 50 })
    messages.value = data.records || []
  }

  const selectConversation = async (row: any) => {
    activeConversation.value = row
    await loadMessages(row.id)
  }

  const send = async () => {
    if (!activeConversation.value) {
      ElMessage.warning('请先选择会话')
      return
    }
    if (!content.value) return
    const uid = userStore.info?.userId
    const toUserId = activeConversation.value.userAId === uid
      ? activeConversation.value.userBId
      : activeConversation.value.userAId
    await agriApi.sendMessage({ toUserId, content: content.value, type: 1 })
    content.value = ''
    await loadMessages(activeConversation.value.id)
    await loadConversations()
  }

  onMounted(loadConversations)
</script>
