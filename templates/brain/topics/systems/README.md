# systems/

> **What goes here**: System design, architecture, technology choices.
>
> **Decision criterion**: ask yourself — "Is this doc answering: **how is it designed?**"

---

## Typical content

- **Architecture docs**: memory system architecture, data flow design, module boundaries
- **Technology choices**: why we picked X over Y (e.g., Postgres vs SQLite, React vs Vue)
- **Protocol / interface design**: API contracts, cross-module communication protocols
- **Domain models**: domain-specific abstractions
- **Red lines / constraints**: system-level inviolable rules (e.g., isolation boundaries)

## Doesn't belong here

- ❌ Release procedures → `operations/`
- ❌ Roadmap / future plans → `planning/`
- ❌ User feedback / bugs → `feedback/`
- ❌ Current session state → `brain/STATUS.md`
- ❌ Historical decision rationale → `brain/DECISIONS.md` (DECISIONS records **why**; systems/ records **what + how it works**)

## File naming suggestions

- Uppercase + underscore, e.g., `MEMORY_ARCHITECTURE.md` / `AI_PROVIDERS.md`
- The name should make "what system / topic" clear at a glance
- Avoid project-name prefixes (`MYPROJECT_MEMORY.md` → `MEMORY_ARCHITECTURE.md`)

## Maintenance disciplines

- Each doc opens with "this file answers: xxx" to clarify boundaries
- Major design changes → simultaneously append a decision entry in `brain/DECISIONS.md`
