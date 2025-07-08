# 云服务器初始化脚本

这是一个用于云服务器快速初始化的脚本集合，支持自动检测云厂商和操作系统类型，并安装常用软件。

## 功能特性

- 🔍 **交互选择**：手动选择腾讯云或阿里云，自动检测Ubuntu/Debian系统
- 🐳 **Docker安装**：根据不同云厂商使用对应的镜像源安装Docker
- 🌐 **Clash代理**：自动安装和配置Clash代理服务
- 🐚 **Shell优化**：安装zsh和oh-my-zsh，提升命令行体验
- 🎨 **彩色输出**：友好的彩色日志输出，便于查看安装进度
- ⚡ **国内加速**：通过jsDelivr CDN加速访问，确保国内服务器可正常使用

## 支持的云厂商和系统

| 云厂商 | Ubuntu | Debian |
|--------|--------|--------|
| 腾讯云 | ✅ | ✅ |
| 阿里云 | ✅ | ✅ |

## 快速开始

### 一键安装（推荐）

```bash
# 运行初始化脚本
bash <(curl -fsSL https://fastly.jsdelivr.net/gh/lpythu/init/init.sh)
```

### 手动安装

1. 克隆仓库
```bash
git clone https://github.com/lpythu/init.git
cd init
```

2. 运行初始化脚本
```bash
bash init.sh
```

## 安装内容

### 1. Docker
- 根据云厂商自动选择最优镜像源
- 安装Docker CE、Docker Compose等组件
- 自动启动并设置开机自启

### 2. Clash代理
- 自动下载并安装Clash for Linux
- 支持自定义订阅链接
- 自动配置代理服务

### 3. zsh + oh-my-zsh
- 安装zsh shell
- 安装oh-my-zsh框架
- 自动设置为默认shell

## 使用说明

### 前置要求
- 需要root权限运行
- 支持Ubuntu 18.04+ 和 Debian 9+
- 需要网络连接

### 安装流程
1. 手动选择云厂商（腾讯云或阿里云）
2. 自动检测系统类型（Ubuntu或Debian）
3. 更新并升级系统包
4. 安装Docker（根据云厂商选择最优镜像源）
5. 安装Clash（会提示输入订阅链接）
6. 安装zsh和oh-my-zsh

### 安装完成后
1. 重启服务器或重新登录以使用zsh
2. Clash代理将在7890端口提供HTTP代理服务
3. Docker服务已启动并设置为开机自启

## 文件结构

```
init/
├── README.md                 # 项目说明文档
├── init.sh                   # 主入口脚本
├── docker/                   # Docker安装脚本
│   ├── install_tencent_ubuntu.sh
│   ├── install_tencent_debian.sh
│   ├── install_aliyun_ubuntu.sh
│   └── install_aliyun_debian.sh
└── clash/                    # Clash安装脚本
    └── install_clash.sh
```

## 故障排除

### 常见问题

1. **权限不足**
   ```bash
   # 确保使用root权限运行
   sudo su -
   bash <(curl -fsSL https://fastly.jsdelivr.net/gh/lpythu/init/init.sh)
   ```

2. **网络连接问题**
   - 检查服务器网络连接
   - 确认防火墙设置
   - 尝试使用国内镜像源

3. **Docker安装失败**
   - 检查系统版本兼容性
   - 确认包管理器正常工作
   - 查看详细错误日志

4. **Clash配置问题**
   - 检查订阅链接有效性
   - 确认订阅链接格式正确
   - 查看Clash服务状态：`systemctl status clash`

### 日志查看

```bash
# 查看Clash服务状态
systemctl status clash

# 查看Docker服务状态
systemctl status docker

# 查看Clash日志
journalctl -u clash -f
```

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 许可证

MIT License

## 更新日志

### v1.0.0
- 初始版本发布
- 支持腾讯云、阿里云的Ubuntu/Debian系统
- 自动安装Docker、Clash、zsh+oh-my-zsh
- 通过fastly.jsdelivr.net CDN加速访问 