<#
.SYNOPSIS
    Unit tests for Logger Service

.DESCRIPTION
    Comprehensive test suite for logger.service.ps1 functionality including:
    - Logger initialization
    - Log file creation and rotation
    - Error handling validation
    - Session management

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: unit
#>

# Import required modules and dependencies
. "$PSScriptRoot\..\..\..\source\services\logger.service.ps1"
. "$PSScriptRoot\..\..\helpers\test-helpers.ps1"

function Test-LoggerInitialization {
  Measure-TestExecution -TestName "Logger initialization creates required directories" -Category "Logger" -TestBlock {
    # Arrange
    $testLogDir = "$env:TEMP\SmartShell-Test-Logs"
    $testErrorDir = "$testLogDir\errors"

    # Clean up any existing test directories
    if (Test-Path $testLogDir) {
      Remove-Item $testLogDir -Recurse -Force
    }

    # Act
    $result = Initialize-Logger -LogDirectory $testLogDir -ErrorDirectory $testErrorDir

    # Assert
    Assert-True $result "Logger initialization should return true"
    Assert-DirectoryExists $testLogDir "Main log directory should be created"
    Assert-DirectoryExists $testErrorDir "Error log directory should be created"

    # Cleanup
    Remove-Item $testLogDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-LogFileCreation {
  Measure-TestExecution -TestName "Logger creates timestamped log files" -Category "Logger" -TestBlock {
    # Arrange
    $testLogDir = "$env:TEMP\SmartShell-Test-Logs-Files"
    $testErrorDir = "$testLogDir\errors"

    # Clean up any existing test directories
    if (Test-Path $testLogDir) {
      Remove-Item $testLogDir -Recurse -Force
    }

    # Act
    Initialize-Logger -LogDirectory $testLogDir -ErrorDirectory $testErrorDir
    Write-InfoLog -Message "Test log entry" -Source "UnitTest"

    # Assert
    $logFiles = Get-ChildItem -Path $testLogDir -Filter "*.log"
    Assert-True ($logFiles.Count -gt 0) "At least one log file should be created"

    $logContent = Get-Content $logFiles[0].FullName -Raw
    Assert-True ($logContent.Contains("Test log entry")) "Log file should contain test entry"
    Assert-True ($logContent.Contains("SmartShell Logging Session")) "Log file should contain session header"

    # Cleanup
    Remove-Item $testLogDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-ErrorLogging {
  Measure-TestExecution -TestName "Error logs are written to error directory" -Category "Logger" -TestBlock {
    # Arrange
    $testLogDir = "$env:TEMP\SmartShell-Test-Logs-Error"
    $testErrorDir = "$testLogDir\errors"

    # Clean up any existing test directories
    if (Test-Path $testLogDir) {
      Remove-Item $testLogDir -Recurse -Force
    }

    # Act
    Initialize-Logger -LogDirectory $testLogDir -ErrorDirectory $testErrorDir
    Write-ErrorLog -ErrorMessage "Test error message" -Source "UnitTest"

    # Assert
    $errorFiles = Get-ChildItem -Path $testErrorDir -Filter "*.log"
    Assert-True ($errorFiles.Count -gt 0) "At least one error log file should be created"

    $errorContent = Get-Content $errorFiles[0].FullName -Raw
    Assert-True ($errorContent.Contains("Test error message")) "Error log should contain test error"
    Assert-True ($errorContent.Contains("[ERROR]")) "Error log should contain ERROR level"

    # Cleanup
    Remove-Item $testLogDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-LogRotation {
  Measure-TestExecution -TestName "Log rotation maintains maximum file count" -Category "Logger" -TestBlock {
    # Arrange
    $testLogDir = "$env:TEMP\SmartShell-Test-Logs-Rotation"

    # Clean up any existing test directories
    if (Test-Path $testLogDir) {
      Remove-Item $testLogDir -Recurse -Force
    }
    New-Item -Path $testLogDir -ItemType Directory -Force | Out-Null

    # Create 15 test log files
    for ($i = 1; $i -le 15; $i++) {
      $fileName = "test_log_$($i.ToString('D2')).log"
      Set-Content -Path (Join-Path $testLogDir $fileName) -Value "Test log $i" -Encoding UTF8
      Start-Sleep -Milliseconds 10  # Ensure different timestamps
    }

    # Act
    Remove-OldLogFiles -LogDirectory $testLogDir -MaxFiles 10

    # Assert
    $remainingFiles = Get-ChildItem -Path $testLogDir -Filter "*.log"
    Assert-Equal 10 $remainingFiles.Count "Should have exactly 10 files after rotation"

    # Cleanup
    Remove-Item $testLogDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}

# Run all tests
function Run-LoggerServiceTests {
  Initialize-TestEnvironment -TestCategory "Logger Service Unit Tests"

  Test-LoggerInitialization
  Test-LogFileCreation
  Test-ErrorLogging
  Test-LogRotation

  Export-TestResults -ShowSummary $true
}

# Execute tests if script is run directly
if ($MyInvocation.InvocationName -ne '.') {
  Run-LoggerServiceTests
}
