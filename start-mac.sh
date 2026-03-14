#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  农产品产销对接管理系统 — Mac 一键启动脚本
#  功能：自动导入数据库 → 启动后端 → 启动管理后台 → 启动用户前台
# ═══════════════════════════════════════════════════════════════

# 不使用 set -e，避免后台进程退出码干扰

# ---------- 颜色定义 ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # 无色

# ---------- 路径定义 ----------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/agri-bridge"
ADMIN_DIR="$SCRIPT_DIR/art-design-pro"
FRONT_DIR="$SCRIPT_DIR/front"
SQL_FILE="$BACKEND_DIR/docs/数据库.sql"

# ---------- MySQL 配置 ----------
MYSQL_USER="root"
MYSQL_PASS="ab123168"
DB_NAME="agri_bridge"
MYSQL_CMD="mysql --user=${MYSQL_USER} --password=${MYSQL_PASS}"

# ---------- 进程 PID 记录（用于退出时清理） ----------
PIDS=()

cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 正在停止所有服务...${NC}"
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null
            wait "$pid" 2>/dev/null || true
        fi
    done
    echo -e "${GREEN}✅ 所有服务已停止${NC}"
    exit 0
}
trap cleanup SIGINT SIGTERM

# ═══════════════════════════════════════
#  Banner
# ═══════════════════════════════════════
clear
echo -e "${GREEN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║      🌾 农产品产销对接管理系统 — 一键启动脚本 🌾       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ═══════════════════════════════════════
#  环境检查
# ═══════════════════════════════════════
echo -e "${CYAN}[1/5] 🔍 检查运行环境...${NC}"

# 检查 Java
if ! command -v java &>/dev/null; then
    echo -e "${RED}❌ 未找到 Java，请安装 JDK 17+${NC}"
    exit 1
fi
JAVA_VER=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)
echo -e "  ✓ Java ${GREEN}$JAVA_VER${NC}"

# 检查 Node.js
if ! command -v node &>/dev/null; then
    echo -e "${RED}❌ 未找到 Node.js，请安装 Node.js 20+${NC}"
    exit 1
fi
NODE_VER=$(node --version)
echo -e "  ✓ Node.js ${GREEN}$NODE_VER${NC}"

# 检查 pnpm
if ! command -v pnpm &>/dev/null; then
    echo -e "${RED}❌ 未找到 pnpm，请运行: npm install -g pnpm${NC}"
    exit 1
fi
PNPM_VER=$(pnpm --version)
echo -e "  ✓ pnpm ${GREEN}$PNPM_VER${NC}"

# 检查 MySQL
if ! command -v mysql &>/dev/null; then
    echo -e "${RED}❌ 未找到 mysql 命令行工具，请安装 MySQL${NC}"
    exit 1
fi
echo -e "  ✓ MySQL ${GREEN}已安装${NC}"

# 检查 MySQL 连接
MYSQL_OK=0
$MYSQL_CMD -e "SELECT 1" &>/dev/null && MYSQL_OK=1
if [ "$MYSQL_OK" -ne 1 ]; then
    echo -e "${RED}❌ 无法连接 MySQL（用户: ${MYSQL_USER}），请检查 MySQL 是否运行及密码是否正确${NC}"
    exit 1
fi
echo -e "  ✓ MySQL 连接 ${GREEN}正常${NC}"
echo ""

# ═══════════════════════════════════════
#  数据库导入
# ═══════════════════════════════════════
echo -e "${CYAN}[2/5] 🗄️  检查并导入数据库...${NC}"

