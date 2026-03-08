package com.sias.agri.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sias.agri.entity.AuditRecord;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuditRecordMapper extends BaseMapper<AuditRecord> {
}
