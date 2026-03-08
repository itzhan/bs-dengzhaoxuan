package com.sias.agri.common;

import lombok.Data;

@Data
public class ApiResponse<T> {
    private int code;
    private String message;
    private T data;

    public static <T> ApiResponse<T> ok(T data) {
        ApiResponse<T> res = new ApiResponse<>();
        res.code = ResultCode.OK.getCode();
        res.message = ResultCode.OK.getMessage();
        res.data = data;
        return res;
    }

    public static <T> ApiResponse<T> ok() {
        return ok(null);
    }

    public static <T> ApiResponse<T> fail(ResultCode code, String message) {
        ApiResponse<T> res = new ApiResponse<>();
        res.code = code.getCode();
        res.message = message == null ? code.getMessage() : message;
        return res;
    }

    public static <T> ApiResponse<T> fail(ResultCode code) {
        return fail(code, null);
    }
}
