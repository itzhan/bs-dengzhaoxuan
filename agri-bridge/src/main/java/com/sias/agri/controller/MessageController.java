package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.dto.MessageSendRequest;
import com.sias.agri.entity.Conversation;
import com.sias.agri.entity.Message;
import com.sias.agri.service.ConversationService;
import com.sias.agri.service.MessageService;
import com.sias.agri.util.SecurityUtils;
import jakarta.validation.Valid;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/messages")
public class MessageController {
    private final ConversationService conversationService;
    private final MessageService messageService;

    public MessageController(ConversationService conversationService, MessageService messageService) {
        this.conversationService = conversationService;
        this.messageService = messageService;
    }

    @PostMapping
    @Transactional
    public ApiResponse<?> send(@Valid @RequestBody MessageSendRequest req) {
        Long fromId = SecurityUtils.getUserId();
        Long toId = req.getToUserId();
        Conversation conversation = conversationService.getOne(new LambdaQueryWrapper<Conversation>()
                .and(w -> w.eq(Conversation::getUserAId, fromId).eq(Conversation::getUserBId, toId)
                        .or().eq(Conversation::getUserAId, toId).eq(Conversation::getUserBId, fromId)));
        if (conversation == null) {
            conversation = new Conversation();
            conversation.setUserAId(fromId);
            conversation.setUserBId(toId);
            conversation.setLastMessage(req.getContent());
            conversation.setLastTime(LocalDateTime.now());
            conversationService.save(conversation);
        }
        Message message = new Message();
        message.setConversationId(conversation.getId());
        message.setSenderId(fromId);
        message.setContent(req.getContent());
        message.setType(req.getType() == null ? 1 : req.getType());
        message.setReadFlag(0);
        message.setSentAt(LocalDateTime.now());
        messageService.save(message);

        conversation.setLastMessage(req.getContent());
        conversation.setLastTime(LocalDateTime.now());
        conversationService.updateById(conversation);

        return ApiResponse.ok();
    }
}
