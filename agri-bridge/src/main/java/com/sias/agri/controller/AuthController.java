package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.common.ApiResponse;
import com.sias.agri.common.BusinessException;
import com.sias.agri.common.ResultCode;
import com.sias.agri.dto.LoginRequest;
import com.sias.agri.dto.RegisterRequest;
import com.sias.agri.entity.User;
import com.sias.agri.security.UserPrincipal;
import com.sias.agri.security.UserRole;
import com.sias.agri.service.UserService;
import com.sias.agri.util.JwtUtils;
import com.sias.agri.util.SecurityUtils;
import jakarta.validation.Valid;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    public AuthController(UserService userService,
                          AuthenticationManager authenticationManager,
                          PasswordEncoder passwordEncoder,
                          JwtUtils jwtUtils) {
        this.userService = userService;
        this.authenticationManager = authenticationManager;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtils = jwtUtils;
    }

    @PostMapping("/register")
    public ApiResponse<?> register(@Valid @RequestBody RegisterRequest req) {
        if (req.getRole() == null || req.getRole() == UserRole.ADMIN.getCode()) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "不允许注册管理员");
        }
        boolean exists = userService.count(new LambdaQueryWrapper<User>().eq(User::getUsername, req.getUsername())) > 0;
        if (exists) {
            throw new BusinessException(ResultCode.CONFLICT, "用户名已存在");
        }
        User user = new User();
        user.setUsername(req.getUsername());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setRole(req.getRole());
        user.setStatus(1);
        user.setRealName(req.getRealName());
        user.setGender(req.getGender());
        user.setAddress(req.getAddress());
        user.setAvatar(req.getAvatar());
        userService.save(user);
        return ApiResponse.ok();
    }

    @PostMapping("/login")
    public ApiResponse<?> login(@Valid @RequestBody LoginRequest req) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.getUsername(), req.getPassword()));
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        String token = jwtUtils.createToken(principal.getId(), principal.getUsername(), principal.getRole());
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("userId", principal.getId());
        data.put("username", principal.getUsername());
        data.put("role", principal.getRole());
        return ApiResponse.ok(data);
    }

    @GetMapping("/me")
    public ApiResponse<?> me() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return ApiResponse.fail(ResultCode.UNAUTHORIZED);
        }
        User user = userService.getById(userId);
        if (user == null) {
            return ApiResponse.fail(ResultCode.NOT_FOUND);
        }
        Map<String, Object> data = new HashMap<>();
        data.put("id", user.getId());
        data.put("username", user.getUsername());
        data.put("role", UserRole.fromCode(user.getRole()).name());
        data.put("roleCode", user.getRole());
        data.put("status", user.getStatus());
        data.put("realName", user.getRealName());
        data.put("avatar", user.getAvatar());
        return ApiResponse.ok(data);
    }
}
