#!/bin/bash

# 云服务器初始化脚本
# 支持腾讯云、阿里云的 Ubuntu/Debian 系统
# 使用方法: bash <(curl -fsSL https://raw.githubusercontent.com/lpythu/init/main/init.sh)

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

# 选择云厂商
select_cloud_vendor() {
    log_info "请选择云厂商:"
    echo "1) 腾讯云"
    echo "2) 阿里云"
    
    while true; do
        read -p "请输入选择 (1-2): " choice
        case $choice in
            1)
                echo "tencent"
                log_info "已选择腾讯云"
                break
                ;;
            2)
                echo "aliyun"
                log_info "已选择阿里云"
                break
                ;;
            *)
                log_error "无效选择，请输入 1 或 2"
                ;;
        esac
    done
}

# 检测操作系统类型
get_os_type() {
    log_info "检测操作系统类型..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            echo "ubuntu"
            log_info "检测到 Ubuntu $VERSION"
        elif [[ "$ID" == "debian" ]]; then
            echo "debian"
            log_info "检测到 Debian $VERSION"
        else
            echo "other"
            log_warn "检测到 $ID，可能不完全兼容"
        fi
    else
        echo "unknown"
        log_error "无法检测操作系统类型"
    fi
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本需要root权限运行"
        exit 1
    fi
}

# 更新系统包
update_system() {
    log_info "更新系统包..."
    apt update -y
    log_info "升级系统包..."
    apt upgrade -y
}

# 安装Docker
install_docker() {
    local cloud_vendor=$1
    local os_type=$2
    
    log_info "开始安装Docker..."
    
    case "$cloud_vendor" in
        "tencent")
            case "$os_type" in
                "ubuntu")
                    bash <(curl -fsSL https://raw.githubusercontent.com/lpythu/init/main/docker/install_tencent_ubuntu.sh)
                    ;;
                "debian")
                    bash <(curl -fsSL https://raw.githubusercontent.com/lpythu/init/main/docker/install_tencent_debian.sh)
                    ;;
                *)
                    log_error "腾讯云暂不支持 $os_type 系统"
                    exit 1
                    ;;
            esac
            ;;
        "aliyun")
            case "$os_type" in
                "ubuntu")
                    bash <(curl -fsSL https://raw.githubusercontent.com/lpythu/init/main/docker/install_aliyun_ubuntu.sh)
                    ;;
                "debian")
                    bash <(curl -fsSL https://raw.githubusercontent.com/lpythu/init/main/docker/install_aliyun_debian.sh)
                    ;;
                *)
                    log_error "阿里云暂不支持 $os_type 系统"
                    exit 1
                    ;;
            esac
            ;;
        *)
            log_error "不支持的云厂商"
            exit 1
            ;;
    esac
    
    # 验证Docker安装
    if docker info >/dev/null 2>&1; then
        log_info "Docker安装成功"
    else
        log_error "Docker安装失败"
        exit 1
    fi
}

# 安装Clash
install_clash() {
    log_info "开始安装Clash..."
    bash <(curl -fsSL https://raw.githubusercontent.com/lpythu/init/main/clash/install_clash.sh)
}

# 安装zsh和oh-my-zsh
install_zsh() {
    log_info "开始安装zsh和oh-my-zsh..."
    
    # 安装zsh
    apt install zsh -y
    
    # 安装oh-my-zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "oh-my-zsh已存在，跳过安装"
    fi
    
    # 设置zsh为默认shell
    chsh -s $(which zsh)
    log_info "已将zsh设置为默认shell"
}

# 主函数
main() {
    log_info "开始云服务器初始化..."
    
    # 检查root权限
    check_root
    
    # 选择云厂商
    CLOUD_VENDOR=$(select_cloud_vendor)
    # 检测系统类型
    OS_TYPE=$(get_os_type)
    
    # 更新系统
    update_system
    
    # 安装Docker
    install_docker "$CLOUD_VENDOR" "$OS_TYPE"
    
    # 安装Clash
    install_clash
    
    # 安装zsh和oh-my-zsh
    install_zsh
    
    log_info "初始化完成！"
    log_info "请重启服务器或重新登录以使用zsh"
}

# 执行主函数
main "$@" 