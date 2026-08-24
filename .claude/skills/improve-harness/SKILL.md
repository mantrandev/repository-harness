---
name: improve-harness
description: Run one explicitly authorized, evidence-backed improvement to a repository's agent guidance, tools, runbooks, or validation. Use only when the user invokes `$improve-harness` or explicitly asks to improve the Harness after observed reusable agent friction. Do not use for ordinary product changes, speculative cleanup, one unexplained agent mistake, or automatic post-task reflection.
---

# Improve Harness

Claude Code discovers skills under `.claude/skills/`. This file is the
discovery entry only. The canonical procedure is the single source of truth
shared with every other agent:

[`.agents/skills/improve-harness/SKILL.md`](../../../.agents/skills/improve-harness/SKILL.md)

Read that file completely and follow it as written. Resolve its relative
references from `.agents/skills/improve-harness/`, not from this directory.

Explicit-only. Run this skill when the user invokes `$improve-harness` or
explicitly asks to improve the Harness after observed reusable agent friction.
Baseline-to-rerun evidence is required.
