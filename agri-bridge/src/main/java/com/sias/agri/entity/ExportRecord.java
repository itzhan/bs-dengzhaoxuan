package com.sias.agri.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_export_record")
public class ExportRecord extends BaseEntity {
    private Long exporterId;
    private String type;
    private String params;
    private String fileName;
    private String fileUrl;
    private Integer status;
}
