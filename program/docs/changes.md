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

## [1.0.2] - 2025-09-16
Comprehensive logging system and theme improvements.

### Added
- Complete logger service with timestamped log files in `program/logs/`
- Automatic log rotation maintaining 10 most recent files
- Terminal input/output logging with detailed session tracking
- Error-specific logging in `program/logs/errors/` directory
- Silent application launch capability with `-WindowStyle Hidden`
- Log session management with start/end timestamps and duration tracking
- Direct theme color mapping system using authentic Catppuccin colors

### Changed
- Simplified theme system to use direct Catppuccin color references
- Enhanced error handling with detailed exception information and stack traces
- Improved application startup logging and monitoring
- Theme switching now uses semantically appropriate colors (red for close, yellow for minimize)

### Fixed
- Removed unused variable warnings in window view
- Fixed hardcoded button hover colors to use theme-appropriate colors
- Resolved theme color mapping inconsistencies
- Corrected minimize button hover behavior

### Removed
- "application" color mapping sections from all Catppuccin theme files
- Hardcoded UI color values in favor of dynamic theme colors
- Unused hover color variables and redundant color assignments

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

[Unreleased]: https://example.com/compare/v1.0.2...HEAD
[1.0.2]: https://example.com/compare/v1.0.1...v1.0.2
[1.0.1]: https://example.com/compare/v1.0.0...v1.0.1
[1.0.0]: https://example.com/releases/tag/v1.0.0

