package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_order")
public class Order extends BaseEntity {
    private String orderNo;
    private Long buyerId;
    private Long sellerId;
    private Integer status;
    private BigDecimal totalAmount;
    private BigDecimal totalQuantity;
    private String deliveryAddress;
    private String contactName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime expectedDeliveryTime;
    private String remark;
}
