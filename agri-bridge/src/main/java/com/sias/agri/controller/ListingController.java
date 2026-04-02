package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.dto.AuditRequest;
import com.sias.agri.entity.AuditRecord;
import com.sias.agri.entity.Listing;
import com.sias.agri.service.AuditRecordService;
import com.sias.agri.service.ListingService;
import com.sias.agri.util.SecurityUtils;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/listings")
public class ListingController {
    private final ListingService listingService;
    private final AuditRecordService auditRecordService;

    public ListingController(ListingService listingService, AuditRecordService auditRecordService) {
        this.listingService = listingService;
        this.auditRecordService = auditRecordService;
    }

    @GetMapping
    public ApiResponse<PageResult<Listing>> list(@RequestParam(defaultValue = "1") long page,
                                                 @RequestParam(defaultValue = "10") long size,
                                                 @RequestParam(required = false) Integer type,
                                                 @RequestParam(required = false) Integer status,
                                                 @RequestParam(required = false) String keyword,
                                                 @RequestParam(required = false) Long publisherId) {
        LambdaQueryWrapper<Listing> wrapper = new LambdaQueryWrapper<>();
        if (type != null) {
            wrapper.eq(Listing::getType, type);
        }
        if (status != null) {
            wrapper.eq(Listing::getStatus, status);
        }
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Listing::getTitle, keyword);
        }
        if (publisherId != null) {
            wrapper.eq(Listing::getPublisherId, publisherId);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        if (!isAdmin && publisherId == null && status == null) {
            wrapper.in(Listing::getStatus, 2, 4);
        }
        Page<Listing> result = listingService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @GetMapping("/{id}")
    public ApiResponse<Listing> detail(@PathVariable Long id) {
        Listing listing = listingService.getById(id);
        if (listing == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        boolean isAdmin = "ADMIN".equals(SecurityUtils.getRole());
        Long userId = SecurityUtils.getUserId();
        if (!isAdmin && (listing.getStatus() == null || (listing.getStatus() != 2 && listing.getStatus() != 4))) {
            if (userId == null || !userId.equals(listing.getPublisherId())) {
                return ApiResponse.fail(ResultCode.FORBIDDEN);
            }
        }
        return ApiResponse.ok(listing);
    }

    @PostMapping
    public ApiResponse<?> create(@RequestBody Listing listing) {
        ApiResponse<?> validation = validateListing(listing, null);
        if (validation != null) {
            return validation;
        }
        listing.setPublisherId(SecurityUtils.getUserId());
        listing.setStatus(1);
        listingService.save(listing);
        return ApiResponse.ok();
    }

    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Listing listing) {
        Listing db = listingService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        ApiResponse<?> validation = validateListing(listing, db);
        if (validation != null) {
            return validation;
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getPublisherId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        listing.setId(id);
        listingService.updateById(listing);
        return ApiResponse.ok();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        Listing db = listingService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getPublisherId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        listingService.removeById(id);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{id}/audit")
    public ApiResponse<?> audit(@PathVariable Long id, @Valid @RequestBody AuditRequest req) {
        Listing listing = listingService.getById(id);
        if (listing == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        listing.setStatus(req.getStatus());
        listing.setRemark(req.getRemark());
        listingService.updateById(listing);

        AuditRecord record = new AuditRecord();
        record.setTargetType(1);
        record.setTargetId(id);
        record.setStatus(req.getStatus() == 2 ? 1 : 2);
        record.setRemark(req.getRemark());
        record.setAuditorId(SecurityUtils.getUserId());
        record.setAuditTime(LocalDateTime.now());
        auditRecordService.save(record);
        return ApiResponse.ok();
    }

    private ApiResponse<?> validateListing(Listing listing, Listing existing) {
        Integer type = listing.getType();
        if (type == null && existing != null) {
            type = existing.getType();
        }
        if (type != null && type == 2) {
            String contactName = listing.getContactName();
            String contactPhone = listing.getContactPhone();
            if ((contactName == null || contactName.isBlank()) || (contactPhone == null || contactPhone.isBlank())) {
                return ApiResponse.fail(ResultCode.BAD_REQUEST, "求购信息需填写联系人与联系方式");
            }
        }
        return null;
    }
}
