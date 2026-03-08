package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_audit_record")
public class AuditRecord extends BaseEntity {
    private Integer targetType;
    private Long targetId;
    private Integer status;
    private String remark;
    private Long auditorId;
    private LocalDateTime auditTime;
}
