package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("dict_unit")
public class Unit extends BaseEntity {
    private String name;
    private String symbol;
}
