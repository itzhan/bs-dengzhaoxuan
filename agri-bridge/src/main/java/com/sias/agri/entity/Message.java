package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("msg_message")
public class Message extends BaseEntity {
    private Long conversationId;
    private Long senderId;
    private String content;
    private Integer type;
    private Integer readFlag;
    private LocalDateTime sentAt;
}
