# feedback/

> **这里放什么**：用户反馈、bug 追踪、triage 流程。
>
> **判断标准**：问自己 —— "这份文档是在回答：**现实是什么 / 用户在告诉我们什么？**"

---

## 典型内容（常见三件套）

| 文件 | 用途 |
|---|---|
| `FEEDBACK_INBOX.md` | **原始**反馈收件箱，倒序，保留用户的真实表达 |
| `BUG_TRACKER.md` | 从 inbox 筛出的**可执行 bug**，按 ID 跟踪状态 |
| `FEEDBACK_TEMPLATES.md` | 反馈收集模板 + 回复模板 + triage 流程 + 严重度评级 |

## 不属于这里

- ❌ 系统设计 → `systems/`（bug 的**根因分析**可能反哺 systems 文档，但 bug 条目本身在这里）
- ❌ 发版流程 → `operations/`
- ❌ 功能规划 → `planning/`
- ❌ 修复后的**决策理由** → `brain/DECISIONS.md`（如果修复涉及不可逆的设计变化）

## 三个文件的分工

- **INBOX = 原始**：**保留用户原话**。不要处理、合并、缩写。它是"数据源"，不是"待办清单"。
- **TRACKER = 可执行**：从 INBOX 筛出要修的，分配 BUG-XXX ID，追踪状态。
- **TEMPLATES = 流程**：给用户用的模板 + 给我们自己用的流程和评级。

**交叉引用规则**：每个 bug 有自己的 ID（BUG-XXX）。INBOX 条目引用 bug 时用 ID（"已立 BUG-008"）；TRACKER 条目也可以引用原始反馈的日期。双向引用让"谁先报的"可追溯。

## 隐私规则（读这条）

FEEDBACK_INBOX 可能收到真实用户信息。**不要提交进 git**：
- ❌ 真实姓名 / 邮箱 / 电话 / 验证过的社交账号
- ❌ 激活码 / 支付凭证 / 订单号
- ❌ 含有用户 PII 的截图

**可以提交**：
- ✅ 用户化名 / handle
- ✅ 公开的产品反馈内容
- ✅ 系统信息（OS 版本、App 版本）

## 迁移阈值

如果 bug 数**超过约 50 条，考虑迁移到 GitHub Issues**。低于这个数，markdown 形式足够轻 —— 而且避免把用户反馈 PII 推进公开仓库。

## 状态流转

建议的 bug 状态：
```
Inbox → Triaging → In Progress → Resolved → Released
                                    │
                                    └→ Won't Fix / Deferred
```

每次发版前，清理"In Progress"或标"deferred to next version"。发版后，把"Resolved"挪到"Released"。
