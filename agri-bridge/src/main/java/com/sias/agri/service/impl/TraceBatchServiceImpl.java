package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.TraceBatch;
import com.sias.agri.mapper.TraceBatchMapper;
import com.sias.agri.service.TraceBatchService;
import org.springframework.stereotype.Service;

@Service
public class TraceBatchServiceImpl extends ServiceImpl<TraceBatchMapper, TraceBatch> implements TraceBatchService {
}
