package com.sias.agri.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sias.agri.entity.Message;
import com.sias.agri.mapper.MessageMapper;
import com.sias.agri.service.MessageService;
import org.springframework.stereotype.Service;

@Service
public class MessageServiceImpl extends ServiceImpl<MessageMapper, Message> implements MessageService {
}
