# project-brain

<p align="center">
  <img src="./assets/hero.png" alt="One folder. Every session knows where you left off." width="100%" />
</p>

> **Different session. Same brain.**
>
> 一套文件结构 + 协作协议，让你的 AI 助手在 context 被压缩、切换窗口、新会话开始之后，依然能快速接续项目。

[English →](./README.md)

**[Sprout Labs](https://ethanflow.com) 出品** — 本地优先的 AI 记忆系统与 Agent 安全研究，由 Ethan（独立产品设计师 & AI Builder，since 2016）独立打造。
[ethanflow.com](https://ethanflow.com) · [LinkedIn](https://www.linkedin.com/in/ethan-ys/) · [@ethanflow_lab](https://x.com/ethanflow_lab) · [GitHub](https://github.com/Ethan-YS)

---

## 它解决什么问题

长期跟 AI 编码助手（Claude Code / Cursor / Copilot 等）一起做项目，会遇到一个反直觉的事实：

> **上下文窗口越大不解决问题。信息结构才解决。**

窗口大不代表 AI 读得完；读得完不代表它能定位；定位得到也不代表知道哪些是关键。没有结构，每次新会话都从"等下，这里在做什么？"开始——AI 要么读太多浪费 token，要么漏掉关键信息。

你应该能识别这些症状：

- 一份 README 混着项目定位 + 当前进度 + 决策历史 + 怎么跑
- 散文档边界不清（一份架构文档里塞着设计 + 运维 + 历史 + bug）
- 关键决策埋在 commit message / 对话记录 / 某份文档的脚注里——需要追溯时永远找不回
- 跨窗口切换时上一个 AI 脑子里"还热着但没写下"的信息丢了——下一个 AI 醒来一脸懵

`project-brain` 是这件事的结构性答案：一个 `brain/` 文件夹布局 + 一组小协议，目的是让一个全新的 AI 会话只读 2-3 个文件就能产出。

## 快速开始

### 方式 A —— 作为 Claude Code skill 安装（Claude Code 用户推荐）

```bash
git clone https://github.com/Ethan-YS/project-brain.git ~/.claude/skills/project-brain
```

之后在任何项目里说"建项目脑"或"set up project brain"——Claude Code 会自动加载 `SKILL.md` 走流程。这个 skill 知道：
- 新项目 kick-off（scaffold + 走 PROJECT.md）
- 接续已有 brain/（读 MAP + STATUS + HANDOFF）
- 切窗口 handoff（写 HANDOFF + 归档上一份）
- "更新项目脑" 流程（带理由的清单，你认可）

### 方式 B —— 手动 scaffold（任何 AI 助手都能用）

```bash
git clone https://github.com/Ethan-YS/project-brain.git

# Scaffold 到你的项目（默认拷入 4 种 AI 适配文件）
./project-brain/scripts/scaffold.sh /path/to/your/project

# 或指定特定的：
./project-brain/scripts/scaffold.sh /path/to/your/project --tools claude,cursor

# 第一天就填 brain/PROJECT.md
# 走查 ⚠️ TODO ⚠️ 占位符
```

scaffold 会给你：

| 文件 | 工具 |
|---|---|
| `brain/` | 项目脑（PROJECT/MAP/STATUS/DECISIONS/HANDOFF + topics/） |
| `CLAUDE.md` | Claude Code 指令文件 |
| `.cursorrules` | Cursor 指令文件 |
| `.github/copilot-instructions.md` | GitHub Copilot Chat |
| `AGENTS.md` | Codex CLI / Aider / Continue（AGENTS.md 约定） |

新 AI 会话打开你的项目时，自动加载的指令文件引导它读 `brain/MAP.md` + `brain/STATUS.md`。如果存在 `brain/HANDOFF.md`，它能拿到上一次会话"还热着但没写下"的内容。

### 体检（scaffold 完成后随时跑）

```bash
./project-brain/scripts/doctor.sh /path/to/your/project
```

只读的结构体检：缺核心文件、STATUS 超过 80 行、决策缺"被否决的方案"、topics/ 文件未在 MAP 登记、`⚠️ TODO ⚠️` 占位符残留 等。**只报告问题，不修改**——修不修是你的判断。

### 看完整填好的例子

如果空模板感觉抽象，看 [examples/small-saas/](./examples/small-saas/) —— 一个虚构的 SaaS 项目（"Quill"，一个 local-first 笔记 app 在 v0.3 阶段），每个文件都填好。读它是最快理解"brain/ 各文件实际填出来长什么样"的方式。

## 结构

```
brain/
├── PROJECT.md       这个项目是什么？刻意不做什么？
├── MAP.md           模块结构 + 文档索引（"X 在哪里？"）
├── STATUS.md        当前状态——可覆写，软上限 80 行
├── DECISIONS.md     决策日志——只追加，必填"被否决的方案"
├── HANDOFF.md       跨窗口桥梁——脑子里还热着但没写下的事
├── handoffs/        历史 HANDOFF 归档（按时间戳）
└── topics/          按问题维度分类的专题
    ├── systems/      → "这是怎么设计的？"
    ├── operations/   → "怎么操作 / 每次发版要做什么？"
    ├── planning/     → "将来要做什么 / 怎么规划？"
    └── feedback/     → "现实 / 用户告诉我们什么？"
```

## 核心原则

### 1. 按时间特性分文件

`brain/` 下的 5 份核心文件**按变化频率分**，不是按主题分：

| 文件 | 变化频率 | 何时读 |
|---|---|---|
| `PROJECT.md` | 几乎不变 | 首次接触 / 范围模糊 |
| `MAP.md` | 缓慢变 | 每次新会话 |
| `STATUS.md` | 频繁（每会话） | 每次新会话 |
| `DECISIONS.md` | 只追加，事件驱动 | 追溯"为什么长成这样" |
| `HANDOFF.md` | 切窗口时 | 新会话开始（如果存在） |

为什么按时间特性分？因为**低频内容混在高频内容里，会被一起改**——这是文档腐烂最常见的原因。

### 2. 按问题维度分类专题（不按模块分）

`brain/topics/` 分 4 个维度：`systems` / `operations` / `planning` / `feedback`。一个业务模块（比如"支付"）的设计文档进 `systems/`、部署日志进 `operations/`、定价策略进 `planning/`、用户反馈进 `feedback/`。

为什么？模块会增减、改名、合并、拆分。这四个问题维度稳定得多。

### 3. DECISIONS 必填"被否决的方案"

每条决策必须写"考虑过什么、为什么没选"。少了这一项，这份文件就退化成 `CHANGELOG.md` 的劣质版本（changelog 已经记录"做了什么"）。决策日志的独特价值是**那些没走的路**——那里藏着项目的判断力。

### 4. 判断权分工

当用户说"更新项目脑"时：
- **用户**决定"该不该现在记"（凭对项目节奏的感觉）
- **AI**决定"具体记哪些 / 每条写什么"（凭对各文件运作方式的专业理解）
- **用户**认可或否决 AI 的判断

AI 不该把专业判断推回给用户问"你想更新哪些？"——这把错的判断层交给了错的人。

### 5. 工作流分裂模式（v2.1，可选）

有些项目天然有并行的多条独立工作流（比如一个产品同时跑开发 + 运营 + 对外推广）。这时 STATUS 和 HANDOFF 按工作流分裂：

```
brain/
├── PROJECT.md           ← 共享
├── MAP.md               ← 共享
├── DECISIONS.md         ← 共享
├── STATUS_dev.md        ← 按工作流分裂
├── STATUS_ops.md
├── HANDOFF_dev.md
├── HANDOFF_ops.md
├── handoffs/
│   ├── dev/
│   └── ops/
└── topics/              ← 共享
```

单工作流项目忽略这条——保持默认的 `STATUS.md` / `HANDOFF.md`。

## 这套方法论是怎么演化出来的

它不是某次设计会议的产物。它是在多个真实项目里**被现实推着演化**出来的——每一次迭代都源于一个我们绕不过去的具体问题。

**v1（2026-04）**：第一个项目积累了 15+ 份散文档 + 一个 32KB 的巨型 dev 文件。每次开新 AI 会话都要重读一遍才能理解"这里在干什么"——**上下文窗口越大不解决问题，信息结构才解决**。我们做了 4 次 commit 的重构，建立了基本结构：`meta/`（接续层）+ `docs/`（按问题维度分类的专题层）。核心洞见是**按时间特性分文件**——避免低频内容被高频内容推着一起改。

**v2（2026-04-30）**：我们调研了社区方案（Prompt Shelf 2026 三文件架构、softaworks/agent-toolkit 的 session-handoff、Anthropic 官方 skills 仓库等），发现：
- 社区方案在**运行时机制**（自动 handoff 触发、过时检测、handoff 链）上更全
- 我们的 v1 在**结构设计**上更深（"刻意不做什么"强制位、决策日志的"被否决方案"必填、按问题维度分类）

演化方向是"借社区的机制层 + 保留 v1 的结构层"——但在 8 轮迭代过程中，**用户系统性地拒绝了"用机制取代判断"**。每次 AI 提出"我来设计自动判别 / 触发条件 / 过时检测"，用户都说"不要——这件事我自己判断"。

这逼出了 v2 的核心原则——**判断权分工**：用户决定"该不该现在记"（高层节奏判断）；AI 决定"具体记哪些 / 每条写什么"（细节专业判断）；用户认可或否决 AI 的判断。**AI 不能把专业判断推回给用户**。

伴随的设计：合并 `meta/` + `docs/` 为单一 `brain/`、加 `HANDOFF.md` 跨窗口桥梁、温柔询问取代硬词识别（"这事算定了吗？"而不是"我们决定了 X"）、占位符显眼化、明文 git 前提。

**v2.1（同日深夜）**：第二个项目——一个**非开发项目**，并行跑多条独立工作流——撞到 v2 的假设"一个项目 = 一条工作流主线"。用户已经自然演化出 `STATUS_<工作流>.md` 命名后缀绕过限制，但意识到这应该被 skill 化。v2.1 加入**工作流分裂模式**（可选，默认关闭）。

### 元收获

健康的演化模式不是"先把所有可能场景设计满"。它是"**先做能用的，让实战推动下一版**"——每一版都从一个具体的、有名字的问题开始。

如果你只从这个仓库带走一件事：**抵抗"先把所有自动化设计满"的冲动**。真实的摩擦会告诉你哪些机制值得做，哪些只会把专业判断交给错误的层。

## 文档

- **[METHODOLOGY.md](./METHODOLOGY.md)** — 完整方法论（含 14 条陷阱、判断权分工机制细节、工作流分裂细节、迁移路径）
- **[CHANGELOG.md](./CHANGELOG.md)** — 版本历史
- **[SKILL.md](./SKILL.md)** — Claude Code skill manifest（安装到 `~/.claude/skills/project-brain/` 后的 entry）
- **[templates/](./templates/)** — `brain/` + 4 种 AI 工具的 adapter 模板
- **[examples/small-saas/](./examples/small-saas/)** — 一个完整填好的 brain/ 示例
- **[scripts/scaffold.sh](./scripts/scaffold.sh)** — 一条命令 scaffold 到任何项目
- **[scripts/doctor.sh](./scripts/doctor.sh)** — 只读的结构体检（catch 6 种最常见陷阱）

## 兼容性

方法论本身和具体 AI 助手无关。仓库内置 4 种 AI 工具的 adapter：
- **Claude Code** —— `CLAUDE.md`（自动加载）+ `SKILL.md`（Claude Code skill manifest，安装到 `~/.claude/skills/project-brain/`）
- **Cursor** —— `.cursorrules`
- **GitHub Copilot Chat** —— `.github/copilot-instructions.md`
- **Codex CLI / Aider / Continue** —— `AGENTS.md`（[agents.md](https://agents.md) 约定）
- 其他工具：写一份指向 `brain/MAP.md` + `brain/STATUS.md` 的指令文件即可

`./scripts/scaffold.sh` 默认拷贝全部 4 种；用 `--tools claude,cursor` 指定特定的。

要求：
- **Git** —— 几个机制（HANDOFF 归档、决策追溯、文件 blame）依赖 git 历史
- 仅此而已。

## 状态

🌱 v2.3 —— 方法论稳定，2 个项目在生产中跑 n=1 和 n=2。v2.3 加入 `scripts/doctor.sh`（结构体检）和完整填好的示例项目（`examples/small-saas/`）。v2.2 让它能作为 Claude Code skill 安装，加入 Cursor / Copilot / AGENTS.md adapter。还没被广泛使用；可以理解为"被 2 个高强度用户验证过，等待社区检验"。

## 作者

由 [**Ethan**](https://ethanflow.com) 开发——[Sprout Labs](https://ethanflow.com) 背后的人。这套方法论来自一套贾维斯式 AI 协作工作流：8 轮迭代在单日工作日内完成，每一轮都由一个具体的摩擦点触发——不是设计会议。

方法论本身正是这套工作方式的体现：清晰的判断权分工、拒绝把"该由人做的判断"自动化掉、愿意承认 v1 需要变成 v2。

由 [Sprout Labs](https://ethanflow.com) 发布。

## 许可

[MIT](./LICENSE) —— 用它、改它、分享它。如果它对你的工作流有帮助，欢迎给仓库一颗 star。

## 贡献

欢迎 issue 和 PR。这套方法论刻意保持极简——增加机制的提案需要明确指出它解决的具体摩擦。**新陷阱**（你用这套时踩过的坑）尤其欢迎。
