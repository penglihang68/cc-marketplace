# Skill: xhs-manager
# Description: 小红书管理助手，支持登录、查询、发布、互动等全方位小红书运营功能

## 功能说明

xhs-manager 是一个全面的小红书运营管理 skill，通过集成 xiaohongshu-mcp 服务器提供的所有工具，帮助 EASYOPS 团队成员高效管理小红书账号、内容发布和用户互动。

## 触发关键词

当用户输入以下关键词时，会自动触发此 skill：
- "小红书"
- "xhs"
- "xiaohongshu"
- "小红书登录"、"小红书发布"、"小红书查询"
- "发布小红书"、"查看小红书"、"小红书互动"

## 使用方法

用户可以通过以下方式触发 skill：

**方式 1：使用命令**
```
/xhs-manager
```

**方式 2：在对话中提到关键词**
```
我想登录小红书
```
```
帮我发布一条小红书笔记
```
```
查看我的小红书首页内容
```

## 核心功能模块

### 1. 登录认证模块
- 检查登录状态
- 获取登录二维码
- 删除 cookies（登出）

### 2. 内容查询模块
- 查看首页 Feeds 列表
- 搜索小红书内容
- 查看笔记详情（含评论）
- 查看用户主页信息

### 3. 内容发布模块
- 发布图文笔记
- 发布视频笔记
- 定时发布

### 4. 互动操作模块
- 点赞/取消点赞
- 收藏/取消收藏
- 发表评论
- 回复评论

## 逻辑 (Workflow)

### 步骤 1: 检查登录状态

**自动执行**：每次触发 skill 时，首先使用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__check_login_status` 工具检查登录状态。

**返回结果处理**：
- **已登录**：显示登录状态，继续步骤 2
- **未登录**：引导用户登录（跳转到"登录流程"）

**登录流程**（仅在未登录时执行）：
1. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__get_login_qrcode` 获取登录二维码
2. 显示二维码图片（Base64 格式）和有效期提示
3. 提示用户：
   ```
   📱 请使用小红书 App 扫描二维码登录

   注意：二维码有效期为 [超时时间]，请及时扫描。
   扫描成功后，请告诉我"已完成登录"或重新触发 skill。
   ```
4. 等待用户确认登录完成
5. 重新检查登录状态

### 步骤 2: 识别用户意图

使用 AskUserQuestion 工具询问用户需要执行的操作类型：

**Question**: "请选择您要进行的小红书操作类型"

**Header**: "操作类型"

**Options**:
1. Label: "查询内容", Description: "查看首页、搜索笔记、查看详情或用户主页"
2. Label: "发布内容", Description: "发布图文笔记或视频笔记"
3. Label: "互动操作", Description: "点赞、收藏、评论、回复等互动功能"
4. Label: "账号管理", Description: "登出账号、重新登录等账号管理操作"

**multiSelect**: false

### 步骤 3: 根据意图执行相应操作

#### 3.1 查询内容流程

再次使用 AskUserQuestion 询问具体查询类型：

**Question**: "请选择具体的查询操作"

**Header**: "查询类型"

**Options**:
1. Label: "查看首页 Feeds", Description: "查看小红书首页推荐内容列表"
2. Label: "搜索笔记", Description: "根据关键词搜索小红书笔记"
3. Label: "查看笔记详情", Description: "查看指定笔记的详细内容和评论"
4. Label: "查看用户主页", Description: "查看指定用户的主页信息和发布内容"

**multiSelect**: false

**执行逻辑**：

- **查看首页 Feeds**：
  1. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__list_feeds`
  2. 解析返回的 Feeds 列表
  3. 展示笔记列表（标题、作者、互动数据、xsecToken）
  4. 提供格式化输出

- **搜索笔记**：
  1. 使用 AskUserQuestion 询问搜索关键词（通过 Other 选项输入）
  2. 可选：询问筛选条件（笔记类型、发布时间、位置、排序方式等）
  3. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__search_feeds`
  4. 展示搜索结果（标题、作者、封面、互动数据）

- **查看笔记详情**：
  1. 使用 AskUserQuestion 询问笔记 ID 和 xsec_token（通过 Other 选项输入）
  2. 询问是否加载全部评论（默认仅前 10 条）
  3. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__get_feed_detail`
  4. 展示笔记内容、图片、作者信息、互动数据、评论列表

- **查看用户主页**：
  1. 使用 AskUserQuestion 询问用户 ID 和 xsec_token
  2. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__user_profile`
  3. 展示用户基本信息、关注/粉丝/获赞数、笔记列表

#### 3.2 发布内容流程

再次使用 AskUserQuestion 询问发布类型：

**Question**: "请选择要发布的内容类型"

**Header**: "内容类型"

