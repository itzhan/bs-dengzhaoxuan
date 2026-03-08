package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.dto.OrderCreateRequest;
import com.sias.agri.dto.OrderItemRequest;
import com.sias.agri.entity.Order;
import com.sias.agri.entity.OrderItem;
import com.sias.agri.service.OrderItemService;
import com.sias.agri.service.OrderService;
import com.sias.agri.util.SecurityUtils;
import jakarta.validation.Valid;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    private final OrderService orderService;
    private final OrderItemService orderItemService;

    public OrderController(OrderService orderService, OrderItemService orderItemService) {
        this.orderService = orderService;
        this.orderItemService = orderItemService;
    }

    @GetMapping
    public ApiResponse<PageResult<Order>> list(@RequestParam(defaultValue = "1") long page,
                                               @RequestParam(defaultValue = "10") long size,
                                               @RequestParam(required = false) Integer status,
                                               @RequestParam(required = false) Long buyerId,
                                               @RequestParam(required = false) Long sellerId,
                                               @RequestParam(required = false) String keyword) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }
        if (buyerId != null) {
            wrapper.eq(Order::getBuyerId, buyerId);
        }
        if (sellerId != null) {
            wrapper.eq(Order::getSellerId, sellerId);
        }
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Order::getOrderNo, keyword);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin && buyerId == null && sellerId == null) {
            Long uid = SecurityUtils.getUserId();
            wrapper.and(w -> w.eq(Order::getBuyerId, uid).or().eq(Order::getSellerId, uid));
        }
        Page<Order> result = orderService.page(new Page<>(page, size), wrapper.orderByDesc(Order::getId));
        return ApiResponse.ok(PageResult.of(result));
    }

    @GetMapping("/{id}")
    public ApiResponse<?> detail(@PathVariable Long id) {
        Order order = orderService.getById(id);
        if (order == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        List<OrderItem> items = orderItemService.list(new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, id));
        Map<String, Object> data = new HashMap<>();
        data.put("order", order);
        data.put("items", items);
        return ApiResponse.ok(data);
    }

    @PostMapping
    @Transactional
    public ApiResponse<?> create(@Valid @RequestBody OrderCreateRequest req) {
        Long buyerId = SecurityUtils.getUserId();
        BigDecimal totalAmount = BigDecimal.ZERO;
        BigDecimal totalQuantity = BigDecimal.ZERO;
        for (OrderItemRequest item : req.getItems()) {
            totalQuantity = totalQuantity.add(item.getQuantity());
            totalAmount = totalAmount.add(item.getPrice().multiply(item.getQuantity()));
        }
        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setBuyerId(buyerId);
        order.setSellerId(req.getSellerId());
        order.setStatus(1);
        order.setTotalAmount(totalAmount);
        order.setTotalQuantity(totalQuantity);
        order.setDeliveryAddress(req.getDeliveryAddress());
        order.setContactName(req.getContactName());
        order.setExpectedDeliveryTime(req.getExpectedDeliveryTime());
        order.setRemark(req.getRemark());
        orderService.save(order);

        for (OrderItemRequest item : req.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(order.getId());
            orderItem.setProductId(item.getProductId());
            orderItem.setProductName(item.getProductName());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setUnitId(item.getUnitId());
            orderItem.setPrice(item.getPrice());
            orderItem.setAmount(item.getPrice().multiply(item.getQuantity()));
            orderItemService.save(orderItem);
        }
        return ApiResponse.ok(order.getId());
    }

    @PostMapping("/{id}/status")
    public ApiResponse<?> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        Order order = orderService.getById(id);
        if (order == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin && !order.getSellerId().equals(SecurityUtils.getUserId())
                && !order.getBuyerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        order.setStatus(status);
        orderService.updateById(order);
        return ApiResponse.ok();
    }

    private String generateOrderNo() {
        String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int rand = new Random().nextInt(900) + 100;
        return "ORD" + time + rand;
    }
}
