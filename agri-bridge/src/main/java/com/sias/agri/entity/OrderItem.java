package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_order_item")
public class OrderItem extends BaseEntity {
    private Long orderId;
    private Long productId;
    private String productName;
    private BigDecimal quantity;
    private Long unitId;
    private BigDecimal price;
    private BigDecimal amount;
}
