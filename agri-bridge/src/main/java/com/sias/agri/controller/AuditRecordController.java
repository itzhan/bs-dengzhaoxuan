package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.entity.AuditRecord;
import com.sias.agri.service.AuditRecordService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/audits")
public class AuditRecordController {
    private final AuditRecordService auditRecordService;

    public AuditRecordController(AuditRecordService auditRecordService) {
        this.auditRecordService = auditRecordService;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public ApiResponse<PageResult<AuditRecord>> list(@RequestParam(defaultValue = "1") long page,
                                                     @RequestParam(defaultValue = "10") long size,
                                                     @RequestParam(required = false) Integer targetType) {
        LambdaQueryWrapper<AuditRecord> wrapper = new LambdaQueryWrapper<>();
        if (targetType != null) {
            wrapper.eq(AuditRecord::getTargetType, targetType);
        }
        Page<AuditRecord> result = auditRecordService.page(new Page<>(page, size), wrapper.orderByDesc(AuditRecord::getId));
        return ApiResponse.ok(PageResult.of(result));
    }
}
