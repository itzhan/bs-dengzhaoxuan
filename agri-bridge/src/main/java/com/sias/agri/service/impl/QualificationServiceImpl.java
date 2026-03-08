package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.Qualification;
import com.sias.agri.mapper.QualificationMapper;
import com.sias.agri.service.QualificationService;
import org.springframework.stereotype.Service;

@Service
public class QualificationServiceImpl extends ServiceImpl<QualificationMapper, Qualification> implements QualificationService {
}
