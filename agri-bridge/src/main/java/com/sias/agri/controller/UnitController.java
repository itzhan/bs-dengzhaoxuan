package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.entity.Unit;
import com.sias.agri.service.UnitService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/units")
public class UnitController {
    private final UnitService unitService;

    public UnitController(UnitService unitService) {
        this.unitService = unitService;
    }

    @GetMapping
    public ApiResponse<PageResult<Unit>> list(@RequestParam(defaultValue = "1") long page,
                                              @RequestParam(defaultValue = "10") long size,
                                              @RequestParam(required = false) String keyword) {
        LambdaQueryWrapper<Unit> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Unit::getName, keyword);
        }
        Page<Unit> result = unitService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ApiResponse<?> create(@RequestBody Unit unit) {
        unitService.save(unit);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Unit unit) {
        unit.setId(id);
        unitService.updateById(unit);
        return ApiResponse.ok();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        unitService.removeById(id);
        return ApiResponse.ok();
    }
}
