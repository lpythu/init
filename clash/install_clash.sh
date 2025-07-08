#!/bin/bash

# Clash 安装脚本

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取Clash订阅链接
log_info "请输入Clash订阅链接:"
read -p "订阅链接: " CLASH_SUB_URL

if [ -z "$CLASH_SUB_URL" ]; then
    log_error "订阅链接不能为空"
    exit 1
fi

log_info "开始安装Clash，订阅链接: $CLASH_SUB_URL"

# 安装必要的包
log_info "安装必要的包..."
apt-get update
apt-get install -y git expect

# 创建临时目录
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# 克隆clash安装脚本
log_info "下载Clash安装脚本..."
git clone --branch master --depth 1 https://gh-proxy.com/https://github.com/nelvko/clash-for-linux-install.git
cd clash-for-linux-install

# 创建自动安装脚本
log_info "创建自动安装脚本..."
cat > auto_install.exp << 'EOF'
#!/usr/bin/expect -f

set timeout 30

# 启动安装脚本
spawn bash install.sh

# 等待提示输入订阅链接
expect "请输入订阅链接:"
send "$env(CLASH_SUB_URL)\r"

# 等待安装完成
expect eof
EOF

# 设置环境变量并执行自动安装
log_info "开始自动安装Clash..."
export CLASH_SUB_URL="$CLASH_SUB_URL"
expect auto_install.exp

# 清理临时文件
cd /
rm -rf "$TEMP_DIR"

# 检查安装结果
if systemctl is-active --quiet clash; then
    log_info "Clash安装成功并已启动"
    log_info "Clash配置文件位置: /etc/clash/config.yaml"
    log_info "Clash服务状态: $(systemctl is-active clash)"
    log_info "Clash服务端口: 7890 (HTTP), 7891 (SOCKS)"
else
    log_error "Clash安装失败或未正常启动"
    exit 1
fi

log_info "Clash安装完成！" 