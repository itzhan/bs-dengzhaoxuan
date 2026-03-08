package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.dto.AuditRequest;
import com.sias.agri.entity.AuditRecord;
import com.sias.agri.entity.Qualification;
import com.sias.agri.service.AuditRecordService;
import com.sias.agri.service.QualificationService;
import com.sias.agri.util.SecurityUtils;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/qualifications")
public class QualificationController {
    private final QualificationService qualificationService;
    private final AuditRecordService auditRecordService;

    public QualificationController(QualificationService qualificationService, AuditRecordService auditRecordService) {
        this.qualificationService = qualificationService;
        this.auditRecordService = auditRecordService;
    }

    @GetMapping
    public ApiResponse<PageResult<Qualification>> list(@RequestParam(defaultValue = "1") long page,
                                                       @RequestParam(defaultValue = "10") long size,
                                                       @RequestParam(required = false) Integer status) {
        Long userId = SecurityUtils.getUserId();
        LambdaQueryWrapper<Qualification> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(Qualification::getStatus, status);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin) {
            wrapper.eq(Qualification::getUserId, userId);
        }
        Page<Qualification> result = qualificationService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @PostMapping
    public ApiResponse<?> create(@Valid @RequestBody Qualification qualification) {
        Long userId = SecurityUtils.getUserId();
        qualification.setUserId(userId);
        qualification.setStatus(1);
        qualificationService.save(qualification);
        return ApiResponse.ok();
    }

    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Qualification qualification) {
        Qualification db = qualificationService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin && !db.getUserId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        qualification.setId(id);
        qualificationService.updateById(qualification);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{id}/audit")
    public ApiResponse<?> audit(@PathVariable Long id, @Valid @RequestBody AuditRequest req) {
        Qualification qualification = qualificationService.getById(id);
        if (qualification == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        qualification.setStatus(req.getStatus());
        qualification.setRemark(req.getRemark());
        qualification.setAuditBy(SecurityUtils.getUserId());
        qualification.setAuditTime(LocalDateTime.now());
        qualificationService.updateById(qualification);

        AuditRecord record = new AuditRecord();
        record.setTargetType(2);
        record.setTargetId(id);
        record.setStatus(req.getStatus() == 2 ? 1 : 2);
        record.setRemark(req.getRemark());
        record.setAuditorId(SecurityUtils.getUserId());
        record.setAuditTime(LocalDateTime.now());
        auditRecordService.save(record);
        return ApiResponse.ok();
    }
}
