package com.sias.agri.security;

public enum UserRole {
    ADMIN(1),
    PRODUCER(2),
    BUYER(3);

    private final int code;

    UserRole(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    public static UserRole fromCode(Integer code) {
        if (code == null) {
            return BUYER;
        }
        for (UserRole role : values()) {
            if (role.code == code) {
                return role;
            }
        }
        return BUYER;
    }
}
