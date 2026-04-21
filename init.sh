#!/bin/bash
#======================================================================
# 系统支持：Ubuntu 20.04.6 LTS
# 功能说明：
#    1. 备份原有系统软件源
#    2. 切换为国内阿里云高速源
#    3. apt update 更新软件源索引
#    4. apt upgrade 升级所有已安装软件包
#    5. 自动清理无用依赖与缓存
#    6. 安装 Docker CE 稳定版（国内源）
#    7. 安装 Docker Compose V2（兼容V1命令与旧yml）
#    8. 设置开机自启并启动服务
#    9. 清晰展示 Docker & Compose 版本信息
# 兼容说明：
#    - V2 完全兼容 V1 的 docker-compose.yml
#    - 同时支持 docker compose 和 docker-compose 两种命令
#======================================================================

#--------------------------
# 终端颜色定义
#--------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 输出格式函数
Info() {
    echo -e "[${GREEN}INFO${NC}] $1"
}

Warn() {
    echo -e "[${YELLOW}WARN${NC}] $1"
}

Success() {
    echo -e "[${GREEN}SUCCESS${NC}] $1"
}

Error() {
    echo -e "[${RED}ERROR${NC}] $1"
}

clear

Info "========================================================="
Info "     Ubuntu 20.04 初始化脚本 | 系统换源 + Docker 完整版"
Info "     Docker Compose V2 + 完美兼容 V1 格式与命令"
Info "========================================================="
echo ""

#--------------------------
# 系统版本校验
#--------------------------
Info "【系统检查】检测当前操作系统版本"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ] || [ "$VERSION_ID" != "20.04" ]; then
        Error "仅支持 Ubuntu 20.04 系统，退出执行"
        exit 1
    fi
else
    Error "无法识别操作系统，脚本终止"
    exit 1
fi
Success "系统检测通过：${PRETTY_NAME}"
echo ""

#======================================================================
# 步骤1：备份原有软件源
#======================================================================
Info "【步骤 1/7】备份原有系统软件源"
backup_file="/etc/apt/sources.list.bak.$(date +%Y%m%d%H%M%S)"
cp -a /etc/apt/sources.list "${backup_file}"

if [ $? -eq 0 ]; then
    Success "备份完成：${backup_file}"
else
    Error "备份失败，脚本终止"
    exit 1
fi
echo ""

#======================================================================
# 步骤2：写入阿里云国内源
#======================================================================
Info "【步骤 2/7】切换为阿里云 Ubuntu 20.04 官方源"
cat > /etc/apt/sources.list << EOF
deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
EOF

Success "国内源替换完成"
echo ""

#======================================================================
# 步骤3：更新软件源索引
#======================================================================
Info "【步骤 3/7】执行 apt update 更新源缓存"
apt update -y

if [ $? -eq 0 ]; then
    Success "apt update 执行成功"
else
    Error "apt update 执行失败"
    exit 1
fi
echo ""

#======================================================================
# 步骤4：升级系统已安装包
#======================================================================
Info "【步骤 4/7】执行 apt upgrade 升级所有软件包"
apt upgrade -y

Success "软件包升级完成"
echo ""

#======================================================================
# 步骤5：清理无用依赖包
#======================================================================
Info "【步骤 5/7】清理无用依赖与缓存"
apt autoremove -y
apt clean

Success "系统清理完成"
echo ""

#======================================================================
# 步骤6：安装 Docker CE（国内阿里云源）
#======================================================================
Info "【步骤 6/7】安装 Docker CE 稳定版"

# 安装依赖工具
apt install -y curl gnupg2 ca-certificates lsb-release

# 导入 Docker GPG 密钥
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加 Docker 软件源
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 更新并安装
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io

# 开机自启 + 启动服务
systemctl enable docker
systemctl start docker

Success "Docker 安装并启动完成"
echo ""

#======================================================================
# 步骤7：安装 Docker Compose V2 + 兼容 V1
#======================================================================
Info "【步骤 7/7】安装 Docker Compose V2（兼容V1命令与yml）"

# 安装 V2 官方插件路径
curl -SL https://mirrors.aliyun.com/docker-compose/releases/download/v2.29.6/docker-compose-linux-$(uname -m) -o /usr/libexec/docker/cli-plugins/docker-compose

# 赋予执行权限
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# 创建兼容链接，保证老命令 docker-compose 可用
ln -sf /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

Success "Docker Compose V2 安装完成，已兼容 V1 模式"
echo ""

#======================================================================
# 最终版本展示
#======================================================================
Info "================================================"
Info "               安装版本信息"
Info "================================================"
echo ""

Info "Docker 版本信息："
Success "$(docker --version)"
echo ""

Info "Docker Compose V2 版本信息："
Success "$(docker compose version)"
echo ""

Info "================================================"
Success "          全部任务执行完成！"
Info "  兼容说明：老yml与docker-compose命令均可正常使用"
Info "================================================"