# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an EASYOPS development assistant plugin for Claude Code. The plugin enhances Claude Code with custom commands and skills to improve the development workflow for EASYOPS company programmers.

## Plugin Structure

```
.
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── commands/
│   └── hello.md              # Hello command definition
├── skills/
│   └── save-notes.md         # Save interaction notes skill
└── doc/
    └── cc-notes.md           # Saved interaction history (auto-generated)
```

## Features

### 1. Hello Command (`/hello`)

**Purpose**: Introduces Claude Code as an EASYOPS company programmer and gathers project requirements.

**Workflow**:
- Self-introduction as EASYOPS professional programmer assistant
- Asks user about programming goals
- Inquires about specific features needed
- Confirms requirements before starting work

**File**: [commands/hello.md](commands/hello.md)

### 2. Save Notes Skill (`/save-notes`)

**Purpose**: Automatically saves all user-Claude Code interactions to project documentation.

**Workflow**:
- Creates `./doc` directory if not exists
- Captures complete conversation history
- Appends interactions to `./doc/cc-notes.md` in Markdown format
- Adds timestamps and session separators
- Notifies user of successful save

**File**: [skills/save-notes.md](skills/save-notes.md)

**Output Location**: [doc/cc-notes.md](doc/cc-notes.md) (auto-generated)

## Plugin Manifest

[.claude-plugin/plugin.json](.claude-plugin/plugin.json) defines:
- `name`: "easyops-dev-assistant"
- `version`: "1.0.0"
- `commands`: Array of command file paths
- `skills`: Array of skill file paths

## Commands and Skills Format

### Command Format (Markdown)
```markdown
# Command: <name>
# Description: <description>

## 逻辑 (Workflow)
Step-by-step instructions for Claude to execute

## 角色设定 (Identity)
Personality and role definition for this command
```

### Skill Format (Markdown)
```markdown
# Skill: <name>
# Description: <description>

## 功能说明
Detailed feature explanation

## 使用方法
How to trigger/use the skill

## 逻辑 (Workflow)
Step-by-step execution logic

## 输出格式
Expected output format (if applicable)

## 角色设定 (Identity)
Role definition for this skill
```

## Development

### Adding New Commands

1. Create a new `.md` file in [commands/](commands/)
2. Follow the command format structure
3. Register in [.claude-plugin/plugin.json](.claude-plugin/plugin.json) under `commands` array

### Adding New Skills

1. Create a new `.md` file in [skills/](skills/)
2. Follow the skill format structure
3. Register in [.claude-plugin/plugin.json](.claude-plugin/plugin.json) under `skills` array

### Testing the Plugin

1. Ensure the plugin is properly registered with Claude Code
2. Test commands: `/hello`, `/save-notes`
3. Verify output files are created in expected locations

## Notes

- Commands define one-time actions with specific workflows
- Skills provide reusable capabilities that can be triggered on-demand
- All interaction histories are stored in [doc/cc-notes.md](doc/cc-notes.md)
- The plugin maintains a professional, EASYOPS-branded experience