DB_EXISTS=$($MYSQL_CMD -N -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$DB_NAME'" 2>/dev/null)
TABLE_COUNT=0
if [ -n "$DB_EXISTS" ]; then
    TABLE_COUNT=$($MYSQL_CMD -N -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='$DB_NAME'" 2>/dev/null)
fi

if [ -n "$DB_EXISTS" ] && [ "$TABLE_COUNT" -gt 5 ]; then
    echo -e "  ✓ 数据库 ${GREEN}$DB_NAME${NC} 已存在（${TABLE_COUNT} 张表），${YELLOW}跳过导入${NC}"
else
    if [ ! -f "$SQL_FILE" ]; then
        echo -e "${RED}❌ SQL 文件不存在: $SQL_FILE${NC}"
        exit 1
    fi
    echo -e "  ⏳ 正在导入数据库..."
    $MYSQL_CMD < "$SQL_FILE" 2>/dev/null
    echo -e "  ✓ 数据库 ${GREEN}$DB_NAME${NC} 导入完成"
fi
echo ""

# ═══════════════════════════════════════
#  安装前端依赖
# ═══════════════════════════════════════
echo -e "${CYAN}[3/5] 📦 检查前端依赖...${NC}"

if [ ! -d "$ADMIN_DIR/node_modules" ]; then
    echo -e "  ⏳ 正在安装管理后台依赖（首次运行需等待）..."
    (cd "$ADMIN_DIR" && pnpm install --frozen-lockfile 2>&1 | tail -3)
else
    echo -e "  ✓ 管理后台依赖 ${GREEN}已安装${NC}"
fi

if [ ! -d "$FRONT_DIR/node_modules" ]; then
    echo -e "  ⏳ 正在安装用户前台依赖（首次运行需等待）..."
    (cd "$FRONT_DIR" && pnpm install --frozen-lockfile 2>&1 | tail -3)
else
    echo -e "  ✓ 用户前台依赖 ${GREEN}已安装${NC}"
fi
echo ""

# ═══════════════════════════════════════
#  清理可能遗留的端口占用
# ═══════════════════════════════════════
for PORT in 8080 3006 5173; do
    PID_ON_PORT=$(lsof -ti:$PORT 2>/dev/null || true)
    if [ -n "$PID_ON_PORT" ]; then
        echo -e "  ${YELLOW}⚠️  端口 $PORT 被占用，正在释放...${NC}"
        echo "$PID_ON_PORT" | xargs kill -9 2>/dev/null || true
        sleep 1
    fi
done

# ═══════════════════════════════════════
#  启动后端
# ═══════════════════════════════════════
echo -e "${CYAN}[4/5] 🚀 启动后端服务...${NC}"

BACKEND_LOG="/tmp/agri-bridge-backend.log"
> "$BACKEND_LOG"
(cd "$BACKEND_DIR" && ./mvnw spring-boot:run -q 2>&1 | tee "$BACKEND_LOG") &
BACKEND_PID=$!
PIDS+=($BACKEND_PID)
echo -e "  ✓ 后端启动中... (PID: ${GREEN}${BACKEND_PID}${NC})"

# 等待后端就绪
echo -ne "  ⏳ 等待后端就绪"
for i in $(seq 1 60); do
    if curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/api/auth/login 2>/dev/null | grep -qE '(200|401|405|400)'; then
        echo ""
        echo -e "  ✓ 后端 ${GREEN}已就绪${NC} (http://localhost:8080)"
        break
    fi
    echo -ne "."
    sleep 2
    if [ $i -eq 60 ]; then
        echo ""
        echo -e "  ${YELLOW}⚠️  后端可能仍在启动中，继续启动前端...${NC}"
    fi
done
echo ""

# ═══════════════════════════════════════
#  启动前端
# ═══════════════════════════════════════
echo -e "${CYAN}[5/5] 🚀 启动前端服务...${NC}"

ADMIN_LOG="/tmp/agri-bridge-admin.log"
FRONT_LOG="/tmp/agri-bridge-front.log"
> "$ADMIN_LOG"
> "$FRONT_LOG"

(cd "$ADMIN_DIR" && pnpm dev 2>&1 | tee "$ADMIN_LOG") &
ADMIN_PID=$!
PIDS+=($ADMIN_PID)
echo -e "  ✓ 管理后台启动中... (PID: ${GREEN}${ADMIN_PID}${NC})"

(cd "$FRONT_DIR" && pnpm dev 2>&1 | tee "$FRONT_LOG") &
FRONT_PID=$!
PIDS+=($FRONT_PID)
echo -e "  ✓ 用户前台启动中... (PID: ${GREEN}${FRONT_PID}${NC})"

# 等待前端就绪
sleep 5
echo ""

# ═══════════════════════════════════════
#  输出启动信息
# ═══════════════════════════════════════
echo -e "${GREEN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                 ✅ 所有服务已启动                       ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  📡 后端 API:      http://localhost:8080                ║"
echo "║  🖥️  管理后台:      http://localhost:3006                ║"
echo "║  🌐 用户前台:      http://localhost:5173                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║              📋 系统账号信息                             ║${NC}"
echo -e "${BOLD}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}║  角色        用户名          密码       姓名             ║${NC}"
echo -e "${BOLD}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "║  ${RED}管理员${NC}      admin           123456     系统管理员       ║"
echo -e "${BOLD}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "║  ${BLUE}生产方${NC}      producer01      123456     郑丽             ║"
echo -e "║  ${BLUE}生产方${NC}      producer02      123456     王强             ║"
echo -e "║  ${BLUE}生产方${NC}      producer03      123456     赵敏             ║"
echo -e "${BOLD}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "║  ${MAGENTA}采购方${NC}      buyer01         123456     李晨             ║"
echo -e "║  ${MAGENTA}采购方${NC}      buyer02         123456     周杰             ║"
echo -e "║  ${MAGENTA}采购方${NC}      buyer03         123456     林雨             ║"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}💡 提示: 按 Ctrl+C 停止所有服务${NC}"
echo ""

# ═══════════════════════════════════════
#  实时日志聚合
# ═══════════════════════════════════════
echo -e "${CYAN}📜 实时日志输出（后端 + 管理后台 + 用户前台）：${NC}"
echo "────────────────────────────────────────────────────────────"

tail -f "$BACKEND_LOG" "$ADMIN_LOG" "$FRONT_LOG" 2>/dev/null &
PIDS+=($!)

# 等待退出
wait
