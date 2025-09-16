---
applyTo: '**'
---

# SmartShell Testing Instructions

## Overview

This document provides comprehensive guidelines for creating, organizing, and running tests in the SmartShell project. All tests should be created in the `program/tests/` directory structure and preserved for future use.

## Test Directory Structure

```
program/tests/
├── unit/                    # Unit tests for individual functions
│   ├── services/           # Tests for service modules
│   ├── views/              # Tests for view components
│   ├── scripts/            # Tests for script logic
│   └── configs/            # Tests for configuration handling
├── integration/            # Integration tests for combined functionality
│   ├── gui/                # GUI interaction tests
│   ├── theme/              # Theme system tests
│   └── logging/            # Logger service integration tests
├── functional/             # End-to-end functional tests
│   ├── startup/            # Application startup tests
│   ├── window/             # Window behavior tests
│   └── settings/           # Settings management tests
├── performance/            # Performance and load tests
├── helpers/                # Test helper functions and utilities
└── fixtures/               # Test data and mock files
```

## Test Creation Guidelines

### When to Create Tests

1. **New Feature Development**: Create tests for any new functionality before or during implementation
2. **Bug Fixes**: Create regression tests that reproduce the bug before fixing it
3. **Refactoring**: Ensure existing functionality has test coverage before refactoring
4. **Critical Functions**: Always test core services (logger, settings, themes)
5. **UI Components**: Test GUI components and user interactions

### Test Naming Conventions

- **Test Files**: `[ComponentName].test.ps1` (e.g., `logger.service.test.ps1`)
- **Test Functions**: `Test-[FunctionName]-[Scenario]` (e.g., `Test-WriteLog-ValidInput`)
- **Integration Tests**: `[Feature].integration.test.ps1`
- **Functional Tests**: `[Workflow].functional.test.ps1`

### Test File Template

```powershell
<#
.SYNOPSIS
    Tests for [Component/Feature Name]

.DESCRIPTION
    Comprehensive test suite for [Component] functionality including:
    - Unit tests for individual functions
    - Error handling validation
    - Edge case coverage

.NOTES
    Created: [Date]
    Version: 1.0.2
    Category: [unit/integration/functional/performance]
#>

# Import required modules and dependencies
. "$PSScriptRoot\..\..\source\services\[service].service.ps1"
. "$PSScriptRoot\..\helpers\test-helpers.ps1"

# Test configuration
$script:TestResults = @()

function Test-[FunctionName]-[Scenario] {
    param()

    $testName = "Test [Function] with [Scenario]"

    try {
        # Arrange
        $expectedResult = "expected value"

        # Act
        $actualResult = Invoke-FunctionUnderTest -Parameter "value"

        # Assert
        if ($actualResult -eq $expectedResult) {
            Add-TestResult -Name $testName -Status "PASS"
        } else {
            Add-TestResult -Name $testName -Status "FAIL" -Message "Expected '$expectedResult', got '$actualResult'"
        }
    }
    catch {
        Add-TestResult -Name $testName -Status "ERROR" -Message $_.Exception.Message
    }
}

# Export test results
function Export-TestResults {
    $script:TestResults | ForEach-Object {
        $status = if ($_.Status -eq "PASS") { "✅" } elseif ($_.Status -eq "FAIL") { "❌" } else { "⚠️" }
        Write-Host "$status $($_.Name)" -ForegroundColor $(if ($_.Status -eq "PASS") { "Green" } elseif ($_.Status -eq "FAIL") { "Red" } else { "Yellow" })
        if ($_.Message) { Write-Host "   $($_.Message)" -ForegroundColor Gray }
    }
}
```

## Test Execution Guidelines

### Running Individual Tests

```powershell
# Run a specific test file
cd program/tests
powershell.exe -ExecutionPolicy Bypass -File .\unit\services\logger.service.test.ps1

# Run all tests in a category
Get-ChildItem .\unit\*.test.ps1 | ForEach-Object { & $_.FullName }
```

### Running Test Suites

```powershell
# Run all unit tests
.\helpers\run-unit-tests.ps1

# Run all integration tests
.\helpers\run-integration-tests.ps1

# Run complete test suite
.\helpers\run-all-tests.ps1
```

## Test Categories and Requirements

### Unit Tests (`program/tests/unit/`)

**Purpose**: Test individual functions and methods in isolation

**Requirements**:
- Test single function per test file
- Mock external dependencies
- Cover happy path, edge cases, and error conditions
- Fast execution (< 1 second per test)

**Example Scenarios**:
- Settings service functions (Get-AppSettings, Set-AppSettings)
- Logger service functions (Write-LogEntry, Initialize-Logger)
- Theme functions (Get-Theme, Get-ThemeColors)
- Configuration validation

### Integration Tests (`program/tests/integration/`)

**Purpose**: Test interaction between multiple components

