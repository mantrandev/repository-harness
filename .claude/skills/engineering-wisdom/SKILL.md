---
name: engineering-wisdom
description: Provide an explicitly requested, repository-grounded engineering review using contextual heuristics for code clarity, SOLID and design, testing, refactoring, architecture, and professional practice. Use only when the user invokes `$engineering-wisdom` or explicitly asks for this installed engineering-wisdom pack; do not turn its advice into repository policy or automatically rewrite an application architecture.
---

# Engineering Wisdom

Claude Code discovers skills under `.claude/skills/`. This file is the
discovery entry only. The canonical procedure is the single source of truth
shared with every other agent:

[`.agents/skills/engineering-wisdom/SKILL.md`](../../../.agents/skills/engineering-wisdom/SKILL.md)

Read that file completely and follow it as written. Resolve its relative
references from `.agents/skills/engineering-wisdom/`, not from this directory.

Explicit-only. Run this skill when the user invokes `$engineering-wisdom` or
explicitly asks for this installed pack. Advice cannot establish repository
policy or authorize an architecture rewrite.
