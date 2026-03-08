package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.ExportRecord;
import com.sias.agri.mapper.ExportRecordMapper;
import com.sias.agri.service.ExportRecordService;
import org.springframework.stereotype.Service;

@Service
public class ExportRecordServiceImpl extends ServiceImpl<ExportRecordMapper, ExportRecord> implements ExportRecordService {
}
