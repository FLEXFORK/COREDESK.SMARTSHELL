# SmartShell Version Information

| Field | Value |
|-------|-------|
| Version | 1.0.2 |
| Release Date | 2025-09-16 |
| Release Channel | stable |
| Commit | 14bb8de |
| License | Refer to `docs/license.md` |

## Summary

Patch release of SmartShell with comprehensive logging system, theme improvements, and log rotation functionality. Enhanced application monitoring and streamlined theme color management.

## Highlights

- Comprehensive logger service with timestamped log files
- Automatic log rotation maintaining 10 most recent files
- Terminal input/output logging with error tracking
- Simplified theme system using direct Catppuccin colors
- Removed hardcoded application color mappings from themes
- Enhanced error handling and session management
- Silent application launch capability
- Core PowerShell launcher script `program/smartshell.ps1`
- Streamlined main window GUI with minimal interface
- Splash screen with loading sequence and branding
- Configurable settings and themes under `program/source/configs/`
- Window script & view pair (`window.script.ps1`, `window.view.ps1`)
- VS Code workspace configuration (.vscode/launch.json, extensions.json)
- Comprehensive documentation (version.md, changes.md, contribute.md, license.md)
- Windows batch launcher (start.cmd)
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

