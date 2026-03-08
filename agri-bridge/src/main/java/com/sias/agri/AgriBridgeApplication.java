package com.sias.agri;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.sias.agri.mapper")
public class AgriBridgeApplication {

    public static void main(String[] args) {
        SpringApplication.run(AgriBridgeApplication.class, args);
    }
}
