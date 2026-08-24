# Installation Contract

Harness has one product profile and one independent advisory add-on.

## Core

The exact core payload is declared in
`scripts/harness-install-files.txt`. It contains generic repository guidance,
working-memory structure, an invariant-encoding pattern and skill, and
explicit-only onboarding and improvement skills.

The platform bootstrap installs a checksum-verified `harness` binary under
`scripts/bin/` and delegates installation or update to that candidate.

Core installation:

- records exact upstream bytes under `.harness-core/`;
- preserves consumer files through merge or human-directed conflict handling;
- backs up replaced files;
- does not install an application stack or product policy;
- does not install schemas, databases, orchestration, or background processes;
- does not delete pre-existing legacy Harness files.

## Agent Entrypoints

Harness installs into one repository. It never writes global or user-level
agent configuration.

Codex-family agents auto-load `AGENTS.md`. Claude Code does not, so the core
also installs a `CLAUDE.md` shim that `@`-imports `AGENTS.md` inside a marked
Harness block. Writing that shim is the default. `--no-claude` / `-NoClaude`
suppresses it; `--claude` / `-Claude` states the default explicitly. Both
installers report which entrypoints they wrote.

`CLAUDE.md` follows marked-block rules: a stale block is refreshed in place, a
current block is skipped without a backup, a file without the block receives it
appended after a backup, and a malformed marker pair fails closed.

Skill discovery is directory-scoped per agent. Canonical skill procedure lives
once under `.agents/skills/<name>/SKILL.md`. The core also installs a
`.claude/skills/<name>/SKILL.md` discovery entry whose frontmatter matches the
canonical skill and whose body points at it. Discovery entries are managed core
files: they are recorded under `.harness-core/base/` and update through the same
three-way merge. They are inert for agents that do not read them, so
`--no-claude` does not remove them.

See `docs/decisions/0029-multi-agent-entrypoints-and-claude-default.md`.

## Engineering Wisdom Add-On

`--with-engineering-wisdom` or `-WithEngineeringWisdom` copies the
explicit-only advisory skill declared in
`scripts/engineering-wisdom-install-files.txt`, including its Claude discovery
entry.

Omitting the flag does not install or activate the skill. A later install
without the flag leaves an existing copy untouched. Removal is explicit and
stateless: delete only `.agents/skills/engineering-wisdom/` and
`.claude/skills/engineering-wisdom/`.

Advice cannot establish consumer policy or authorize an architecture rewrite.

## Merge And Override

- `--merge` / `-Merge`: preserve existing files and add missing managed
  paths.
- `--override` / `-Override`: back up and replace protected Harness paths.
- `--force` / `-Force`: overwrite individual managed files with backups.
- `--dry-run` / `-DryRun`: preview without writing.

## Update

`harness update` verifies release identity and checksum, compares installed
base, local bytes, and incoming bytes, and applies the complete plan
transactionally.

Overlapping text edits stage a frozen resolution session. Structural conflicts
must be corrected before replanning. Successful activation writes provenance
last and replaces only the selected repository's executable after core files
succeed.

## Removed Profile

The former `--with-cli`, `--upgrade-cli`, `-WithCli`, and `-UpgradeCli`
profiles ended with protocol v1. Current installers reject those options.
Existing consumer databases and binaries are not automatically deleted.
