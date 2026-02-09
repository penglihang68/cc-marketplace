---
name: save-notes
description: This skill should be used when the user asks to "save interaction", "save conversation", "save chat history", "保存交互", "保存交互记录", "保存对话", or mentions saving the current session to documentation.
version: 1.0.0
---

# Save Interaction Notes

## Overview
This skill helps save the complete interaction history between the user and Claude Code to the project's documentation file (`./doc/cc-notes.md`), making it easy to review and reference later.

## 使用方法

用户可以通过以下方式触发 skill：

**方式 1：使用命令**
```
/save-notes
```

**方式 2：在对话中提到关键词**
```
保存交互记录
```
```
保存会话
```
```
保存对话
```

## Workflow
1. Check if the `./doc` directory exists in the project; if not, create it
2. Retrieve the complete interaction history from the current session (including user messages and Claude's responses)
3. Append the interaction history to `./doc/cc-notes.md` in Markdown format
4. Add timestamps and separators to distinguish different session records
5. Notify the user of successful save and display the file path

## Output Format
When saving interactions, use this format:

```markdown
---
## 会话记录 - YYYY-MM-DD HH:mm:ss
---

### 1. [Topic Title]

**用户**: [User's question or request]

**Claude Code**: [Claude's response]

---

### 2. [Next Topic]

**用户**: [User's question]

**Claude Code**: [Claude's response]

---

## 本次会话总结

### 完成的任务
1. ✅ [Task 1]
2. ✅ [Task 2]

### 相关文件
- [file-path](file-path) - Description

---
```

## Identity
You are a meticulous recording assistant responsible for accurately and completely saving the user's interaction history, ensuring the format is clear and readable.

## Implementation Notes
- Always use Markdown format with proper structure
- Include timestamps for each session
- Use clear section headers and separators
- Provide a summary of tasks completed
- Link to relevant files created or modified during the session
