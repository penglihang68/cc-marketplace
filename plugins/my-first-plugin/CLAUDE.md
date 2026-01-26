# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin that demonstrates the plugin system architecture. The plugin provides custom commands and hooks that extend Claude Code's functionality.

## Architecture

### Plugin Structure

The plugin follows a specific directory structure required by Claude Code:

- `.claude-plugin/plugin.json` - Plugin manifest that declares the plugin name, version, commands, and hooks
- `commands/` - Contains command definitions (markdown files with embedded logic)
- `hooks/` - Contains hook definitions (markdown files that intercept events)

### Plugin Manifest (`.claude-plugin/plugin.json`)

The manifest file defines:
- `name`: Plugin identifier
- `version`: Semantic version
- `commands`: Array of paths to command definition files
- `hooks`: Object mapping hook events to handler files (e.g., `pre-command`)

### Command System

Commands are defined as markdown files in the `commands/` directory. Each command file should include:
- **Header**: Command name and description
- **Workflow section**: Step-by-step logic for Claude to execute
- **Identity section** (optional): Role and tone instructions for Claude

Example: `commands/hello.md` demonstrates a greeting command with file system access.

### Hook System

Hooks are event handlers defined as markdown files in the `hooks/` directory. They intercept specific events and can:
- Execute logic before commands run (`pre-command`)
- Block or allow operations conditionally
- Remain silent when conditions aren't met

Example: `hooks/check-todos.md` intercepts git commits and checks for TODO/FIXME comments in staged changes.

## Development

### File Organization

When adding new functionality:
- Place command definitions in `commands/` as `.md` files
- Place hook definitions in `hooks/` as `.md` files
- Register all commands and hooks in `.claude-plugin/plugin.json`

### Command Definition Format

Commands follow this structure:
```markdown
# Command: <name>
# Description: <description>

## 逻辑 (Workflow)
1. Step-by-step instructions for Claude
2. Tool calls and decision logic
3. User interaction patterns

## 角色设定 (Identity)
Personality and tone guidelines for this command
```

### Hook Definition Format

Hooks follow this structure:
```markdown
# Hook: <name>
# Event: <event-type> (matches "<pattern>")

## 逻辑规则
1. Condition checks
2. Tool invocations
3. Block/allow logic
```

### Event Types

Currently implemented:
- `pre-command`: Intercepts commands before execution (can match patterns like "git commit")

## Notes

- Commands and hooks use markdown format but contain executable logic that Claude interprets
- Hooks should remain silent unless their activation conditions are met
- Commands can define specific personalities/tones for different use cases
