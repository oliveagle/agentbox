#!/bin/bash
# 生成 Agent 快捷命令 wrapper 脚本

set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-${HOME}/.local/bin}"
AGENTS="${AGENTS:-opencode claude-code kilo copilot qwen codebuddy}"

generate_wrapper() {
    local agent="$1"
    local wrapper_name="agent-toolbox-${agent}"
    local wrapper_path="${INSTALL_DIR}/${wrapper_name}"
    
    cat > "$wrapper_path" << WRAPPER
#!/bin/bash
# AI Agent Toolbox Wrapper for ${agent}
# 自动生成，请勿手动修改

set -euo pipefail

AGENT="${agent}"
TOOLBOX_CMD="agent-toolbox"

show_help() {
    cat << 'HELP'
快捷命令: ${wrapper_name}

用法:
  ${wrapper_name} create [project]     创建 toolbox
  ${wrapper_name} enter [project]      进入 toolbox（默认）
  ${wrapper_name} run [project] [cmd]  运行命令
  ${wrapper_name} build                构建镜像
  ${wrapper_name} rm [project]         删除 toolbox
  ${wrapper_name} list                 列出此 agent 的 toolbox

示例:
  ${wrapper_name}              # 进入默认项目
  ${wrapper_name} .            # 进入当前目录（自动获取项目名）
  ${wrapper_name} myproject    # 进入指定项目
  ${wrapper_name} create .     # 为当前目录创建 toolbox
  ${wrapper_name} run .        # 运行 agent（默认命令）
  ${wrapper_name} run . git status   # 在 toolbox 中运行 git status

HELP
}

# 解析参数
cmd="
project=""
args=()

# 第一个参数可能是命令或项目名
if [[ \$# -eq 0 ]]; then
    # 无参数：直接进入默认项目
    cmd="enter"
    project="."
elif [[ "\$1" == "--help" || "\$1" == "-h" || "\$1" == "help" ]]; then
    show_help
    exit 0
else
    # 检查第一个参数是否是子命令
    case "\$1" in
        create|enter|run|build|rm|remove|list|ls)
            cmd="\$1"
            shift
            project="\${1:-.}"
            shift || true
            args=("\$@")
            ;;
        *)
            # 不是命令，视为项目名
            cmd="enter"
            project="\$1"
            shift
            args=("\$@")
            ;;
    esac
fi

# 执行命令
case "\$cmd" in
    create)
        \$TOOLBOX_CMD create "\$AGENT" "\$project"
        ;;
    enter)
        \$TOOLBOX_CMD enter "\$AGENT" "\$project"
        ;;
    run)
        if [[ \${#args[@]} -eq 0 ]]; then
            \$TOOLBOX_CMD run "\$AGENT" "\$project"
        else
            \$TOOLBOX_CMD run "\$AGENT" "\$project" "\${args[@]}"
        fi
        ;;
    build)
        \$TOOLBOX_CMD build "\$AGENT"
        ;;
    rm|remove)
        \$TOOLBOX_CMD rm "\$AGENT" "\$project"
        ;;
    list|ls)
        \$TOOLBOX_CMD list | grep "toolbox-\$AGENT"
        ;;
    *)
        echo "未知命令: \$cmd"
        show_help
        exit 1
        ;;
esac
WRAPPER

    chmod +x "$wrapper_path"
    echo "Generated: $wrapper_path"
}

# 主函数
main() {
    echo "生成 Agent 快捷命令..."
    echo
    
    mkdir -p "$INSTALL_DIR"
    
    for agent in $AGENTS; do
        generate_wrapper "$agent"
    done
    
    echo
    echo "快捷命令已生成到: $INSTALL_DIR"
    echo
    echo "现在你可以使用:"
    for agent in $AGENTS; do
        echo "  agent-toolbox-${agent}"
    done
    echo
    echo "例如:"
    echo "  agent-toolbox-opencode .          # 进入 opencode toolbox"
    echo "  agent-toolbox-claude-code create  # 创建 claude-code toolbox"
    echo "  agent-toolbox-kilo run . npm test # 在 kilo toolbox 中运行命令"
}

main "$@"