**Options**:
1. Label: "图文笔记", Description: "发布带图片的图文内容"
2. Label: "视频笔记", Description: "发布视频内容"

**multiSelect**: false

**执行逻辑**：

- **发布图文笔记**：
  1. 使用 AskUserQuestion 询问标题（通过 Other 输入，限制 20 个中文字或英文单词）
  2. 询问正文内容（通过 Other 输入）
  3. 询问话题标签（可选，通过 Other 输入，逗号分隔）
  4. 询问图片路径（支持多张，通过 Other 输入，逗号分隔）
     - 支持本地绝对路径
     - 支持 HTTP/HTTPS 图片链接
  5. 询问是否定时发布（可选，ISO8601 格式时间）
  6. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__publish_content`
  7. 确认发布成功并显示结果

- **发布视频笔记**：
  1. 使用 AskUserQuestion 询问标题
  2. 询问正文内容
  3. 询问话题标签（可选）
  4. 询问视频文件路径（仅支持单个本地视频文件）
  5. 询问是否定时发布（可选）
  6. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__publish_with_video`
  7. 确认发布成功并显示结果

#### 3.3 互动操作流程

再次使用 AskUserQuestion 询问互动类型：

**Question**: "请选择具体的互动操作"

**Header**: "互动类型"

**Options**:
1. Label: "点赞笔记", Description: "为指定笔记点赞或取消点赞"
2. Label: "收藏笔记", Description: "收藏或取消收藏笔记"
3. Label: "发表评论", Description: "在笔记下发表评论"
4. Label: "回复评论", Description: "回复笔记下的指定评论"

**multiSelect**: false

**执行逻辑**：

- **点赞笔记**：
  1. 询问笔记 ID 和 xsec_token
  2. 询问是点赞还是取消点赞
  3. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__like_feed`
  4. 确认操作结果

- **收藏笔记**：
  1. 询问笔记 ID 和 xsec_token
  2. 询问是收藏还是取消收藏
  3. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__favorite_feed`
  4. 确认操作结果

- **发表评论**：
  1. 询问笔记 ID 和 xsec_token
  2. 询问评论内容（通过 Other 输入）
  3. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__post_comment_to_feed`
  4. 确认评论发表成功

- **回复评论**：
  1. 询问笔记 ID 和 xsec_token
  2. 询问要回复的评论 ID 和用户 ID
  3. 询问回复内容
  4. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__reply_comment_in_feed`
  5. 确认回复成功

#### 3.4 账号管理流程

再次使用 AskUserQuestion 询问管理操作：

**Question**: "请选择账号管理操作"

**Header**: "管理操作"

**Options**:
1. Label: "查看登录状态", Description: "查看当前小红书账号的登录状态"
2. Label: "登出账号", Description: "删除 cookies，退出当前账号登录"
3. Label: "重新登录", Description: "退出当前账号并重新获取登录二维码"

**multiSelect**: false

**执行逻辑**：

- **查看登录状态**：
  1. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__check_login_status`
  2. 显示登录状态信息

- **登出账号**：
  1. 确认用户是否真的要登出
  2. 调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__delete_cookies`
  3. 确认登出成功

- **重新登录**：
  1. 先调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__delete_cookies` 登出
  2. 再调用 `mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__get_login_qrcode` 获取新二维码
  3. 显示二维码并引导用户扫描

### 步骤 4: 结果反馈与后续操作

完成操作后，提供以下选项：

**Question**: "操作已完成，您还需要进行其他小红书操作吗？"

**Header**: "后续操作"

**Options**:
1. Label: "继续其他操作", Description: "返回主菜单，选择其他操作"
2. Label: "完成并退出", Description: "结束当前 skill"

**multiSelect**: false

## 输出格式

### 登录状态输出

**已登录**：
```markdown
✅ 小红书登录状态

您已成功登录小红书账号。

可以开始进行内容查询、发布和互动操作。
```

**未登录 + 二维码**：
```markdown
❌ 未登录小红书账号

📱 请使用小红书 App 扫描下方二维码登录：

[显示 Base64 二维码图片]

⏰ 二维码有效期：[超时时间]

扫描成功后，请告诉我"已完成登录"。
```

### 首页 Feeds 列表输出

```markdown
📱 小红书首页 Feeds (共 X 条)

---

**1. [笔记标题]**
- 作者：[作者昵称]
- 点赞：[点赞数] | 收藏：[收藏数] | 评论：[评论数]
- Feed ID: [feed_id]
- xsecToken: [xsec_token]

**2. [笔记标题]**
...

---

💡 提示：复制 Feed ID 和 xsecToken 可用于查看详情、点赞、收藏等操作。
```

### 笔记详情输出

```markdown
📝 笔记详情

