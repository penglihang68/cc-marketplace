# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an EASYOPS development assistant plugin for Claude Code. The plugin enhances Claude Code with custom commands and skills to improve the development workflow for EASYOPS company programmers.

## Plugin Structure

```
.
├── .claude/
│   └── agents/
│       └── sales-assistant.md    # Sales agent for project management
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── commands/
│   └── hello.md              # Hello command definition
├── skills/
│   ├── save-notes/           # Save interaction notes skill
│   │   └── SKILL.md
│   ├── study-javis/          # Javis sales learning assistant
│   │   └── SKILL.md
│   ├── manage-projects/      # Project management skill
│   │   └── SKILL.md
│   └── xhs-manager/          # Xiaohongshu (小红书) management skill
│       └── SKILL.md
├── hooks/
│   └── hooks.json            # Hook configurations
├── scripts/
│   ├── detect-workflow-intent.sh   # Auto-detect workflow intent
│   └── check-delete-notes.sh       # Protect cc-notes.md deletion
└── doc/
    ├── cc-notes.md           # Saved interaction history (auto-generated)
    └── project-list.md       # Project list managed by manage-projects skill
```

## Features

### 1. Intelligent Workflow Selector (Auto-triggered)

**Purpose**: Automatically detects when users are asking for guidance, suggestions, planning, or design help, and presents workflow options via AskUserQuestion dialog.

**Trigger Keywords** (Chinese and English):
- Asking about capabilities: "能够做什么", "你能做什么", "有什么功能", "what can you do"
- Requesting suggestions: "建议", "给我建议", "有什么建议", "suggestions", "recommend"
- Planning help: "帮我规划", "规划", "计划", "plan"
- Design help: "帮我设计", "设计方案", "如何设计", "design"

**Workflow**:
1. User inputs a prompt containing trigger keywords
2. UserPromptSubmit hook automatically detects the intent
3. Claude presents 3 workflow options via AskUserQuestion:
   - **我要开始设计** - Architecture design, technical planning, system design
   - **我要开始学习** - Learning new tech, understanding code, mastering tools
   - **我要开始开发** - Direct coding, feature implementation, bug fixes
4. User selects preferred workflow
5. Claude provides tailored assistance based on selection

**Implementation**:
- Hook script: [scripts/detect-workflow-intent.sh](scripts/detect-workflow-intent.sh)
- Hook config: [hooks/hooks.json](hooks/hooks.json) (UserPromptSubmit hook)

### 2. Hello Command (`/hello`)

**Purpose**: Introduces Claude Code as an EASYOPS company programmer and gathers project requirements.

**Workflow**:
- Self-introduction as EASYOPS professional programmer assistant
- Asks user about programming goals
- Inquires about specific features needed
- Confirms requirements before starting work

**File**: [commands/hello.md](commands/hello.md)

### 3. Save Notes Skill (`/save-notes`)

**Purpose**: Automatically saves all user-Claude Code interactions to project documentation.

**Workflow**:
- Creates `./doc` directory if not exists
- Captures complete conversation history
- Appends interactions to `./doc/cc-notes.md` in Markdown format
- Adds timestamps and session separators
- Notifies user of successful save

**File**: [skills/save-notes.md](skills/save-notes.md)

**Output Location**: [doc/cc-notes.md](doc/cc-notes.md) (auto-generated)

### 4. Study Javis Skill (`/study-javis`)

**Purpose**: Intelligent Javis sales learning assistant that helps team members learn how to use Javis system for sales work.

**Trigger Keywords**:
- "学习应用AI"
- "学习javis" or "学习 Javis"
- "学习如何进行销售工作"
- "学习如何开展销售工作"
- "如何使用 Javis"

**Workflow**:
1. **Step 1**: Ask user identity via AskUserQuestion
   - Options: 研发 (Developer) / 售前 (Pre-sales) / 销售 (Sales)
2. **Step 2**: Ask user intent via AskUserQuestion
   - Options: 创建新的销售商机 (Create new opportunity) / 查询现有项目 (Query existing project)
3. **Step 3**: Ask project name via AskUserQuestion
   - User inputs project name through "Other" option