**Requirements**:
- Test component interactions
- Use real dependencies where possible
- Verify data flow between services
- Medium execution time (< 10 seconds per test)

**Example Scenarios**:
- Logger + Settings integration
- Theme system + GUI integration
- Configuration loading and application
- Service initialization sequences

### Functional Tests (`program/tests/functional/`)

**Purpose**: Test complete user workflows and scenarios

**Requirements**:
- Test end-to-end functionality
- Simulate real user interactions
- Verify complete workflows
- Longer execution time acceptable

**Example Scenarios**:
- Application startup sequence
- Theme switching workflow
- GUI window operations
- Settings modification and persistence

### Performance Tests (`program/tests/performance/`)

**Purpose**: Validate performance characteristics and resource usage

**Requirements**:
- Measure execution time
- Monitor memory usage
- Test with realistic data volumes
- Establish performance baselines

## Test Data and Fixtures

### Test Fixtures (`program/tests/fixtures/`)

Create reusable test data and mock objects:

```
fixtures/
├── themes/
│   ├── mock-theme.json
│   └── invalid-theme.json
├── settings/
│   ├── valid-settings.json
│   └── corrupted-settings.json
└── logs/
    ├── sample-log.log
    └── error-log.log
```

### Mock Data Guidelines

- Create realistic test data
- Include both valid and invalid scenarios
- Version control all test fixtures
- Document test data purpose and usage

## Test Helpers and Utilities

### Required Helper Functions (`program/tests/helpers/`)

```powershell
# test-helpers.ps1
function Add-TestResult {
    param($Name, $Status, $Message = "")
    $script:TestResults += @{ Name = $Name; Status = $Status; Message = $Message }
}

function Assert-Equal {
    param($Expected, $Actual, $Message = "")
    if ($Expected -ne $Actual) {
        throw "Assertion failed: Expected '$Expected', got '$Actual'. $Message"
    }
}

function Assert-True {
    param($Condition, $Message = "")
    if (-not $Condition) {
        throw "Assertion failed: Condition was false. $Message"
    }
}

function New-MockLogger {
    # Create mock logger for testing
}

function New-TestSettings {
    # Create test settings configuration
}
```

## Continuous Testing Integration

### Pre-commit Testing

- Run unit tests before commits
- Validate code syntax and style
- Check for regression issues

### Automated Test Execution

- Integration with CI/CD pipelines
- Automated test reporting
- Performance regression detection

## Test Maintenance

### Test Lifecycle

1. **Create**: Write tests for new functionality
2. **Maintain**: Update tests when code changes
3. **Refactor**: Improve test quality and coverage
4. **Archive**: Keep obsolete tests for reference
5. **Document**: Update test documentation

### Best Practices

- **Keep tests simple**: One assertion per test when possible
- **Make tests independent**: Tests should not depend on each other
- **Use descriptive names**: Test names should clearly indicate what is being tested
- **Test edge cases**: Include boundary conditions and error scenarios
- **Mock external dependencies**: Isolate units under test
- **Regular maintenance**: Update tests as code evolves

## Error Handling in Tests

```powershell
function Test-WithErrorHandling {
    try {
        # Test implementation
        $result = Invoke-Function -Parameter $value
        Assert-Equal $expected $result
        Add-TestResult -Name "Test Name" -Status "PASS"
    }
    catch [SpecificException] {
        # Handle expected exceptions
        Add-TestResult -Name "Test Name" -Status "PASS" -Message "Expected exception handled"
    }
    catch {
        # Handle unexpected exceptions
        Add-TestResult -Name "Test Name" -Status "ERROR" -Message $_.Exception.Message
        Write-Host "Unexpected error in test: $($_.Exception.Message)" -ForegroundColor Red
    }
}
```

## Test Reporting

### Test Output Format

```
SmartShell Test Results - 2025-09-16 08:00:00
==============================================

Unit Tests:
✅ Test Logger Initialize With Valid Path
✅ Test Settings Load Configuration
❌ Test Theme Invalid Color Format
   Expected valid color, got invalid format

Integration Tests:
✅ Test Logger Settings Integration
⚠️ Test GUI Theme Integration
   Warning: Theme switching took 2.3s (> 2s threshold)

Summary:
- Total Tests: 25
- Passed: 22
- Failed: 1
- Warnings: 2
- Execution Time: 45.2s
```

## Test Coverage

### Minimum Coverage Requirements

- **Services**: 90% function coverage
- **Views**: 70% component coverage
- **Scripts**: 80% logic coverage
- **Critical paths**: 100% coverage

### Coverage Tracking

- Use PowerShell code coverage tools when available
- Manual tracking for GUI components
- Regular coverage reviews and improvements

---

**Remember**: Tests are living documentation of your code. Keep them updated, relevant, and comprehensive. Never delete tests unless the functionality is permanently removed from the codebase.


