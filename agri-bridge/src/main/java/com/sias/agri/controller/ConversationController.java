package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.entity.Conversation;
import com.sias.agri.entity.Message;
import com.sias.agri.service.ConversationService;
import com.sias.agri.service.MessageService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/conversations")
public class ConversationController {
    private final ConversationService conversationService;
    private final MessageService messageService;

    public ConversationController(ConversationService conversationService, MessageService messageService) {
        this.conversationService = conversationService;
        this.messageService = messageService;
    }

    @GetMapping
    public ApiResponse<PageResult<Conversation>> list(@RequestParam(defaultValue = "1") long page,
                                                      @RequestParam(defaultValue = "10") long size) {
        Long uid = SecurityUtils.getUserId();
        LambdaQueryWrapper<Conversation> wrapper = new LambdaQueryWrapper<>();
        wrapper.and(w -> w.eq(Conversation::getUserAId, uid).or().eq(Conversation::getUserBId, uid));
        Page<Conversation> result = conversationService.page(new Page<>(page, size), wrapper.orderByDesc(Conversation::getLastTime));
        return ApiResponse.ok(PageResult.of(result));
    }

    @GetMapping("/{id}/messages")
    public ApiResponse<PageResult<Message>> messages(@PathVariable Long id,
                                                     @RequestParam(defaultValue = "1") long page,
                                                     @RequestParam(defaultValue = "20") long size) {
        LambdaQueryWrapper<Message> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Message::getConversationId, id).orderByAsc(Message::getSentAt);
        Page<Message> result = messageService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }
}
