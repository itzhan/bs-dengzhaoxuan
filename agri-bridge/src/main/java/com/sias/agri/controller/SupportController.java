package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.ResultCode;
import com.sias.agri.entity.User;
import com.sias.agri.security.UserRole;
import com.sias.agri.service.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/support")
public class SupportController {
    private final UserService userService;

    public SupportController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/agent")
    public ApiResponse<?> agent() {
        User admin = userService.getOne(new LambdaQueryWrapper<User>()
                .eq(User::getRole, UserRole.ADMIN.getCode())
                .orderByAsc(User::getId)
                .last("limit 1"));
        if (admin == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        Map<String, Object> data = new HashMap<>();
        data.put("userId", admin.getId());
        data.put("name", admin.getRealName() == null ? admin.getUsername() : admin.getRealName());
        return ApiResponse.ok(data);
    }
}