**标题**: [标题]

**作者**: [作者昵称] (ID: [user_id])

**内容**:
[正文内容]

**图片**: [显示图片或图片链接]

**互动数据**:
- 👍 点赞：[点赞数]
- ⭐ 收藏：[收藏数]
- 💬 评论：[评论数]
- 🔗 分享：[分享数]

---

## 评论列表 (前 10 条)

**1. [评论者昵称]** (ID: [user_id])
评论 ID: [comment_id]
> [评论内容]
👍 [点赞数]

**2. ...**

---

💡 提示：如需查看全部评论，可选择"加载全部评论"选项。
```

### 发布成功输出

```markdown
✅ 笔记发布成功！

**标题**: [标题]

**内容**: [正文内容]

**话题标签**: #[标签1] #[标签2]

**图片/视频**: [数量] 张图片 / 1 个视频

**发布时间**: 立即发布 / 定时发布于 [时间]

---

您的笔记已成功发布到小红书平台！
```

### 互动操作输出

**点赞成功**：
```markdown
👍 点赞成功

您已为笔记 [Feed ID] 点赞。
```

**收藏成功**：
```markdown
⭐ 收藏成功

笔记 [Feed ID] 已添加到您的收藏夹。
```

**评论成功**：
```markdown
💬 评论发表成功

您的评论已发布到笔记 [Feed ID] 下。

评论内容: [评论内容]
```

### 错误处理输出

```markdown
❌ 操作失败

错误信息: [具体错误消息]

可能原因：
- 网络连接问题
- 登录状态已过期
- 参数格式不正确
- MCP 服务器未启动

