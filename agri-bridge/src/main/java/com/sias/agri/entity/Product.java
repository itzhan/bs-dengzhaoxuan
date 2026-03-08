package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_product")
public class Product extends BaseEntity {
    private String name;
    private Long categoryId;
    private Long unitId;
    private String origin;
    private String description;
    private String imageUrl;
    private Integer traceable;
    private Integer status;
    private Long ownerId;
}
