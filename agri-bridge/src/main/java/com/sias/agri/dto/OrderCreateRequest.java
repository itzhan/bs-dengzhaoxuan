package com.sias.agri.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderCreateRequest {
    @NotNull(message = "卖家不能为空")
    private Long sellerId;

    @NotBlank(message = "收货地址不能为空")
    private String deliveryAddress;

    private String contactName;
    private LocalDateTime expectedDeliveryTime;
    private String remark;

    @NotEmpty(message = "订单明细不能为空")
    private List<OrderItemRequest> items;
}
