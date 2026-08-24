---
name: audit-onboarding-proposal
description: Independently audit a brownfield onboarding transcript, operational map, or exact proposed documentation patch before application. Use when a fresh reviewer must verify an $onboard-repository first pass, distinguish environment-caused Unknowns from reasoning defects, score its safety and evidence gates, or run a narrow patch-admissibility decision for specific capsule-backed hunks. This audit is read-only and must not edit files, install tools, start services, create state, or trust the producer's self-score.
---

# Audit Onboarding Proposal

Claude Code discovers skills under `.claude/skills/`. This file is the
discovery entry only. The canonical procedure is the single source of truth
shared with every other agent:

[`.agents/skills/audit-onboarding-proposal/SKILL.md`](../../../.agents/skills/audit-onboarding-proposal/SKILL.md)

Read that file completely and follow it as written. Resolve its relative
references from `.agents/skills/audit-onboarding-proposal/`, not from this directory.

Explicit-only. Run this skill when a fresh reviewer must audit an
`$onboard-repository` first pass. This audit is read-only and must not trust the
producer's self-score.
