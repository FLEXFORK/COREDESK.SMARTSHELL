## COMMIT MESSAGE GUIDELINES

All AI or manually written commit messages MUST use a concise bullet list format.

Format rules:
- First line begins with a capital letter bullet line (no conventional commit prefix required unless explicitly added by maintainer).
- Use a leading dash and one space: `- <description>`.
- Present tense, imperative mood ("Add", "Fix", "Update", not "Added" or "Fixes").
- Each bullet is a self‑contained change; group related minor edits together.
- Avoid trailing periods unless the bullet is a full sentence with multiple clauses.
- Max 72 characters per bullet when possible; wrap intentionally if longer.
- If referencing issues, append at end: `(refs #123)` or `(fixes #123)`.
- Security relevant bullet should begin with `SEC:`.
- Breaking changes: add a final bullet `- BREAKING: <impact>`.

Do NOT include:
- Auto-generated noise (timestamps, author names, commit hashes).
- Phrases like "This commit" or "Minor changes".
- Redundant words (e.g., "Update updated").

Recommended workflow for AI commit generation (GitHub / VS Code Copilot):
1. Stage changes (`git add ...`).
2. Use the "Generate Commit Message" (Copilot) action.
3. If output not in bullet format, prompt: `Generate bullet list commit message using '-' bullets, imperative mood.`
4. Manually prune any low‑value bullets (e.g., purely cosmetic whitespace unless intentional).

Positive examples:
```
- Add PowerShell module bootstrap loader
- Refactor task runner to async interface
- Fix Windows path normalization on network shares (refs #42)
- Optimize file scan by batching stat calls
- BREAKING: Remove deprecated ConfigLoader API
```

Anti-pattern examples (avoid):
```
Added new feature for loader            # past tense
- This commit fixes bug in code         # phrase "This commit"
* Update stuff                          # wrong bullet symbol & vague
- fix: small change                     # lowercase start & vague
```

If only one meaningful change, still use single bullet.

Optional prefixes (use sparingly and only if consistently adopted):
- FEAT, FIX, CHORE, DOCS, TEST, PERF, REFACTOR, BUILD, CI, SEC

When using a prefix, it comes immediately after the dash:
`- FEAT: Add plugin discovery via manifest`

---
These guidelines help AI learn and produce consistent messages. Keep this section succinct; adjust as conventions evolve.


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

