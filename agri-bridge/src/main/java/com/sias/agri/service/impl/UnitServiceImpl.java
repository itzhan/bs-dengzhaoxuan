package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.Unit;
import com.sias.agri.mapper.UnitMapper;
import com.sias.agri.service.UnitService;
import org.springframework.stereotype.Service;

@Service
public class UnitServiceImpl extends ServiceImpl<UnitMapper, Unit> implements UnitService {
}
