package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_trace_batch")
public class TraceBatch extends BaseEntity {
    private Long productId;
    private String batchNo;
    private Long producerId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate productionDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate harvestDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate expiryDate;
    private String traceInfo;
    private String qrCodeUrl;
    private Integer status;
}
