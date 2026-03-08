package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.Notice;
import com.sias.agri.service.NoticeService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/notices")
public class NoticeController {
    private final NoticeService noticeService;

    public NoticeController(NoticeService noticeService) {
        this.noticeService = noticeService;
    }

    @GetMapping
    public ApiResponse<PageResult<Notice>> list(@RequestParam(defaultValue = "1") long page,
                                                @RequestParam(defaultValue = "10") long size,
                                                @RequestParam(required = false) Integer publishStatus,
                                                @RequestParam(required = false) String keyword) {
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        if (publishStatus != null) {
            wrapper.eq(Notice::getPublishStatus, publishStatus);
        }
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Notice::getTitle, keyword);
        }
        Page<Notice> result = noticeService.page(new Page<>(page, size), wrapper.orderByDesc(Notice::getId));
        return ApiResponse.ok(PageResult.of(result));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ApiResponse<?> create(@RequestBody Notice notice) {
        notice.setPublisherId(SecurityUtils.getUserId());
        if (notice.getPublishStatus() == null) {
            notice.setPublishStatus(1);
        }
        if (notice.getPublishStatus() == 2 && notice.getPublishTime() == null) {
            notice.setPublishTime(LocalDateTime.now());
        }
        noticeService.save(notice);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Notice notice) {
        notice.setId(id);
        noticeService.updateById(notice);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{id}/publish")
    public ApiResponse<?> publish(@PathVariable Long id) {
        Notice notice = noticeService.getById(id);
        if (notice == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        notice.setPublishStatus(2);
        notice.setPublishTime(LocalDateTime.now());
        noticeService.updateById(notice);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        noticeService.removeById(id);
        return ApiResponse.ok();
    }
}
