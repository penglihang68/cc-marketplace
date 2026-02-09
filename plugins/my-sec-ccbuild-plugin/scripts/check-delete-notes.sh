#!/bin/bash

# 从 stdin 读取 hook 事件的 JSON
input=$(cat)

# 提取用户的 prompt
prompt=$(echo "$input" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('prompt', ''))")

# 检查是否包含删除或清空 cc-notes.md 的关键词
if echo "$prompt" | grep -iE "(删除|清空|移除|delete|remove|clear|rm).*cc-notes\.md|cc-notes\.md.*(删除|清空|移除|delete|remove|clear|rm)" > /dev/null; then
    # 检测到危险操作，要求用户确认
    echo '{
        "permissionDecision": "ask",
        "permissionDecisionReason": "检测到您的请求涉及删除或清空 cc-notes.md 文件。这个文件包含了所有保存的交互记录，删除后将无法恢复。是否确认执行此操作？"
    }'
else
    # 未检测到危险操作，允许继续
    echo '{
        "permissionDecision": "allow"
    }'
fi
