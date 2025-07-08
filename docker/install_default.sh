#!/bin/bash

# 默认 Docker 安装脚本（适用于其他云厂商或系统）

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

log_info "开始安装Docker (默认方式)..."

# 卸载旧版本Docker（如果存在）
log_info "清理旧版本Docker..."
apt-get remove docker docker-engine docker.io containerd runc -y 2>/dev/null || true

# 安装必要的包
log_info "安装必要的包..."
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加Docker官方GPG密钥
log_info "添加Docker官方GPG密钥..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 设置Docker仓库
log_info "设置Docker仓库..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装Docker Engine
log_info "安装Docker Engine..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 启动Docker
log_info "启动Docker..."
systemctl start docker
systemctl enable docker

log_info "Docker 安装完成！" 