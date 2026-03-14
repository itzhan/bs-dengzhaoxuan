@echo off
chcp 65001 >nul
title 农产品产销对接管理系统 — 一键启动
color 0A

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║      农产品产销对接管理系统 — Windows 一键启动脚本      ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

:: ═══════════════════════════════════════
::  路径定义
:: ═══════════════════════════════════════
set "SCRIPT_DIR=%~dp0"
set "BACKEND_DIR=%SCRIPT_DIR%agri-bridge"
set "ADMIN_DIR=%SCRIPT_DIR%art-design-pro"
set "FRONT_DIR=%SCRIPT_DIR%front"

:: ═══════════════════════════════════════
::  环境检查
:: ═══════════════════════════════════════
echo [1/4] 检查运行环境...

where java >nul 2>&1
if %errorlevel% neq 0 (
    echo   × 未找到 Java，请安装 JDK 17+
    pause
    exit /b 1
)
echo   √ Java 已安装

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo   × 未找到 Node.js，请安装 Node.js 20+
    pause
    exit /b 1
)
echo   √ Node.js 已安装

where pnpm >nul 2>&1
if %errorlevel% neq 0 (
    echo   × 未找到 pnpm，请运行: npm install -g pnpm
    pause
    exit /b 1
)
echo   √ pnpm 已安装
echo.

:: ═══════════════════════════════════════
::  安装前端依赖
:: ═══════════════════════════════════════
echo [2/4] 检查前端依赖...

if not exist "%ADMIN_DIR%\node_modules" (
    echo   正在安装管理后台依赖（首次运行需等待）...
    cd /d "%ADMIN_DIR%"
    call pnpm install --frozen-lockfile
) else (
    echo   √ 管理后台依赖已安装
)

if not exist "%FRONT_DIR%\node_modules" (
    echo   正在安装用户前台依赖（首次运行需等待）...
    cd /d "%FRONT_DIR%"
    call pnpm install --frozen-lockfile
) else (
    echo   √ 用户前台依赖已安装
)
echo.

:: ═══════════════════════════════════════
::  启动后端
:: ═══════════════════════════════════════
echo [3/4] 启动后端服务...
echo   后端启动中（请等待 Spring Boot 初始化）...
start "agri-bridge-backend" cmd /c "cd /d "%BACKEND_DIR%" && mvnw.cmd spring-boot:run"
echo   √ 后端已在新窗口启动
echo.

:: ═══════════════════════════════════════
::  启动前端
:: ═══════════════════════════════════════
echo [4/4] 启动前端服务...

start "agri-bridge-admin" cmd /c "cd /d "%ADMIN_DIR%" && pnpm dev"
echo   √ 管理后台已在新窗口启动

start "agri-bridge-front" cmd /c "cd /d "%FRONT_DIR%" && pnpm dev"
echo   √ 用户前台已在新窗口启动
echo.

:: ═══════════════════════════════════════
::  输出启动信息
:: ═══════════════════════════════════════
echo ╔══════════════════════════════════════════════════════════╗
echo ║                 所有服务已启动                           ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║  后端 API:      http://localhost:8080                   ║
echo ║  管理后台:      http://localhost:3006                   ║
echo ║  用户前台:      http://localhost:5173                   ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║              系统账号信息                                ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║  角色        用户名          密码       姓名             ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║  管理员      admin           123456     系统管理员       ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║  生产方      producer01      123456     郑丽             ║
echo ║  生产方      producer02      123456     王强             ║
echo ║  生产方      producer03      123456     赵敏             ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║  采购方      buyer01         123456     李晨             ║
echo ║  采购方      buyer02         123456     周杰             ║
echo ║  采购方      buyer03         123456     林雨             ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo 提示: 关闭此窗口不会停止服务。
echo       如需停止，请关闭各服务的命令窗口。
echo.
pause
