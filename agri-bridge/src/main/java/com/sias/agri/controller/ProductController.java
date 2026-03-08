package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.Product;
import com.sias.agri.service.ProductService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ApiResponse<PageResult<Product>> list(@RequestParam(defaultValue = "1") long page,
                                                 @RequestParam(defaultValue = "10") long size,
                                                 @RequestParam(required = false) String keyword,
                                                 @RequestParam(required = false) Long categoryId,
                                                 @RequestParam(required = false) Long ownerId,
                                                 @RequestParam(required = false) Integer status) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Product::getName, keyword);
        }
        if (categoryId != null) {
            wrapper.eq(Product::getCategoryId, categoryId);
        }
        if (ownerId != null) {
            wrapper.eq(Product::getOwnerId, ownerId);
        }
        if (status != null) {
            wrapper.eq(Product::getStatus, status);
        }
        Page<Product> result = productService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @PostMapping
    public ApiResponse<?> create(@RequestBody Product product) {
        Long userId = SecurityUtils.getUserId();
        if (!"ADMIN".equals(SecurityUtils.getRole())) {
            product.setOwnerId(userId);
        }
        productService.save(product);
        return ApiResponse.ok();
    }

    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Product product) {
        Product db = productService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getOwnerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        product.setId(id);
        productService.updateById(product);
        return ApiResponse.ok();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        Product db = productService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getOwnerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        productService.removeById(id);
        return ApiResponse.ok();
    }
}
