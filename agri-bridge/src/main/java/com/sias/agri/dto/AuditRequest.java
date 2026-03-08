package com.sias.agri.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AuditRequest {
    @NotNull(message = "状态不能为空")
    private Integer status;
    private String remark;
}
