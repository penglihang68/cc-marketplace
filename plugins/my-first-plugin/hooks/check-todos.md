# Hook: Pre-Command Check
# Event: pre-command (matches "git commit")

## 逻辑规则
1. 如果用户输入的命令包含 "git commit":
   - **立即行动**：调用 `grep` 工具在当前暂存区（staged changes）搜索 "TODO" 或 "FIXME"。
   - **判断结果**：
     - 如果搜到了，**拦截操作**。告诉用户："等一下！我发现了未完成的任务，确定要现在提交吗？" 并列出具体的行号。
     - 如果没搜到，**静默允许**，让 commit 继续执行。

2. 对于其他命令，保持静默，不要干扰用户。
