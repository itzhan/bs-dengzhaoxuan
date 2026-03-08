package com.sias.agri.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class OrderItemRequest {
    @NotNull(message = "商品ID不能为空")
    private Long productId;
    @NotBlank(message = "商品名称不能为空")
    private String productName;
    @NotNull(message = "数量不能为空")
    private BigDecimal quantity;
    @NotNull(message = "单位不能为空")
    private Long unitId;
    @NotNull(message = "单价不能为空")
    private BigDecimal price;
}
