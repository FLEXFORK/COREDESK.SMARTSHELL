---
applyTo: '**'
---


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

