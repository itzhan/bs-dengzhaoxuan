package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.Schedule;
import com.sias.agri.service.ScheduleService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/schedules")
public class ScheduleController {
    private final ScheduleService scheduleService;

    public ScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @GetMapping
    public ApiResponse<PageResult<Schedule>> list(@RequestParam(defaultValue = "1") long page,
                                                  @RequestParam(defaultValue = "10") long size,
                                                  @RequestParam(required = false) Long producerId,
                                                  @RequestParam(required = false) Integer type) {
        LambdaQueryWrapper<Schedule> wrapper = new LambdaQueryWrapper<>();
        if (producerId != null) {
            wrapper.eq(Schedule::getProducerId, producerId);
        }
        if (type != null) {
            wrapper.eq(Schedule::getType, type);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && producerId == null) {
            wrapper.eq(Schedule::getProducerId, SecurityUtils.getUserId());
        }
        Page<Schedule> result = scheduleService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @PostMapping
    public ApiResponse<?> create(@RequestBody Schedule schedule) {
        if (!"ADMIN".equals(SecurityUtils.getRole())) {
            schedule.setProducerId(SecurityUtils.getUserId());
        }
        scheduleService.save(schedule);
        return ApiResponse.ok();
    }

    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Schedule schedule) {
        Schedule db = scheduleService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getProducerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        schedule.setId(id);
        scheduleService.updateById(schedule);
        return ApiResponse.ok();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        Schedule db = scheduleService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getProducerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        scheduleService.removeById(id);
        return ApiResponse.ok();
    }
}
