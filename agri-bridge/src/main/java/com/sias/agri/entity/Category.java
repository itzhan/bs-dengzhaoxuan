package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("dict_category")
public class Category extends BaseEntity {
    private String name;
    private Long parentId;
    private Integer sortNo;
}
