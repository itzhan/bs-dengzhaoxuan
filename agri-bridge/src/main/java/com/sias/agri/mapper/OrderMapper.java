package com.sias.agri.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sias.agri.entity.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
