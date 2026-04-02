package com.sias.agri.controller;

import com.sias.agri.common.ApiResponse;
import com.sias.agri.entity.Product;
import com.sias.agri.service.RecommendService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 个性化推荐接口
 */
@RestController
@RequestMapping("/api/recommend")
public class RecommendController {

    private final RecommendService recommendService;

    public RecommendController(RecommendService recommendService) {
        this.recommendService = recommendService;
    }

    @GetMapping
    public ApiResponse<List<Product>> recommend(
            @RequestParam(defaultValue = "6") int size) {
        Long userId = SecurityUtils.getUserId();
        List<Product> result = recommendService.recommend(userId, size);
        return ApiResponse.ok(result);
    }
}
