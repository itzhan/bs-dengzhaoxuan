package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.TraceBatch;
import com.sias.agri.service.TraceBatchService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/traces")
public class TraceBatchController {
    private final TraceBatchService traceBatchService;

    public TraceBatchController(TraceBatchService traceBatchService) {
        this.traceBatchService = traceBatchService;
    }

    @GetMapping
    public ApiResponse<PageResult<TraceBatch>> list(@RequestParam(defaultValue = "1") long page,
                                                    @RequestParam(defaultValue = "10") long size,
                                                    @RequestParam(required = false) Long productId,
                                                    @RequestParam(required = false) Long producerId) {
        LambdaQueryWrapper<TraceBatch> wrapper = new LambdaQueryWrapper<>();
        if (productId != null) {
            wrapper.eq(TraceBatch::getProductId, productId);
        }
        if (producerId != null) {
            wrapper.eq(TraceBatch::getProducerId, producerId);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && producerId == null) {
            wrapper.eq(TraceBatch::getProducerId, SecurityUtils.getUserId());
        }
        Page<TraceBatch> result = traceBatchService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @GetMapping("/by-batch/{batchNo}")
    public ApiResponse<TraceBatch> getByBatchNo(@PathVariable String batchNo) {
        TraceBatch batch = traceBatchService.getOne(new LambdaQueryWrapper<TraceBatch>().eq(TraceBatch::getBatchNo, batchNo));
        if (batch == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        return ApiResponse.ok(batch);
    }

    @PostMapping
    public ApiResponse<?> create(@RequestBody TraceBatch batch) {
        if (!"ADMIN".equals(SecurityUtils.getRole())) {
            batch.setProducerId(SecurityUtils.getUserId());
        }
        if (batch.getQrCodeUrl() == null || batch.getQrCodeUrl().isBlank()) {
            batch.setQrCodeUrl("trace://batch/" + batch.getBatchNo());
        }
        traceBatchService.save(batch);
        return ApiResponse.ok();
    }

    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody TraceBatch batch) {
        TraceBatch db = traceBatchService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getProducerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        batch.setId(id);
        traceBatchService.updateById(batch);
        return ApiResponse.ok();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        TraceBatch db = traceBatchService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getProducerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        traceBatchService.removeById(id);
        return ApiResponse.ok();
    }
}
