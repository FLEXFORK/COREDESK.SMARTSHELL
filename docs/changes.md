# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- (placeholder) New features since last release.

### Changed
- (placeholder) Modifications to existing behavior.

### Fixed
- (placeholder) Bug fixes.

### Removed
- (placeholder) Deprecated or removed functionality.

---

## [1.0.1] - 2025-09-16
GUI improvements and project structure enhancements.

### Added
- Streamlined main window interface with minimal design
- VS Code workspace configuration (launch.json, extensions.json, tasks.json)
- Comprehensive project documentation (contribute.md, updated license.md)
- Windows batch file launcher (start.cmd)
- Splash screen with branded loading sequence

### Changed
- Simplified main window GUI removing complex command interface
- Updated window.view.ps1 to display clean blank window
- Improved splash screen timing and visual presentation
- Enhanced project structure with proper .vscode setup

### Fixed
- Corrected file paths in smartshell.ps1 controller
- Resolved window launch sequence after splash screen
- Fixed GUI component disposal and memory management

### Removed
- Complex command processing interface from main window
- Excessive GUI controls (menus, status bars, command inputs)

---

## [1.0.0] - 2025-09-16
Initial stable release.

### Added
- Launcher script `program/smartshell.ps1` providing entry point.
- Modular configuration system (`program/source/configs/` including themes & settings).
- Window view and logic pair: `window.view.ps1` / `window.script.ps1`.
- Foundational test scripts under `program/tests/` structure.
- Asset directories for fonts, icons, and images prepared for growth.
- Semantic Versioning policy and version management documentation.
- MIT License.

### Security
- No known security issues at time of release.

---

## Linking (Optional Future Enhancement)
If this project adopts GitHub issue/pull request linking conventions, future entries can link to issues (e.g., `#12`) and commits. For now, links are omitted for clarity.

[Unreleased]: https://example.com/compare/v1.0.1...HEAD
[1.0.1]: https://example.com/compare/v1.0.0...v1.0.1
[1.0.0]: https://example.com/releases/tag/v1.0.0

