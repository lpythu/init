#!/bin/bash

# 阿里云 Debian 系统 Docker 安装脚本

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

log_info "开始安装Docker (阿里云 Debian)..."

# 更新包管理工具
log_info "更新包管理工具..."
apt-get update

# 添加Docker软件包源
log_info "添加Docker软件包源..."
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL http://mirrors.cloud.aliyuncs.com/docker-ce/linux/debian/gpg | apt-key add -
add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] http://mirrors.cloud.aliyuncs.com/docker-ce/linux/debian $(lsb_release -cs) stable"

# 安装Docker社区版本
log_info "安装Docker社区版本..."
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 启动Docker
log_info "启动Docker..."
systemctl start docker
systemctl enable docker

log_info "Docker 安装完成！" 