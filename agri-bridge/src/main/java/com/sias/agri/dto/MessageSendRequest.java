package com.sias.agri.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MessageSendRequest {
    @NotNull(message = "接收方不能为空")
    private Long toUserId;

    @NotBlank(message = "内容不能为空")
    private String content;

    private Integer type = 1;
}
