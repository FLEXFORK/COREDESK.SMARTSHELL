# SmartShell Test Framework

A comprehensive testing framework for the SmartShell PowerShell application.

## Overview

This test framework provides organized testing capabilities across multiple test categories:

- **Unit Tests** - Test individual components and functions in isolation
- **Integration Tests** - Test component interactions and data flow
- **Functional Tests** - Test complete workflows and end-to-end scenarios
- **Performance Tests** - Test performance characteristics and benchmarks

## Directory Structure

```
tests/
├── helpers/
│   ├── test-helpers.ps1           # Core testing utilities and assertions
│   ├── run-unit-tests.ps1         # Unit test runner
│   ├── run-integration-tests.ps1  # Integration test runner
│   └── run-all-tests.ps1          # Master test suite runner
├── fixtures/
│   └── test-data.json             # Test data and configurations
├── unit/
│   ├── services/
│   │   ├── logger.service.test.ps1    # Logger service unit tests
│   │   └── settings.service.test.ps1  # Settings service unit tests
│   └── README.md
├── integration/
│   ├── theme/
│   │   └── theme-system.integration.test.ps1  # Theme system integration tests
│   └── README.md
├── functional/
│   ├── startup/
│   │   └── application-startup.functional.test.ps1  # Application startup tests
│   └── README.md
└── performance/
    └── README.md
```

## Running Tests

### Run All Tests
```powershell
.\tests\helpers\run-all-tests.ps1
```

### Run Specific Test Categories
```powershell
# Unit tests only
.\tests\helpers\run-all-tests.ps1 -TestType Unit

# Integration tests only
.\tests\helpers\run-all-tests.ps1 -TestType Integration

# Functional tests only
.\tests\helpers\run-all-tests.ps1 -TestType Functional
```

### Run Individual Test Files
```powershell
# Run a specific test file
.\tests\unit\services\logger.service.test.ps1

# Run with detailed output
.\tests\helpers\run-all-tests.ps1 -Detailed

# Stop on first error
.\tests\helpers\run-all-tests.ps1 -StopOnError
```

## Test Helpers

The `test-helpers.ps1` file provides essential testing utilities:

### Assertion Functions
- `Assert-True` - Verify condition is true
- `Assert-False` - Verify condition is false
- `Assert-Equal` - Verify values are equal
- `Assert-NotEqual` - Verify values are not equal
- `Assert-Null` - Verify value is null
- `Assert-NotNull` - Verify value is not null
- `Assert-Contains` - Verify collection contains item
- `Assert-FileExists` - Verify file exists
- `Assert-DirectoryExists` - Verify directory exists

### Test Environment Functions
- `Initialize-TestEnvironment` - Set up test environment
- `Measure-TestExecution` - Measure and track test execution
- `Export-TestResults` - Export test results and summary

### Mock Objects
- `New-MockTheme` - Create mock theme object for testing
- `New-TestSettings` - Create test settings configuration

## Writing Tests

### Test File Naming Convention
- Unit tests: `*.test.ps1`
- Integration tests: `*.integration.test.ps1`
- Functional tests: `*.functional.test.ps1`
- Performance tests: `*.performance.test.ps1`

### Test Function Structure
```powershell
function Test-YourFunctionality {
    Measure-TestExecution -TestName "Your test description" -Category "Test Category" -TestBlock {
        # Arrange
        $expectedValue = "test"

        # Act
        $result = Your-Function -Parameter $expectedValue

        # Assert
        Assert-Equal $expectedValue $result "Function should return expected value"
    }
}
```

### Best Practices

1. **Follow AAA Pattern**: Arrange, Act, Assert
2. **Use Descriptive Names**: Test names should clearly describe what is being tested
3. **Clean Up Resources**: Always clean up temporary files and directories
4. **Mock External Dependencies**: Use mock objects for external services
5. **Test Error Conditions**: Include tests for error scenarios
6. **Keep Tests Independent**: Tests should not depend on other tests

## Test Categories

### Unit Tests
Test individual functions and components in isolation:
- Service functions
- Utility functions
- Data processing functions
- Error handling

### Integration Tests
Test interactions between components:
- Service-to-service communication
- Configuration loading and validation
- Theme system integration
- File system operations

### Functional Tests
Test complete workflows and user scenarios:
- Application startup sequence
- Theme switching workflows
- Settings persistence
- Error recovery scenarios

### Performance Tests
Test performance characteristics:
- Load testing
- Memory usage
- File operation performance
- Startup time benchmarks

## Test Data

Test fixtures and data are stored in the `fixtures/` directory:
- `test-data.json` - Common test data and configurations
- Mock objects and sample data
- Test-specific configuration files

## Continuous Integration

The test framework is designed to support CI/CD scenarios:
- Exit codes indicate success (0) or failure (1)
- Detailed logging and reporting
- Configurable test execution options
- XML/JSON result output (future enhancement)

## Troubleshooting

### Common Issues

1. **Module Import Errors**: Ensure all required modules are in the correct paths
2. **Permission Errors**: Run PowerShell as Administrator if needed
3. **Path Issues**: Use absolute paths in test configurations
4. **Cleanup Failures**: Check for locked files or processes

### Debug Mode
Add `-Detailed` flag to test runners for verbose output and debugging information.

## Contributing

When adding new tests:
1. Choose the appropriate test category
2. Follow naming conventions
3. Use provided assertion functions
4. Include cleanup code
5. Add documentation for complex test scenarios

## Version History

- **1.0.2** - Initial comprehensive test framework
  - Complete test infrastructure
  - Unit, integration, and functional test categories
  - Test runners and helpers
  - Mock objects and fixtures
