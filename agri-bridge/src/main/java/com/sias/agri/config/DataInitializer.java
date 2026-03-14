package com.sias.agri.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.entity.User;
import com.sias.agri.security.UserRole;
import com.sias.agri.service.UserService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        // 1. 自动创建管理员账号
        long adminCount = userService.count(new LambdaQueryWrapper<User>().eq(User::getRole, UserRole.ADMIN.getCode()));
        if (adminCount == 0) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("123456"));
            admin.setRole(UserRole.ADMIN.getCode());
            admin.setStatus(1);
            admin.setRealName("系统管理员");
            userService.save(admin);
        }

        // 2. 修复 SQL 中 dummy 占位密码 → 统一设为 123456
        java.util.List<User> dummyUsers = userService.list(
            new LambdaQueryWrapper<User>().likeRight(User::getPassword, "$2a$10$dummy")
        );
        if (!dummyUsers.isEmpty()) {
            String encoded = passwordEncoder.encode("123456");
            for (User u : dummyUsers) {
                u.setPassword(encoded);
            }
            userService.updateBatchById(dummyUsers);
        }
    }
}
