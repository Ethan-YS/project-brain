# systems/

> **这里放什么**：系统设计、架构、技术选型。
>
> **判断标准**：问自己 —— "这份文档是在回答：**怎么设计的？**"

---

## 典型内容

- **架构文档**：记忆系统架构、数据流设计、模块边界
- **技术选型**：为什么选 X 不选 Y（例如 Postgres vs SQLite，React vs Vue）
- **协议 / 接口设计**：API 约定、跨模块通信协议
- **领域模型**：领域特定的抽象
- **红线 / 约束**：系统级不可越过的规则（例如隔离边界）

## 不属于这里

- ❌ 发版流程 → `operations/`
- ❌ 路线图 / 未来计划 → `planning/`
- ❌ 用户反馈 / bug → `feedback/`
- ❌ 当前会话状态 → `brain/STATUS.md`
- ❌ 历史决策理由 → `brain/DECISIONS.md`（DECISIONS 记录**为什么**；systems/ 记录**是什么 + 怎么工作**）

## 文件命名建议

- 大写 + 下划线，例如 `MEMORY_ARCHITECTURE.md` / `AI_PROVIDERS.md`
- 名字应该一眼能看清"什么系统 / 什么主题"
- 避免项目名前缀（`MYPROJECT_MEMORY.md` → `MEMORY_ARCHITECTURE.md`）

## 维护纪律

- 每份文档开头写"本文件回答：xxx"，说清边界
- 大的设计变化 → 同时在 `brain/DECISIONS.md` 追加一条决策
