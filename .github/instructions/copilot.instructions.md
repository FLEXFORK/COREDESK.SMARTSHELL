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


