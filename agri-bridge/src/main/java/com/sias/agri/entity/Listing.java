package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_listing")
public class Listing extends BaseEntity {
    private Integer type;
    private String title;
    private Long productId;
    private BigDecimal quantity;
    private Long unitId;
    private BigDecimal price;
    private String location;
    private String description;
    private String contactName;
    private String contactPhone;
    private Integer status;
    private String remark;
    private Long publisherId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;
}
