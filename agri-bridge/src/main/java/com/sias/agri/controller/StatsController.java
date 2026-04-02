package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.entity.Order;
import com.sias.agri.entity.Product;
import com.sias.agri.entity.User;
import com.sias.agri.service.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/stats")
public class StatsController {
    private final UserService userService;
    private final ProductService productService;
    private final ListingService listingService;
    private final OrderService orderService;
    private final CategoryService categoryService;

    public StatsController(UserService userService,
                           ProductService productService,
                           ListingService listingService,
                           OrderService orderService,
                           CategoryService categoryService) {
        this.userService = userService;
        this.productService = productService;
        this.listingService = listingService;
        this.orderService = orderService;
        this.categoryService = categoryService;
    }

    @GetMapping("/overview")
    public ApiResponse<?> overview() {
        Map<String, Object> data = new HashMap<>();
        data.put("userCount", userService.count());
        data.put("productCount", productService.count());
        data.put("listingCount", listingService.count());
        data.put("orderCount", orderService.count());

        // 订单总金额
        List<Order> orders = orderService.list();
        BigDecimal totalAmount = orders.stream()
                .map(Order::getTotalAmount)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        data.put("totalAmount", totalAmount);

        // 角色分布
        List<User> users = userService.list();
        Map<String, Long> roleDistribution = users.stream()
                .collect(Collectors.groupingBy(u -> {
                    if (u.getRole() == 1) return "管理员";
                    if (u.getRole() == 2) return "生产方";
                    if (u.getRole() == 3) return "采购方";
                    return "其他";
                }, Collectors.counting()));
        data.put("roleDistribution", roleDistribution);

        // 订单状态分布
        Map<String, Long> orderStatusDist = orders.stream()
                .collect(Collectors.groupingBy(o -> {
                    switch (o.getStatus()) {
                        case 1: return "待确认";
                        case 2: return "已确认";
                        case 3: return "配送中";
                        case 4: return "已送达";
                        case 5: return "已完成";
                        case 6: return "已取消";
                        case 7: return "售后中";
                        default: return "其他";
                    }
                }, Collectors.counting()));
        data.put("orderStatusDistribution", orderStatusDist);

        // 商品分类分布
        List<Product> products = productService.list();
        Map<Long, Long> categoryCount = products.stream()
                .collect(Collectors.groupingBy(Product::getCategoryId, Collectors.counting()));
        data.put("categoryDistribution", categoryCount);

        // 区域供需热度（从用户地址统计）
        Map<String, Long> regionDist = users.stream()
                .filter(u -> u.getAddress() != null && !u.getAddress().isBlank())
                .collect(Collectors.groupingBy(u -> u.getAddress().split("[·\\s]")[0], Collectors.counting()));
        data.put("regionDistribution", regionDist);

        return ApiResponse.ok(data);
    }
}