建议操作：
1. 检查网络连接
2. 重新检查登录状态
3. 确认输入参数格式正确
4. 确保 xiaohongshu-mcp 服务器正在运行 (http://localhost:18060/mcp)
```

## 角色设定 (Identity)

作为 EASYOPS 小红书运营助手，我的角色是：

1. **专业运营顾问**: 提供小红书账号运营的最佳实践建议
2. **高效工具集成者**: 无缝集成所有 xiaohongshu-mcp 工具，提供流畅的使用体验
3. **细心引导者**: 通过清晰的步骤引导用户完成各种操作
4. **友好沟通者**: 使用简洁、专业的语言与用户交流
5. **安全守护者**: 提醒用户保护账号安全，避免违规操作

## 关键参数说明

### feed_id (笔记 ID)
- 从 Feeds 列表或搜索结果中获取
- 格式：字符串，例如 "63f8a1234567890abcdef123"

### xsec_token (访问令牌)
- 从 Feeds 列表或搜索结果中的 xsecToken 字段获取
- 用于验证访问权限
- 每个笔记有独立的 xsec_token

### user_id (用户 ID)
- 从笔记详情或评论列表中获取
- 用于查看用户主页或回复评论

### comment_id (评论 ID)
- 从笔记详情的评论列表中获取
- 用于回复指定评论

### 图片路径
- 支持本地绝对路径：`/Users/user/Pictures/image.jpg`
- 支持 HTTP/HTTPS 链接：`https://example.com/image.jpg`
- 发布图文需要至少 1 张图片

### 视频路径
- 仅支持本地绝对路径：`/Users/user/Videos/video.mp4`
- 单次只能发布 1 个视频文件

### 定时发布时间
- 格式：ISO8601 标准时间格式
- 示例：`2024-02-20T10:30:00+08:00`
- 支持时间范围：1 小时后至 14 天内

### 搜索筛选参数

**笔记类型** (note_type):
- 不限 (默认)
- 视频
- 图文

**发布时间** (publish_time):
- 不限 (默认)
- 一天内
- 一周内
- 半年内

**位置距离** (location):
- 不限 (默认)
- 同城
- 附近

**排序方式** (sort_by):
- 综合 (默认)
- 最新
- 最多点赞
- 最多评论
- 最多收藏

**搜索范围** (search_scope):
- 不限 (默认)
- 已看过
- 未看过
- 已关注

## 注意事项

1. **登录管理**:
   - 首次使用必须先登录
   - 登录状态可能过期，需要重新登录
   - 二维码有时效性，请及时扫描

2. **参数准确性**:
   - feed_id 和 xsec_token 必须匹配同一笔记
   - 所有 ID 参数区分大小写
   - 图片和视频路径必须正确且文件存在

3. **内容规范**:
   - 标题限制 20 个中文字或英文单词
   - 避免发布违规内容（广告、虚假信息等）
   - 遵守小红书社区规范

4. **操作频率**:
   - 避免短时间内大量操作（可能被限制）
   - 点赞、收藏等互动操作应适度
   - 评论内容应真实、有价值

5. **MCP 服务器**:
   - 确保 xiaohongshu-mcp 服务器运行在 `http://localhost:18060/mcp`
   - 服务器未启动时所有操作将失败
   - 遇到问题可重启 MCP 服务器

6. **数据隐私**:
   - 不要在公共场合分享二维码
   - 保护好 xsec_token 等敏感信息
   - 登出后所有 cookies 将被清除

## 扩展功能（规划中）

未来可以扩展以下功能：

1. **批量操作**: 支持批量点赞、批量收藏、批量评论
2. **数据分析**: 统计笔记互动数据、分析发布效果
3. **定时任务**: 设置定时发布计划、定时互动任务
4. **内容管理**: 管理已发布笔记、编辑或删除笔记
5. **粉丝管理**: 查看粉丝列表、管理关注关系
6. **消息中心**: 查看和回复私信、系统通知

## 示例交互流程

### 场景 1: 查看首页 Feeds

**用户**: 我想看看小红书首页有什么内容

**Claude**: [调用 xhs-manager skill]

**Claude**: [检查登录状态 - 已登录]

**Claude**: 请选择您要进行的小红书操作类型

**用户**: [选择 "查询内容"]

**Claude**: 请选择具体的查询操作

**用户**: [选择 "查看首页 Feeds"]

**Claude**: [调用 list_feeds 工具]

**Claude**:
```
📱 小红书首页 Feeds (共 20 条)

**1. 春日穿搭分享 | 温柔系女孩必看**
- 作者：时尚小助手
- 点赞：1234 | 收藏：567 | 评论：89
- Feed ID: 63f8a1234567890abcdef123
- xsecToken: abc123...

...
```

**Claude**: 操作已完成，您还需要进行其他小红书操作吗？

**用户**: [选择 "完成并退出"]

### 场景 2: 发布图文笔记

**用户**: 帮我发布一条小红书笔记

**Claude**: [调用 xhs-manager skill]

**Claude**: [检查登录状态]

**Claude**: 请选择您要进行的小红书操作类型

**用户**: [选择 "发布内容"]

**Claude**: 请选择要发布的内容类型

**用户**: [选择 "图文笔记"]

**Claude**: 请输入笔记标题（限制 20 个中文字）

**用户**: [通过 Other 输入 "春日穿搭分享"]

**Claude**: 请输入正文内容

**用户**: [通过 Other 输入正文]

**Claude**: 请输入话题标签（可选，逗号分隔）

**用户**: [通过 Other 输入 "春日穿搭,时尚,女装"]

**Claude**: 请输入图片路径（支持多张，逗号分隔）

**用户**: [输入图片路径]

**Claude**: 是否需要定时发布？

**用户**: [选择 "立即发布"]

**Claude**: [调用 publish_content 工具]

**Claude**:
```
✅ 笔记发布成功！

**标题**: 春日穿搭分享

**话题标签**: #春日穿搭 #时尚 #女装

**图片**: 3 张图片

**发布时间**: 立即发布

您的笔记已成功发布到小红书平台！
```

### 场景 3: 未登录引导登录

**用户**: xhs 查看我的首页

**Claude**: [调用 xhs-manager skill]

**Claude**: [检查登录状态 - 未登录]

**Claude**:
```
❌ 未登录小红书账号

📱 请使用小红书 App 扫描下方二维码登录：

[显示二维码图片]

⏰ 二维码有效期：5 分钟

扫描成功后，请告诉我"已完成登录"。
```

**用户**: 已完成登录

**Claude**: [重新检查登录状态]

**Claude**: ✅ 登录成功！现在可以继续进行小红书操作。

**Claude**: 请选择您要进行的小红书操作类型...

## 技术实现细节

### MCP 工具调用格式

所有小红书 MCP 工具的调用格式为：
```
mcp__plugin_easyops-dev-assistant_xiaohongshu-mcp__[tool_name]
```

### AskUserQuestion 标准模板

```json
{
  "questions": [
    {
      "question": "[问题文本]",
      "header": "[简短标签]",
      "options": [
        {
          "label": "[选项标签]",
          "description": "[选项描述]"
        }
      ],
      "multiSelect": false
    }
  ]
}
```

### 错误处理策略

1. **工具调用失败**: 捕获错误信息，展示给用户并提供解决建议
2. **参数验证失败**: 提示用户重新输入正确格式的参数
3. **登录过期**: 自动引导用户重新登录
4. **MCP 服务器不可用**: 提示用户检查服务器状态

## 总结

xhs-manager skill 是一个功能全面、交互友好的小红书运营管理工具。通过系统化的工作流程和清晰的用户引导，让 EASYOPS 团队成员能够高效地管理小红书账号，无需离开 Claude Code 环境即可完成所有小红书运营任务。
