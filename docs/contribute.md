# Contributing

Short, focused contributions are welcome. Please read this page before opening an issue or pull request.

## Ways to Contribute
- Report bugs (include PowerShell version and repro steps)
- Improve docs (`docs/`)
- Add or refine scripts / views (`program/source/`, `program/scripts/`, `program/views/`)
- Add tests (`program/tests/`)
- Triage issues & review PRs

## Quick Setup
1. Fork & clone.
2. Create a feature branch: `git checkout -b feat/your-feature`.
3. Run / explore core script: `program/smartshell.ps1`.

## Branch Naming
Prefix with:
- `feat/` new feature
- `fix/` bug fix
- `doc/` documentation only
- `chore/` maintenance / tooling

## Commit Style
Use Conventional style (examples):
- `feat(window): add resize handler`
- `fix(config): resolve theme load failure`
- `docs: clarify release workflow`

## Tests
Add / update tests for new behavior. Keep them fast and focused. Prefer one assert purpose per logical block.

## Changelog & Version
Update `docs/changes.md` under [Unreleased]. Core maintainers will finalize version + date in `docs/version.md` during release.

## Code Style
PowerShell: favor readability, explicit parameter names, and comment non-obvious logic. Keep functions small.

## License
By contributing you agree your work is licensed under the project MIT License (`docs/license.md`).

## Pull Request Checklist
- [ ] Linked or described issue / use-case
- [ ] Tests added / passing (if applicable)
- [ ] Docs updated (if user-facing change)
- [ ] Changelog entry added
- [ ] No unrelated changes

Thanks for helping improve SmartShell.

