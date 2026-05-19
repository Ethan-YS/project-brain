# brain/

这个文件夹装的是**关于这个项目本身的所有东西** —— 给未来的会话、新窗口、新的协作者快速接续项目。

## 接续层（每次会话必读）

直接放在 `brain/` 下的 5 份核心文件：

| 文件 | 回答什么 | 时间尺度 |
|---|---|---|
| `PROJECT.md` | 这是什么项目？为什么存在？**刻意不做什么？** | 几乎不变 |
| `MAP.md` | 项目长什么样？什么东西去哪找？ | 随结构演进 |
| `STATUS.md` | 现在做到哪？下一步？被什么挡住了？ | 瞬时状态，可覆盖 |
| `DECISIONS.md` | 为什么做了 X？为什么没做 Y？ | 只追加 |
| `HANDOFF.md` | 上个会话切窗口时还热乎的想法 | 瞬时，每次切窗口被覆盖 |

`handoffs/` —— 历史 HANDOFF 归档，按 `YYYY-MM-DD-HHMM.md` 命名。

## 专题层（按需读）

`topics/` —— 4 个分类，每份业务 / 技术文档按"**回答什么问题**"放进对应类，不是按业务模块。

- `systems/` —— "这是怎么设计的？"
- `operations/` —— "怎么运维 / 每次发版要做什么？"
- `planning/` —— "我们要建什么 / 怎么规划？"
- `feedback/` —— "现实是什么 / 用户在告诉我们什么？"

判断标准见 `topics/README.md`。

## 新会话怎么用这个文件夹

1. 先读 `MAP.md` —— 理解结构 + 知道文档去哪找
2. 再读 `STATUS.md` —— 知道当前进度
3. 如果存在 `HANDOFF.md`，读它 —— 拿到上个会话"还热乎"的想法
4. 按需读 `PROJECT.md` / `DECISIONS.md` —— 理解范围 / 追溯原因
5. 用 `MAP.md` 第 5 节的 topic 索引按需进入 `topics/` 内容

## 维护纪律

- **接续层 5 份文件不互相重叠**：任何一条信息应该清楚地属于其中一份。混用会导致退化。
- **PROJECT 不该频繁变**：如果在变，说明项目定位在漂移 —— 把漂移这件事本身记到 DECISIONS。
- **STATUS 软上限 80 行**：超过就把有价值的内容沉淀到 MAP（结构变化）或 DECISIONS（理由），再覆盖。
- **DECISIONS 只追加**：不修改历史。即使要推翻，也是新写一条覆盖旧的，不改旧条目。
- **HANDOFF 每次切窗口被覆盖**：覆盖前要先把上一份归档到 `handoffs/`。

## 多线程模式（v2.1，可选）

如果项目有几条并行独立的工作流，接续层分裂：
- 文件变成 `STATUS_<工作流>.md` / `HANDOFF_<工作流>.md`
- 归档变成 `handoffs/<工作流>/YYYY-MM-DD-HHMM.md`
- PROJECT / MAP / DECISIONS / topics 保持共享

详见 METHODOLOGY §3.5。

## 完整方法论

见 [GitHub 上的 METHODOLOGY.md](https://github.com/Ethan-YS/project-brain/blob/main/METHODOLOGY.md)。

（这个文件位于 `<你的项目>/brain/` 下，相对链接到不了方法论 —— 一律用 GitHub URL。）
