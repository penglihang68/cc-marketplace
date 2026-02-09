#!/bin/bash

# 从 stdin 读取 hook 事件的 JSON
input=$(cat)

# 提取用户的 prompt
prompt=$(echo "$input" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('prompt', ''))")

# 定义关键词模式（中英文）
# 匹配："能够做什么"、"你能做什么"、"有什么功能"、"建议"、"规划"、"设计"等
keyword_pattern="(能够做什么|你能做什么|有什么功能|有什么能力|你会什么|你可以做什么)"
keyword_pattern="$keyword_pattern|(建议|给.*建议|有什么建议|有啥建议)"
keyword_pattern="$keyword_pattern|(帮.*规划|规划|计划|怎么规划)"
keyword_pattern="$keyword_pattern|(帮.*设计|设计方案|如何设计|怎么设计)"
keyword_pattern="$keyword_pattern|(what can you do|suggestions?|recommend|plan|design)"

# 检查是否包含工作流意图关键词
if echo "$prompt" | grep -iE "$keyword_pattern" > /dev/null; then
    # 检测到工作流意图，指示 Claude 调用 AskUserQuestion
    cat << 'EOF'
{
    "permissionDecision": "allow",
    "message": "INSTRUCTION: User is asking for guidance on what you can do or requesting suggestions/planning/design help. You MUST immediately call the AskUserQuestion tool with the following configuration:

Question: \"您想要从哪个方面开始？我可以帮助您进行项目设计、技术学习或功能开发。\"
Header: \"工作方式\"
Options:
1. Label: \"我要开始设计\", Description: \"帮助您进行架构设计、技术方案规划、系统设计等工作\"
2. Label: \"我要开始学习\", Description: \"帮助您学习新技术、理解代码、掌握开发工具和最佳实践\"
3. Label: \"我要开始开发\", Description: \"直接进入编码开发，实现具体功能、修复bug、优化代码\"

After user selects an option, provide tailored assistance based on their choice."
}
EOF
else
    # 未检测到工作流意图关键词，允许继续
    echo '{"permissionDecision": "allow"}'
fi
