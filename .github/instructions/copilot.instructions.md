---
applyTo: '**'
---


## CODE QUALITY GUIDELINES

Aim: Generate production-grade, secure, maintainable code. Keep answers concise and cite official APIs (no invented methods).

Core principles:
- Correctness first: prefer clarity over cleverness; no speculative abstractions.
- Follow platform & language official docs (Node.js, TypeScript, PowerShell, GitHub Actions).
- Security by default: validate external input, avoid eval / dynamic require, parameterize shell commands.
- Explicit errors: throw typed errors; never silently catch & ignore.
- Pure where practical; isolate side-effects (I/O, network) behind interfaces.
- Performance: avoid N+1 loops, batch filesystem / network calls, short-circuit early.
- Resource safety: always close handles/streams; use finally blocks for cleanup.
- Logging: use central logger; no console.log in core logic.
- Testing: every non-trivial function requires at least 1 happy-path + 1 failure test.
- Types: no implicit any, narrow union types, prefer readonly where immutability intended.
- Dependency discipline: prefer stdlib / built-ins before adding a package.
- Documentation: export symbols MUST have a 1‑line JSDoc / comment summarizing intent.
- Minimal surface: do not expose internal helpers from index barrels unless needed.

When asked for code:
- Provide minimal viable snippet (omit extraneous scaffolding) unless full file requested.
- Use modern syntax: async/await, const, for..of, template literals, optional chaining.
- Show imports explicitly.
- Use descriptive names (configLoader, taskRunner) not data1 / helper.

Security checklist (apply mentally before final answer):
- Input validated (length, type, pattern) before use.
- No raw user data concatenated into shell commands.
- Secrets never logged.
- Paths normalized & resolved; no directory traversal.

Prompt template to reinforce rules (for humans):
> Follow CODE QUALITY GUIDELINES: secure, typed, minimal side-effects, add brief JSDoc.

If information missing, ask clarifying question instead of assuming hidden APIs.


## VERSION.MD EDIT/UPDATE GUIDELINES

NOTE: THIS FILE IS ONLY UPDATED WHEN A NEW RELEASE IS MADE. OR INSTRUCTED OTHERWISE TO DO SO. !IMPORTANT!

When updating `docs/version.md` for a new release, follow these steps:
- Update the version number in the header.
- Add a summary of changes made in the release.
- Include any breaking changes or important notes.
- Update the highlights section with new features or improvements.
- Review compatibility notes for any changes in supported environments.
- Ensure the semantic versioning policy reflects any changes in versioning strategy.
- Update the version bump workflow if there are changes to the release process.
- Add checksums if distributable archives are produced.

UPDATE THESE SECTIONS:
1. # SmartShell Version Information
2. ## Summary
3. ## Highlights
4. ## Compatibility
5. ## Semantic Versioning Policy
6. ## Version Bump Workflow
7. ## Checksums (Placeholder) - only if distributable archives are produced.


## CHANGES.MD EDIT/UPDATE GUIDELINES

NOTE: THIS FILE IS ONLY UPDATED WHEN A NEW RELEASE IS MADE. OR INSTRUCTED OTHERWISE TO DO SO. !IMPORTANT!

When preparing a new release, update the `docs/changes.md` file as follows:
- Categorize changes under the appropriate subsection (Added / Changed / Fixed / Removed / Security / Deprecated) in [Unreleased].
- Ensure entries are concise, user-focused, and begin with a verb in past tense or noun phrase.
- Before tagging, create a new version section by copying [Unreleased] contents and replacing placeholders; then clear or reset [Unreleased] back to placeholders.
- Sync the version and date with `docs/version.md`.
- Commit with a message like: `chore(release): 1.1.0` and tag the commit (`v1.1.0`).
- Avoid listing internal refactors unless they materially impact users or extension contributors.

Section Usage Reference:
- Added: New features.
- Changed: Backwards-compatible behavioral changes or notable adjustments.
- Fixed: Bug fixes.
- Removed: Features taken away in this version.
- Deprecated: Features still present but planned for removal (announce first, remove later).
- Security: Vulnerability disclosures and fixes.

UPDATE THESE SECTIONS:
1. ### Added
2. ### Changed
3. ### Fixed
4. ### Removed

