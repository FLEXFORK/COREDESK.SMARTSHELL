# SmartShell Version Information

| Field | Value |
|-------|-------|
| Version | 1.0.0 |
| Release Date | 2025-09-16 |
| Release Channel | stable |
| Commit | db4d16b |
| License | Refer to `docs/license.md` |

## Summary

Initial stable public release of SmartShell. Establishes the core window/view system, modular script loading, theming support, and baseline test scaffolding.

## Highlights

- Core PowerShell launcher script `program/smartshell.ps1`
- Configurable settings and themes under `program/source/configs/`
- Window script & view pair (`window.script.ps1`, `window.view.ps1`)
- Test suite foundation in `program/tests/`
- Asset pipeline (fonts, icons, images) structured for expansion

## Compatibility

Target Environment: Windows PowerShell 5.1+ / PowerShell 7+
No external module dependencies declared yet (future releases may introduce module manifest and required modules list).

## Semantic Versioning Policy

This project follows [Semantic Versioning](https://semver.org/):

- MAJOR: Breaking changes in scripts, module interfaces, or configuration formats
- MINOR: Backwards-compatible features, new scripts, views, or configuration options
- PATCH: Backwards-compatible fixes or internal refactors with no interface change

## Version Bump Workflow

1. Update the version field at the top of this file
2. Document notable changes in `docs/changes.md`
3. Commit with a conventional message (e.g., `chore(release): bump to 1.1.0`)
4. Tag the commit: `git tag v1.1.0` then `git push --tags`
5. (Optional) Provide release notes summary in repository release UI

## Checksums (Placeholder)

If distributable archives are produced in future releases, include their SHA256 checksums here to allow users to verify integrity.

---
Generated on 2025-09-16.

