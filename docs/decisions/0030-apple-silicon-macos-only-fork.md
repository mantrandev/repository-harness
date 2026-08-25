# 0030 Apple Silicon macOS Only, Published From This Fork

Date: 2026-08-25

## Status

Accepted and active.

## Context

This fork serves one operator on Apple Silicon macOS. Upstream builds, tests,
and publishes five platforms: `macos-arm64`, `macos-x64`, `linux-x64`,
`linux-arm64`, and `windows-x64`. Four of those are never installed here, yet
they carry real cost:

1. A PowerShell bootstrap duplicates the Bash installer's product contract, and
   several contract tests exist only to assert Bash/PowerShell parity.
2. Pre-merge CI reserves a `windows-latest` job whose only purpose is running
   that PowerShell installer.
3. The release workflow builds and publishes ten assets, and three separate
   checks encode "five platforms" or "ten assets" as literals.

A second, more serious problem was found while narrowing the platform set. The
installer scripts were repointed to this fork when it was created, but
`release_handoff.rs` still resolved the release tag and candidate binary from
`hoangnb24/repository-harness`. First-time installs came from this fork while
`harness update` self-updated to the upstream binary, which would have silently
reverted any fork-local change, including this one.

## Decision

1. The supported platform is `aarch64-apple-darwin` on macOS 13 or newer.
   Nothing else is built, tested, or published. `detect_cli_platform` and
   `candidate_artifact` resolve one target and fail with a named diagnostic
   otherwise.
2. `scripts/install-harness.ps1` and its mode test are deleted, along with every
   assertion that required Bash/PowerShell parity.
3. Every CI job runs on `macos-15`. Jobs running `cargo test` must, because
   `platform_artifact` now panics off Apple Silicon; the publish and post-merge
   jobs follow so no job depends on Linux tooling.
4. Builds pin `MACOSX_DEPLOYMENT_TARGET` to `13.0`, so the artifact declares the
   floor instead of inheriting Rust's default of `11.0`.
5. `RELEASE_TAG_URL` and `RELEASE_DOWNLOAD_ROOT` resolve from
   `mantrandev/repository-harness`, matching the installer scripts. This fork is
   the single release origin for both install and update.

The repository protocol itself is unchanged. Workflow, authority boundaries,
plan and decision structure, and the proof-before-promotion release shape are
upstream's and stay that way.

## Alternatives Considered

1. **Keep the other platforms and simply not use them.** Rejected because every
   unused platform still gates merges, consumes release minutes, and forces
   parity assertions to be maintained against code nobody runs.
2. **Keep Intel macOS for one more release.** Rejected because no Intel machine
   is in use and `macos-15-intel` runners would still gate the release.
3. **Leave the updater pointing upstream and take upstream binaries.** Rejected
   because the fork's own changes would be overwritten on the first
   `harness update`, and the upstream binary carries a different payload.
4. **Rewrite decisions 0024, 0026, 0027, and 0029 to drop their PowerShell
   references.** Rejected because those records describe choices made when
   PowerShell was supported. This record supersedes their platform scope; it
   does not edit their history.

## Consequences

Positive:

- One build target, one release asset pair, one installer.
- No `windows-latest` job in pre-merge, so merges stop waiting on it.
- Install and update resolve from the same origin, so a fork change survives
  the next update.
- The macOS floor is declared in the binary and checkable with `vtool`.

Tradeoffs:

- This fork cannot be installed on Linux, Windows, or Intel macOS, and the
  failure is a hard error rather than a fallback.
- CI runs entirely on macOS runners, which bill at a higher rate per minute
  than the Linux runners the publish and post-merge jobs previously used.
- Merging upstream changes that touch the installer, release matrix, or
  platform contracts will conflict, and the resolution is always to re-drop the
  non-Apple-Silicon side.
- Decisions 0024, 0026, 0027, and 0029 still mention PowerShell. They are
  historical records; this decision holds the current platform scope.

## Follow-Up

- Re-drop the non-Apple-Silicon side when pulling upstream installer or release
  changes.
- Confirm `vtool -show-build` reports `minos 13.0` on a published artifact after
  the first release from this fork.
