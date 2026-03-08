package com.sias.agri.security;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.entity.User;
import com.sias.agri.service.UserService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    private final UserService userService;

    public UserDetailsServiceImpl(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userService.getOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (user == null) {
            throw new UsernameNotFoundException("用户不存在");
        }
        String role = UserRole.fromCode(user.getRole()).name();
        boolean enabled = user.getStatus() != null && user.getStatus() == 1;
        return new UserPrincipal(user.getId(), user.getUsername(), user.getPassword(), role, enabled);
    }
}
