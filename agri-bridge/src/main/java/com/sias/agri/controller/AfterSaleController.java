package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.AfterSale;
import com.sias.agri.service.AfterSaleService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/after-sales")
public class AfterSaleController {
    private final AfterSaleService afterSaleService;

    public AfterSaleController(AfterSaleService afterSaleService) {
        this.afterSaleService = afterSaleService;
    }

    @GetMapping
    public ApiResponse<PageResult<AfterSale>> list(@RequestParam(defaultValue = "1") long page,
                                                   @RequestParam(defaultValue = "10") long size,
                                                   @RequestParam(required = false) Integer status) {
        LambdaQueryWrapper<AfterSale> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(AfterSale::getStatus, status);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin) {
            Long uid = SecurityUtils.getUserId();
            wrapper.and(w -> w.eq(AfterSale::getBuyerId, uid).or().eq(AfterSale::getSellerId, uid));
        }
        Page<AfterSale> result = afterSaleService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @PostMapping
    public ApiResponse<?> create(@RequestBody AfterSale afterSale) {
        if (!"ADMIN".equals(SecurityUtils.getRole())) {
            afterSale.setBuyerId(SecurityUtils.getUserId());
            afterSale.setStatus(1);
        }
        afterSaleService.save(afterSale);
        return ApiResponse.ok();
    }

    @PostMapping("/{id}/audit")
    public ApiResponse<?> audit(@PathVariable Long id, @RequestBody java.util.Map<String, Object> body) {
        Integer status = body.get("status") instanceof Number ? ((Number) body.get("status")).intValue() : null;
        String remark = body.get("remark") instanceof String ? (String) body.get("remark") : null;
        AfterSale afterSale = afterSaleService.getById(id);
        if (afterSale == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin && !afterSale.getSellerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        afterSale.setStatus(status);
        afterSale.setRemark(remark);
        afterSale.setAuditBy(SecurityUtils.getUserId());
        afterSale.setAuditTime(LocalDateTime.now());
        afterSaleService.updateById(afterSale);
        return ApiResponse.ok();
    }
}
