package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_inventory")
public class Inventory extends BaseEntity {
    private Long producerId;
    private Long productId;
    private BigDecimal quantity;
    private Long unitId;
    private String location;
}
