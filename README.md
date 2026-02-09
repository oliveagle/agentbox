# AI Agent Toolbox

Multi-AI Agent container management tool with shared base OS layer and isolated environments per agent.

## Architecture

```
┌─────────────────────────────────────────┐
│          Base OS Layer (toolbox-base)        │
│  Ubuntu 24.04 + Dev Tools + Node/Python/Go  │
└─────────────────────────────────────────┘
                   │
    ┌──────────────┼──────────────┬──────────────┐
    │              │              │              │
┌───▼────┐    ┌───▼─────┐   ┌───▼────┐   ┌───▼──────┐
│OpenCode│    │Claude   │   │  Kilo  │   │  Copilot │
│ Agent  │    │  Code   │   │ Agent  │   │   CLI    │
└────────┘    └─────────┘   └────────┘   └──────────┘
```

## Supported Agents

| Agent | Name | Installation |
|-------|------|-------------|
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

## Quick Start

```bash
# 1. List available agents
agent-toolbox agents

# 2. Create OpenCode toolbox
agent-toolbox create opencode .

# 3. Enter toolbox
agent-toolbox enter opencode .
⬢ opencode:~$ opencode

# 4. Create Claude Code toolbox (another project)
agent-toolbox create claude-code another-project
agent-toolbox enter claude-code another-project
⬢ claude-code:~$ claude
```

## Shortcut Commands (Wrapper Scripts)

After installation, shortcut commands are generated for each agent:

```bash
# Available shortcuts:
agent-toolbox-opencode     # OpenCode
agent-toolbox-claude      # Claude Code
agent-toolbox-kilo        # Kilo
agent-toolbox-copilot     # GitHub Copilot
agent-toolbox-qwen        # Qwen
agent-toolbox-codebuddy    # CodeBuddy
```

### Shortcut Usage Examples

```bash
# Enter current directory's OpenCode toolbox
agent-toolbox-opencode .

# Create Claude Code toolbox for project
agent-toolbox-claude-code create myproject

# Run command in Kilo toolbox
agent-toolbox-kilo run . npm test

# List all Kilo toolboxes
agent-toolbox-kilo list

# Run agent in default project
agent-toolbox-qwen

# Show help
agent-toolbox-opencode --help
```

## Commands

| Command | Description |
|---------|-------------|
| `agents` | List available agents |
| `create <agent> [project]` | Create toolbox |
| `enter <agent> [project]` | Enter interactive shell |
| `run <agent> [project] [cmd]` | Run command |
| `list` | List all toolboxes |
| `rm <agent> [project]` | Delete toolbox |
| `build <agent>` | Build agent image |
| `build-all` | Build all images |

**Note:** Each agent also has a shortcut command (e.g., `agent-toolbox-opencode`) that provides the same functionality.

## Usage Examples

```bash
# OpenCode examples
cd ~/project1
agent-toolbox create opencode .
agent-toolbox enter opencode .

# Claude Code examples
agent-toolbox create claude-code project2
agent-toolbox run claude-code project2

# Run commands directly
agent-toolbox run opencode . git status
agent-toolbox run claude-code myproject npm test

# Or use shortcut commands
agent-toolbox-opencode .          # Enter current project
agent-toolbox-kilo run . npm test # Run npm test in Kilo toolbox
agent-toolbox-qwen                # Run Qwen in default project
```

## Directory Structure

```
~/.local/share/agent-toolbox/
├── repo/                    # Utility scripts
├── opencode/
│   ├── project1/           # OpenCode project1 home
│   └── project2/           # OpenCode project2 home
├── claude-code/
│   └── myproject/          # Claude Code myproject home
└── kilo/
    └── another/            # Kilo another home
```

## Configuration

Config file: `~/.config/agent-toolbox/agents.yaml`

```yaml
default_agent: opencode

agents:
  opencode:
    name: OpenCode
    image: localhost/toolbox-agent-opencode:latest
    cmd: opencode
    config_dir: ~/.config/opencode

mounts:
  agent_config: true   # Mount agent config
  gitconfig: true      # Mount git config
  ssh: false          # Don't mount SSH (optional)
  docker: false       # Don't mount Docker (optional)
```

## Image Layers

1. **Base Layer** (`toolbox-base`): Ubuntu + development tools
2. **Agent Layer** (`toolbox-agent-*`): Base layer + specific agent

Build order:
```bash
agent-toolbox build-all
# Or build individually
agent-toolbox build opencode
agent-toolbox build claude-code
```

## Adding New Agents

1. Create `agents/<name>/Containerfile`:
```dockerfile
FROM localhost/toolbox-base:latest

LABEL agent="myagent"

# Install your agent
RUN npm install -g my-agent-cli

ENV AGENT_NAME=myagent
ENV AGENT_CMD=myagent
```

2. Update config `~/.config/agent-toolbox/agents.yaml`

3. Build the image:
```bash
agent-toolbox build myagent
```

4. Generate wrapper script:
```bash
# Add your agent to AGENTS variable
AGENTS="opencode claude-code kilo copilot qwen codebuddy myagent" \
    bash lib/generate-wrappers.sh
```

## File Structure

```
toolbox-opencode/
├── agent-toolbox              # Main script
├── install.sh                 # Installation script
├── lib/
│   └── generate-wrappers.sh   # Wrapper script generator
├── images/
│   └── Containerfile.base    # Base image
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
