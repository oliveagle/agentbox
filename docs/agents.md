# Agent Configuration Guide

This document describes agent-specific configuration requirements and mounting paths.

## Configuration Locations

### Claude Code

- **Host path**: `$HOME/.claude`
- **Container path**: `$HOME/.claude` (mounted directly)

Claude Code stores its configuration in `~/.claude/claude_desktop_config.json`.

### OpenCode

- **Host path**: `$HOME/.config/opencode`
- **Container path**: `$HOME/.config/opencode` (mounted directly)

OpenCode stores its configuration in `~/.config/opencode/settings.json` or similar.

## OCC Agent (OpenCode + Claude)

The OCC agent mounts both configuration directories:

```yaml
occ:
  config_dirs:
    - ~/.claude        # Claude Code configuration
    - ~/.config/opencode  # OpenCode configuration
```

## Agent-Specific Configuration

| Agent | Config Directory | Notes |
|-------|-----------------|-------|
| claude | `~/.claude` | Contains `claude_desktop_config.json` |
| opencode | `~/.config/opencode` | Contains OpenCode settings |
| occ | Both above | Combined OpenCode + Claude Code |

## Troubleshooting

### Models Not Visible

If your custom models (e.g., `ole-*` prefixed) are not visible:

1. Verify config files exist on host:
   ```bash
   ls -la ~/.claude/
   ls -la ~/.config/opencode/
   ```

2. Check container mounts:
   ```bash
   podman inspect <container_name> | jq '.[0].Mounts'
   ```

3. Verify config content in container:
   ```bash
   podman exec <container_name> cat ~/.claude/claude_desktop_config.json | jq
   ```
