package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.AuditRecord;
import com.sias.agri.mapper.AuditRecordMapper;
import com.sias.agri.service.AuditRecordService;
import org.springframework.stereotype.Service;

@Service
public class AuditRecordServiceImpl extends ServiceImpl<AuditRecordMapper, AuditRecord> implements AuditRecordService {
}
