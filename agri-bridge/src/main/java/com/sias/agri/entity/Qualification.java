package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_qualification")
public class Qualification extends BaseEntity {
    private Long userId;
    private String type;
    private String number;
    private String fileUrl;
    private Integer status;
    private String remark;
    private Long auditBy;
    private LocalDateTime auditTime;
}
