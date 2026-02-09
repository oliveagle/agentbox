#!/bin/bash
# 卸载旧版 opencode-toolbox（临时脚本）

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
OLD_CONFIG_DIR="${HOME}/.config/opencode-toolbox"
OLD_DATA_DIR="${HOME}/.local/share/opencode-toolbox"
OLD_CACHE_DIR="${HOME}/.cache/opencode-toolbox"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

detect_engine() {
    if command -v podman &> /dev/null; then
        echo "podman"
    elif command -v docker &> /dev/null; then
        echo "docker"
    else
        echo "podman"
    fi
}

CONTAINER_ENGINE=$(detect_engine)

remove_old_containers() {
    log_info "查找旧版 opencode-toolbox 容器..."
    
    local containers
    containers=$("$CONTAINER_ENGINE" ps -a --filter "name=toolbox-opencode-" --format "{{.Names}}" 2>/dev/null || true)
    
    if [[ -n "$containers" ]]; then
        echo "找到以下旧版容器:"
        echo "$containers"
        echo
        read -p "是否删除? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$containers" | while read -r container; do
                log_info "删除: $container"
                "$CONTAINER_ENGINE" rm -f "$container" 2>/dev/null || true
            done
            log_success "旧版容器已删除"
        fi
    else
        log_info "没有找到旧版容器"
    fi
}

remove_old_images() {
    log_info "查找旧版镜像..."
    
    local images
    images=$("$CONTAINER_ENGINE" images --format "{{.Repository}}:{{.Tag}}" | grep "localhost/opencode-toolbox" || true)
    
    if [[ -n "$images" ]]; then
        echo "找到以下旧版镜像:"
        echo "$images"
        echo
        read -p "是否删除? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$images" | while read -r image; do
                log_info "删除: $image"
                "$CONTAINER_ENGINE" rmi -f "$image" 2>/dev/null || true
            done
            log_success "旧版镜像已删除"
        fi
    else
        log_info "没有找到旧版镜像"
    fi
}

remove_old_script() {
    log_info "删除旧版脚本..."
    
    local locations=(
        "${INSTALL_DIR}/opencode-toolbox"
        "${HOME}/.local/bin/opencode-toolbox"
        "/usr/local/bin/opencode-toolbox"
    )
    
    for loc in "${locations[@]}"; do
        if [[ -f "$loc" ]]; then
            log_info "删除: $loc"
            rm -f "$loc" 2>/dev/null || sudo rm -f "$loc" 2>/dev/null || true
        fi
    done
    
    log_success "旧版脚本已删除"
}

remove_old_data() {
    log_info "旧版数据目录:"
    echo "  配置: $OLD_CONFIG_DIR"
    echo "  数据: $OLD_DATA_DIR"
    echo "  缓存: $OLD_CACHE_DIR"
    echo
    
    read -p "是否删除所有旧版数据? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$OLD_CONFIG_DIR"
        rm -rf "$OLD_DATA_DIR"
        rm -rf "$OLD_CACHE_DIR"
        log_success "旧版数据已删除"
    fi
}

main() {
    echo "================================"
    echo "卸载旧版 opencode-toolbox"
    echo "================================"
    echo
    
    remove_old_containers
    echo
    remove_old_images
    echo
    remove_old_script
    echo
    remove_old_data
    
    echo
    log_success "旧版 opencode-toolbox 已完全卸载"
    echo
    echo "现在可以安装新版 AI Agent Toolbox:"
    echo '  curl -fsSL https://raw.githubusercontent.com/oliveagle/toolbox-opencode/main/install.sh | bash'
}

main "$@"
