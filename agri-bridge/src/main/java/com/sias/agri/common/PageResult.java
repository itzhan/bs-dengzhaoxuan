package com.sias.agri.common;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.Data;

import java.util.List;

@Data
public class PageResult<T> {
    private long total;
    private long page;
    private long size;
    private List<T> records;

    public static <T> PageResult<T> of(Page<T> page) {
        PageResult<T> res = new PageResult<>();
        res.total = page.getTotal();
        res.page = page.getCurrent();
        res.size = page.getSize();
        res.records = page.getRecords();
        return res;
    }
}