4. **Step 4**: Generate personalized guidance (approx. 200 words)
   - Combines: [User Identity] + [User Intent] + [Project Name]
   - Provides role-specific operation guidance
   - Includes best practices and key considerations

**File**: [skills/study-javis/SKILL.md](skills/study-javis/SKILL.md)

### 5. Manage Projects Skill (`/manage-projects`)

**Purpose**: Intelligent project management skill that helps users create and manage EASYOPS project list.

**Trigger Keywords**:
- "创建新项目"、"新建项目"、"添加项目"
- "录入项目"、"记录新项目"
- "create project"、"add project"

**Workflow**:
1. **Step 1**: Ask project name via AskUserQuestion
   - User inputs project name through "Other" option
2. **Step 2**: Read existing project list from `./doc/project-list.md`
   - Check if project already exists
   - If exists, notify user and show existing information
3. **Step 3**: If project doesn't exist, add new project
   - Auto-increment project number
   - Generate project entry: `序号. 项目名 创建时间`
   - Append to project list file
4. **Step 4**: Confirm and display updated project list
   - Show success message with project details
   - Display complete project list

**Project Entry Format**:
```
序号. 项目名 创建时间
```

**Example**:
```
1. 电商平台性能优化项目 2024-01-20
2. 智能客服系统开发 2024-01-28
3. 企业内部知识库建设 2024-02-05
```

**File**: [skills/manage-projects/SKILL.md](skills/manage-projects/SKILL.md)

**Data File**: [doc/project-list.md](doc/project-list.md)

### 6. XHS Manager Skill (`/xhs-manager`)

**Purpose**: Comprehensive Xiaohongshu (小红书) management skill that integrates all xiaohongshu-mcp tools for content operations, publishing, and user interactions.

**Trigger Keywords**:
- "小红书"、"xhs"、"xiaohongshu"
- "小红书登录"、"小红书发布"、"小红书查询"
- "发布小红书"、"查看小红书"、"小红书互动"

**Core Features**:
1. **Authentication Module**
   - Check login status
   - Get login QR code
   - Logout (delete cookies)

2. **Content Query Module**
   - View homepage feeds list
   - Search Xiaohongshu content
   - View note details (with comments)
   - View user profile

3. **Content Publishing Module**
   - Publish image posts
   - Publish video posts
   - Scheduled publishing support

4. **Interaction Module**
   - Like/unlike posts
   - Favorite/unfavorite posts
   - Post comments
   - Reply to comments

**Workflow**:
1. **Step 1**: Auto-check login status
   - If not logged in: Display QR code for login
   - If logged in: Proceed to next step
2. **Step 2**: Ask user intent via AskUserQuestion
   - 查询内容 (Query content)
   - 发布内容 (Publish content)
   - 互动操作 (Interaction operations)
   - 账号管理 (Account management)
3. **Step 3**: Execute specific operation based on user selection
   - Query: List feeds / Search / View details / View profile
   - Publish: Image post / Video post
   - Interaction: Like / Favorite / Comment / Reply
   - Account: Check status / Logout / Re-login
4. **Step 4**: Provide results and ask for further operations

**Key Parameters**:
- `feed_id`: Note ID (from feeds list or search results)
- `xsec_token`: Access token (from xsecToken field in feeds)
- `user_id`: User ID (for profile viewing or comment replies)
- `comment_id`: Comment ID (for replying to comments)

**MCP Tools Integration**:
- Uses all 13 xiaohongshu-mcp tools
- MCP Server: `http://localhost:18060/mcp`
- Full tool list: check_login_status, get_login_qrcode, list_feeds, search_feeds, get_feed_detail, publish_content, publish_with_video, like_feed, favorite_feed, post_comment_to_feed, reply_comment_in_feed, user_profile, delete_cookies

**File**: [skills/xhs-manager/SKILL.md](skills/xhs-manager/SKILL.md)

### 7. Sales Project Lister Agent (Auto-triggered for Sales Personnel)

**Purpose**: Comprehensive sales assistant that provides project listing, project creation, and Javis learning support for sales personnel.

