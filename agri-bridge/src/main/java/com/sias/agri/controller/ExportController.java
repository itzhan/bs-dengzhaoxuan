package com.sias.agri.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sias.agri.entity.ExportRecord;
import com.sias.agri.entity.Order;
import com.sias.agri.service.ExportRecordService;
import com.sias.agri.service.OrderService;
import com.sias.agri.util.SecurityUtils;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/api/exports")
public class ExportController {
    private final OrderService orderService;
    private final ExportRecordService exportRecordService;

    public ExportController(OrderService orderService, ExportRecordService exportRecordService) {
        this.orderService = orderService;
        this.exportRecordService = exportRecordService;
    }

    @GetMapping("/orders")
    public void exportOrders(HttpServletResponse response, @RequestParam(required = false) Integer status) throws IOException {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }
        List<Order> orders = orderService.list(wrapper);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("orders");
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("订单号");
        header.createCell(1).setCellValue("采购方");
        header.createCell(2).setCellValue("生产方");
        header.createCell(3).setCellValue("状态");
        header.createCell(4).setCellValue("总金额");
        header.createCell(5).setCellValue("总数量");
        header.createCell(6).setCellValue("收货地址");
        header.createCell(7).setCellValue("创建时间");

        int rowIdx = 1;
        for (Order order : orders) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(order.getOrderNo());
            row.createCell(1).setCellValue(order.getBuyerId());
            row.createCell(2).setCellValue(order.getSellerId());
            row.createCell(3).setCellValue(order.getStatus());
            row.createCell(4).setCellValue(order.getTotalAmount().doubleValue());
            row.createCell(5).setCellValue(order.getTotalQuantity().doubleValue());
            row.createCell(6).setCellValue(order.getDeliveryAddress());
            row.createCell(7).setCellValue(order.getCreatedAt().toString());
        }

        String fileName = "orders_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".xlsx";
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);
        workbook.write(response.getOutputStream());
        workbook.close();

        ExportRecord record = new ExportRecord();
        record.setExporterId(SecurityUtils.getUserId());
        record.setType("orders");
        record.setFileName(fileName);
        record.setStatus(2);
        exportRecordService.save(record);
    }
}
