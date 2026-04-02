package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_after_sale")
public class AfterSale extends BaseEntity {
    private Long orderId;
    private Long buyerId;
    private Long sellerId;
    private Integer type;
    private String reason;
    private BigDecimal amount;
    private Integer status;
    private String remark;
    private Long auditBy;
    private LocalDateTime auditTime;
}
