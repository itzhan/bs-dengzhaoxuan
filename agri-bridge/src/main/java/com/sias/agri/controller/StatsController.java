package com.sias.agri.controller;

import com.sias.agri.common.ApiResponse;
import com.sias.agri.service.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/stats")
public class StatsController {
    private final UserService userService;
    private final ProductService productService;
    private final ListingService listingService;
    private final OrderService orderService;

    public StatsController(UserService userService,
                           ProductService productService,
                           ListingService listingService,
                           OrderService orderService) {
        this.userService = userService;
        this.productService = productService;
        this.listingService = listingService;
        this.orderService = orderService;
    }

    @GetMapping("/overview")
    public ApiResponse<?> overview() {
        Map<String, Object> data = new HashMap<>();
        data.put("userCount", userService.count());
        data.put("productCount", productService.count());
        data.put("listingCount", listingService.count());
        data.put("orderCount", orderService.count());
        return ApiResponse.ok(data);
    }
}
