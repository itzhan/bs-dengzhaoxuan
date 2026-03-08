package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.PageResult;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.Inventory;
import com.sias.agri.service.InventoryService;
import com.sias.agri.util.SecurityUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/inventories")
public class InventoryController {
    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @GetMapping
    public ApiResponse<PageResult<Inventory>> list(@RequestParam(defaultValue = "1") long page,
                                                   @RequestParam(defaultValue = "10") long size,
                                                   @RequestParam(required = false) Long producerId,
                                                   @RequestParam(required = false) Long productId) {
        LambdaQueryWrapper<Inventory> wrapper = new LambdaQueryWrapper<>();
        if (producerId != null) {
            wrapper.eq(Inventory::getProducerId, producerId);
        }
        if (productId != null) {
            wrapper.eq(Inventory::getProductId, productId);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && producerId == null) {
            wrapper.eq(Inventory::getProducerId, SecurityUtils.getUserId());
        }
        Page<Inventory> result = inventoryService.page(new Page<>(page, size), wrapper);
        return ApiResponse.ok(PageResult.of(result));
    }

    @PostMapping
    public ApiResponse<?> create(@RequestBody Inventory inventory) {
        if (!"ADMIN".equals(SecurityUtils.getRole())) {
            inventory.setProducerId(SecurityUtils.getUserId());
        }
        inventoryService.save(inventory);
        return ApiResponse.ok();
    }

    @PutMapping("/{id}")
    public ApiResponse<?> update(@PathVariable Long id, @RequestBody Inventory inventory) {
        Inventory db = inventoryService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getProducerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        inventory.setId(id);
        inventoryService.updateById(inventory);
        return ApiResponse.ok();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> delete(@PathVariable Long id) {
        Inventory db = inventoryService.getById(id);
        if (db == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        if (!"ADMIN".equals(SecurityUtils.getRole()) && !db.getProducerId().equals(SecurityUtils.getUserId())) {
            return ApiResponse.fail(ResultCode.FORBIDDEN);
        }
        inventoryService.removeById(id);
        return ApiResponse.ok();
    }
}
