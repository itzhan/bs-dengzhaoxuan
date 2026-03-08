package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.Listing;
import com.sias.agri.mapper.ListingMapper;
import com.sias.agri.service.ListingService;
import org.springframework.stereotype.Service;

@Service
public class ListingServiceImpl extends ServiceImpl<ListingMapper, Listing> implements ListingService {
}
