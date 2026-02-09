# AI Agent Toolbox

多 AI Agent 容器管理工具，共享基础 OS 层，每个 Agent 独立隔离。

## 架构

```
┌─────────────────────────────────────────┐
│          基础 OS 层 (toolbox-base)        │
│  Ubuntu 24.04 + 开发工具链 + Node/Python/Go  │
└─────────────────────────────────────────┘
                   │
    ┌──────────────┼──────────────┬──────────────┐
    │              │              │              │
┌───▼────┐    ┌───▼─────┐   ┌───▼────┐   ┌───▼──────┐
│OpenCode│    │Claude   │   │  Kilo  │   │  Copilot │
│ Agent  │    │  Code   │   │ Agent  │   │   CLI    │
└────────┘    └─────────┘   └────────┘   └──────────┘
```

## 支持的 Agents

| Agent | 名称 | 安装方式 |
|-------|------|---------|
| `opencode` | OpenCode AI | `npm install -g opencode-ai` |
| `claude-code` | Claude Code | `npm install -g @anthropic-ai/claude-code` |
| `kilo` | Kilo AI | `npm install -g kilo-ai` |
| `copilot` | GitHub Copilot | `gh extension install github/copilot` |
| `qwen` | Qwen AI | `pip3 install qwen-code` |
| `codebuddy` | CodeBuddy | `npm install -g codebuddy-cli` |

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/oliveagle/toolbox-opencode/main/install.sh | bash
```

## 快速开始

```bash
# 1. 查看可用 Agents
agent-toolbox agents

# 2. 创建 OpenCode toolbox
agent-toolbox create opencode .

# 3. 进入 toolbox
agent-toolbox enter opencode .
⬢ opencode:~$ opencode

# 4. 创建 Claude Code toolbox（另一个项目）
agent-toolbox create claude-code another-project
agent-toolbox enter claude-code another-project
⬢ claude-code:~$ claude
```

## 命令

| 命令 | 说明 |
|------|------|
| `agents` | 列出可用 Agents |
| `create <agent> [project]` | 创建 toolbox |
| `enter <agent> [project]` | 进入交互式 shell |
| `run <agent> [project] [cmd]` | 运行命令 |
| `list` | 列出所有 toolbox |
| `rm <agent> [project]` | 删除 toolbox |
| `build <agent>` | 构建 Agent 镜像 |
| `build-all` | 构建所有镜像 |

## 使用示例

```bash
# OpenCode 示例
cd ~/project1
agent-toolbox create opencode .
agent-toolbox enter opencode .

# Claude Code 示例
agent-toolbox create claude-code project2
agent-toolbox run claude-code project2

# 直接运行命令
agent-toolbox run opencode . git status
agent-toolbox run claude-code myproject npm test
```

## 目录结构

```
~/.local/share/agent-toolbox/
├── repo/                    # 工具脚本
├── opencode/
│   ├── project1/           # OpenCode project1 的 home
│   └── project2/           # OpenCode project2 的 home
├── claude-code/
│   └── myproject/          # Claude Code myproject 的 home
└── kilo/
    └── another/            # Kilo another 的 home
```

## 配置

配置文件：`~/.config/agent-toolbox/agents.yaml`

```yaml
default_agent: opencode

agents:
  opencode:
    name: OpenCode
    image: localhost/toolbox-agent-opencode:latest
    cmd: opencode
    config_dir: ~/.config/opencode

mounts:
  agent_config: true   # 挂载 Agent 配置
  gitconfig: true      # 挂载 Git 配置
  ssh: false          # 不挂载 SSH（可选）
  docker: false       # 不挂载 Docker（可选）
```

## 镜像层级

1. **基础层** (`toolbox-base`): Ubuntu + 开发环境
2. **Agent 层** (`toolbox-agent-*`): 基础层 + 特定 Agent

构建顺序：
```bash
agent-toolbox build-all
# 或单独构建
agent-toolbox build opencode
agent-toolbox build claude-code
```

## 添加新 Agent

1. 创建 `agents/<name>/Containerfile`:
```dockerfile
FROM localhost/toolbox-base:latest

LABEL agent="myagent"

# 安装你的 agent
RUN npm install -g my-agent-cli

ENV AGENT_NAME=myagent
ENV AGENT_CMD=myagent
```

2. 更新配置 `~/.config/agent-toolbox/agents.yaml`

3. 构建镜像：
```bash
agent-toolbox build myagent
```

## 文件结构

```
toolbox-opencode/
├── agent-toolbox              # 主脚本
├── install.sh                 # 安装脚本
├── images/
│   └── Containerfile.base     # 基础镜像
├── agents/
│   ├── opencode/
│   │   └── Containerfile
│   ├── claude-code/
│   │   └── Containerfile
│   ├── kilo/
│   │   └── Containerfile
│   └── ...
└── README.md
```

## License

MIT License
