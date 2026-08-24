# 0029 Multi-Agent Entrypoints And Claude Code By Default

Date: 2026-08-24

## Status

Accepted and active.

## Context

The installed core is agent-neutral in intent but was reachable in practice by
one agent family. Two mechanical facts caused this:

1. `AGENTS.md` is auto-loaded by Codex-family agents. Claude Code does not read
   it, so the repository protocol never entered its context unless the operator
   passed `--claude` to write a `CLAUDE.md` shim.
2. Skill discovery is directory-scoped per agent. The core installs skills under
   `.agents/skills/` with `agents/openai.yaml` metadata. Claude Code only scans
   `.claude/skills/`, so `$encode-invariant`, `$onboard-repository`,
   `$improve-harness`, and `$audit-onboarding-proposal` were undiscoverable
   regardless of any entrypoint flag.

The result was an asymmetry the installer did not report: an operator could
install Harness, run Claude Code, and get none of the repository protocol and
none of the skills, with no diagnostic. The PowerShell installer had no Claude
option at all, so Windows operators could not close the gap manually.

Decision 0026 established that skills belong in the default core and remain
explicit-only. It did not address per-agent discovery paths.

## Decision

1. The default core installs a `.claude/skills/<name>/SKILL.md` discovery entry
   for every core skill. The entry carries the frontmatter Claude Code needs to
   discover the skill and points at the canonical
   `.agents/skills/<name>/SKILL.md` as the single source of truth. Procedure
   text is not duplicated.
2. The frontmatter `description` is copied verbatim from the canonical skill.
   Trigger and non-trigger wording therefore has one owner, and the explicit-only
   gate that `allow_implicit_invocation: false` expresses for Codex is carried in
   words for agents that have no equivalent field.
3. `.claude/skills/` entries are managed core files embedded in the `harness`
   binary. They are recorded under `.harness-core/base/` and update through the
   same three-way merge as every other core file.
4. Writing `CLAUDE.md` becomes the installer default on both Bash and
   PowerShell. `--no-claude` / `-NoClaude` suppresses it. `--claude` / `-Claude`
   remains accepted and states the default explicitly.
5. Both installers report the Claude entrypoint decision on every run, so an
   excluded entrypoint is observable rather than silent.
6. `CLAUDE.md` keeps marked-block semantics: a stale block is refreshed in
   place, a current block is skipped without a backup, a file without the block
   receives it appended after a backup, and a malformed marker pair fails
   closed.
7. The engineering-wisdom add-on gains a matching discovery entry in its own
   manifest. Omitting the flag still installs neither copy.
8. This decision adds agent-facing entrypoints only. It does not add a second
   installation profile, a per-agent payload matrix, or any global or
   user-level installation. Everything installs inside the target repository.

## Alternatives Considered

1. **Keep `--claude` opt-in.** Rejected because the default install silently
   produced a broken experience for a supported agent, and the operator had no
   signal that anything was missing.
2. **Duplicate every skill file into `.claude/skills/`.** Rejected because
   thirteen duplicated files create two sources of truth for procedure text,
   and drift between them is invisible to the three-way merge.
3. **Symlink `.claude/skills/<name>` to the canonical directory.** Rejected
   because the content-hash merge model has no symlink representation and
   Windows targets cannot rely on symlink creation.
4. **Install skills into a user-level or global agent directory.** Rejected
   because Harness installs into one repository and must not mutate operator
   state outside the target.
5. **Make `.claude/skills/` an opt-in add-on alongside the entrypoint flag.**
   Rejected because add-on payloads are copied outside the updater and would
   never receive skill corrections.

## Consequences

Positive:

- A default installation is usable by Codex-family agents and Claude Code
  without an extra flag or manual step.
- Skill procedure text keeps exactly one owner; discovery entries carry no
  independent instructions.
- Claude discovery entries receive normal provenance-aware updates.
- PowerShell and Bash expose the same named selection and the same
  marked-block, backup, and fail-closed behavior.
- The installer states which entrypoints it wrote.

Tradeoffs:

- The default managed payload grows by four small discovery entries, which are
  inert for operators who use neither agent.
- A default install now touches `CLAUDE.md` in repositories that already have
  one. The prior bytes are backed up, and `--no-claude` opts out.
- A repository whose `CLAUDE.md` carries a malformed Harness marker pair now
  fails a default install that previously succeeded. This is deliberate: a
  partial marker pair cannot be edited safely.
- Claude invocation costs one extra file read per skill.

## Follow-Up

- Add a discovery entry whenever a core skill is added, and keep its
  frontmatter description byte-identical to the canonical skill.
- Exercise fresh, merge, `--no-claude`, existing-file, and malformed-marker
  installation on Bash and PowerShell.
