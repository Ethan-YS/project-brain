# operations/

> **What goes here**: Ops, processes, packaging, deployment, runbooks.
>
> **Decision criterion**: ask yourself — "Is this doc answering: **how do I operate it / what to do each time?**"

---

## Typical content

- **Release procedures**: package commands, publish steps, RELEASE_CHECKLIST
- **Build / packaging**: cross-platform packaging, signing, notarization
- **Deploy logs**: what happened during a particular deployment + issues encountered
- **Operational runbooks**: reset user data, admin tasks, support flows
- **Change history**: CHANGELOG (organized by version)
- **External coordination**: how this interacts with other repos / teams

## Doesn't belong here

- ❌ System design / architecture → `systems/`
- ❌ Future plans / roadmap → `planning/`
- ❌ Bug tracking → `feedback/`
- ❌ **PRODUCT_PLAN belongs at the project root**, not under operations/ (PRODUCT_PLAN is product-level "what to build"; operations is operational "how to do it")

## File naming suggestions

- Uppercase + underscore, e.g., `RELEASE_CHECKLIST.md` / `PAYMENT_DEPLOY_LOG.md`
- Operational verb at front or scenario-descriptive, so the reader knows when to consult it
- `CHANGELOG.md` is the conventional name; keep underscore or omit, follow project style

## Maintenance disciplines

- **RELEASE_CHECKLIST**: walk through it for each release; if a step is missing, add it
- **CHANGELOG**: update at each release, not "I'll catch up later"
- **DEPLOY_LOG**: log it during the deploy, with concrete steps and issues
- The "authority" of an operational doc comes from the **last time it was actually walked through** — long-unused procedures should default to "presumed stale"