**Trigger Conditions**:
- User is identified as sales personnel (销售人员)
- User asks about projects: "有哪些项目"、"项目清单"
- User wants to create projects or learn Javis

**Workflow**:
1. **Step 1**: Automatically read and display project list from `./doc/project-list.md`
   - Shows project overview with total count
   - Lists all projects with creation dates
2. **Step 2**: Present sales support options via AskUserQuestion
   - 查看项目详情 (View project details)
   - 创建新项目 (Create new project)
   - 学习 Javis 使用 (Learn Javis usage)
   - 不需要其他操作 (No additional action)
3. **Step 3**: Execute based on user selection
   - If "创建新项目": Call manage-projects skill
   - If "学习 Javis 使用": Call study-javis skill
     - If user intent in study-javis is "创建新的销售商机": Offer to call manage-projects to add project to list
   - If "查看项目详情": Display detailed project information
   - If "不需要其他操作": End gracefully

**Features**:
- Seamless skill orchestration (manage-projects + study-javis)
- Context preservation between skill calls
- Intelligent workflow routing based on user needs
- Professional sales-focused presentation

**File**: [agents/sales-assistant.md](agents/sales-assistant.md)

**Related Skills**:
- [manage-projects](#5-manage-projects-skill-manage-projects)
- [study-javis](#4-study-javis-skill-study-javis)
- [xhs-manager](#6-xhs-manager-skill-xhs-manager)

**Data File**: [doc/project-list.md](doc/project-list.md)

## Plugin Manifest

[.claude-plugin/plugin.json](.claude-plugin/plugin.json) defines:
- `name`: "easyops-dev-assistant"
- `version`: "1.0.8"
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

### Adding New Hooks

1. Create a new shell script in [scripts/](scripts/)
2. Make the script executable: `chmod +x scripts/your-script.sh`
3. Script should:
   - Read JSON input from stdin
   - Extract `prompt` or other fields as needed
   - Return JSON with `permissionDecision` and optional `message`
4. Register in [hooks/hooks.json](hooks/hooks.json) under appropriate hook type

**Available Hook Types**:
- `SessionStart`: Triggered when session starts or after `/clear`
- `UserPromptSubmit`: Triggered when user submits a prompt
- `PreToolUse`: Triggered before Claude uses a tool

### Adding New Commands

1. Create a new `.md` file in [commands/](commands/)
2. Follow the command format structure
3. Register in [.claude-plugin/plugin.json](.claude-plugin/plugin.json) under `commands` array

### Adding New Skills

1. Create a new `.md` file in [skills/](skills/)
2. Follow the skill format structure
3. Register in [.claude-plugin/plugin.json](.claude-plugin/plugin.json) under `skills` array

### Adding New Agents

1. Create a new `.md` file in [.claude/agents/](.claude/agents/)
2. Add YAML frontmatter with agent metadata:
   ```yaml
   ---
   name: agent-name
   description: "Agent description with usage examples"
   model: sonnet  # or haiku, opus
   color: red     # optional UI color
   ---
   ```
3. Define agent responsibilities, workflow, and behavior
4. **No registration needed** - Agents in `.claude/agents/` are automatically discovered

**Agent Format** (Markdown with YAML frontmatter):
```markdown
---
name: agent-name
description: "Description"
model: sonnet
---

You are [Agent Identity]...

## Your Core Responsibilities
...

## Operational Workflow
...
```

**Note**: Unlike commands and skills, agents do NOT need to be registered in `plugin.json`. Simply place the `.md` file in `.claude/agents/` directory.

### Testing the Plugin

1. Ensure the plugin is properly registered with Claude Code
2. Test commands: `/hello`
3. Test skills: `/save-notes`, `/study-javis`, `/manage-projects`
4. Verify output files are created in expected locations

## Notes

- Commands define one-time actions with specific workflows
- Skills provide reusable capabilities that can be triggered on-demand
- Agents orchestrate complex workflows and can call multiple skills (placed in `.claude/agents/`, no registration needed)
- All interaction histories are stored in [doc/cc-notes.md](doc/cc-notes.md)
- Project information is managed in [doc/project-list.md](doc/project-list.md)
- The plugin maintains a professional, EASYOPS-branded experience
