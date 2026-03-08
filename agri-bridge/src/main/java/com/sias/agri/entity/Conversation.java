package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("msg_conversation")
public class Conversation extends BaseEntity {
    private Long userAId;
    private Long userBId;
    private String lastMessage;
    private LocalDateTime lastTime;
}
