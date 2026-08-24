---
name: onboard-repository
description: Inspect an unfamiliar or brownfield repository, trace one real operational path, and propose evidence-backed improvements that help future agents work independently. Use when explicitly asked to onboard, map, assess, or backfill agent-facing repository guidance; use again after the user approves exact proposal items. The first pass is read-only and must not edit files, install tools, start services, create state, or infer missing product policy.
---

# Onboard Repository

Claude Code discovers skills under `.claude/skills/`. This file is the
discovery entry only. The canonical procedure is the single source of truth
shared with every other agent:

[`.agents/skills/onboard-repository/SKILL.md`](../../../.agents/skills/onboard-repository/SKILL.md)

Read that file completely and follow it as written. Resolve its relative
references from `.agents/skills/onboard-repository/`, not from this directory.

Explicit-only. Run this skill when the user invokes `$onboard-repository` or
explicitly asks to onboard, map, assess, or backfill agent-facing guidance. The
first pass is read-only.
