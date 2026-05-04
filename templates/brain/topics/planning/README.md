# planning/

> **What goes here**: Roadmap, pricing strategy, plans.
>
> **Decision criterion**: ask yourself — "Is this doc answering: **what are we going to build / how do we plan it?**"

---

## Typical content

- **Pricing strategy**: tier design, payment provider config, one-time vs subscription tradeoffs
- **Roadmap / phase plan**: feature plan by phase / Sprint
- **Refactor implementation plans**: cross-commit large-change plans (mark "historical doc" once executed)
- **Product strategy details**: deeper plans beyond the top-level PRODUCT_PLAN

## Doesn't belong here

- ❌ PRODUCT_PLAN itself → **project root** (alongside README — it's a project-face-level doc)
- ❌ Current instantaneous state → `brain/STATUS.md` (STATUS is "currently doing"; planning is "going to build")
- ❌ Already-executed deployments → `operations/`
- ❌ Historical decision rationale → `brain/DECISIONS.md`

## vs `brain/STATUS.md`

| Dimension | `brain/STATUS.md` | `planning/*.md` |
|---|---|---|
| Time-scale | Now / this week | Future weeks / months |
| Update frequency | Every session | Occasional |
| Content | Specific down to "next file to edit" | Abstract up to "ship payment loop in Q2" |
| Length | Soft cap ~80 lines | No hard cap |

**Quick test**: content that gets overwritten at end-of-session goes in STATUS; cross-session-stable plans go in planning/.

## vs `DECISIONS.md`

- `planning/` = plans **not yet executed**, directions **about to do**
- `brain/DECISIONS.md` = **already-decided** things + why decided that way + why not the alternatives

Once a planning direction is **decided**, the corresponding decision entry should also be appended to DECISIONS.

## Maintenance disciplines

- Executed plans → mark "**historical doc**" at the top, keep but don't edit
- Plan adjustments → don't overwrite; append a "direction adjustment" decision entry to DECISIONS
- **Active strategy** (e.g., currently-in-effect pricing model — not a plan, but the live policy) can live here, marked "currently in effect"
