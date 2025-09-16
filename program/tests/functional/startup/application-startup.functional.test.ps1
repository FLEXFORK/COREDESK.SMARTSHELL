<#
.SYNOPSIS
    Functional tests for SmartShell Application Startup

.DESCRIPTION
    End-to-end functional test suite for SmartShell startup sequence including:
    - Service initialization
    - Settings loading
    - Theme application
    - Logger setup
    - Application readiness

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: functional
#>

# Import required modules and dependencies
. "$PSScriptRoot\..\..\..\smartshell.ps1"
. "$PSScriptRoot\..\..\helpers\test-helpers.ps1"

function Test-ApplicationStartupSequence {
  Measure-TestExecution -TestName "Complete application startup sequence" -Category "Functional" -TestBlock {
    # Arrange
    $testDirectory = "$env:TEMP\smartshell-functional-test"
    $testSettings = "$testDirectory\settings.json"
    $testLogs = "$testDirectory\logs"

    # Create test environment
    New-Item -Path $testDirectory -ItemType Directory -Force | Out-Null
    New-Item -Path $testLogs -ItemType Directory -Force | Out-Null

    # Create test settings file
    $defaultSettings = @{
      version = "1.0.2"
      theme   = @{
        current = "catppuccin-mocha"
        path    = "$PSScriptRoot\..\..\..\source\configs\themes"
      }
      window  = @{
        width           = 800
        height          = 600
        startupPosition = "CenterScreen"
      }
      logging = @{
        enabled  = $true
        path     = $testLogs
        level    = "INFO"
        maxFiles = 5
      }
    }

    $defaultSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettings -Encoding UTF8

    # Act - This is a simulation of startup without actually showing the GUI
    try {
      # Test settings loading
      $settings = Get-AppSettings -ConfigPath $testSettings
      Assert-NotNull $settings "Settings should load successfully"

      # Test theme loading
      $theme = Get-Theme -ThemeName $settings.theme.current -ThemePath $settings.theme.path
      Assert-NotNull $theme "Theme should load successfully"

      # Test color mapping
      $colors = Get-ThemeColors -Theme $theme
      Assert-NotNull $colors "Theme colors should map successfully"

      # Test logger initialization
      $logInitResult = Initialize-Logger -LogDirectory $settings.logging.path
      Assert-True $logInitResult "Logger should initialize successfully"

      # Test writing a startup log entry
      Write-LogEntry -Level "INFO" -Message "Application startup test completed"

      # Test that log file was created
      $logFiles = Get-ChildItem -Path $settings.logging.path -Filter "smartshell_*.log"
      Assert-True ($logFiles.Count -gt 0) "Log file should be created"

      # Verify log entry was written
      $logContent = Get-Content -Path $logFiles[0].FullName -Raw
      Assert-True ($logContent -like "*Application startup test completed*") "Log entry should be written to file"    
    }
    catch {
      throw "Startup sequence failed: $($_.Exception.Message)"
    }
    finally {
      # Cleanup
      Remove-Item $testDirectory -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
}

function Test-SettingsVersionCompatibility {
  Measure-TestExecution -TestName "Settings version compatibility check" -Category "Functional" -TestBlock {
    # Arrange
    $testDirectory = "$env:TEMP\smartshell-version-test"
    $testSettings = "$testDirectory\settings.json"

    New-Item -Path $testDirectory -ItemType Directory -Force | Out-Null

    # Create settings with older version
    $oldSettings = @{
      version = "1.0.1"
      theme   = @{ current = "catppuccin-mocha" }
      window  = @{ width = 800; height = 600 }
    }

    $oldSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettings -Encoding UTF8

    # Act
    $loadedSettings = Get-AppSettings -ConfigPath $testSettings

    # Assert
    Assert-NotNull $loadedSettings "Settings with older version should load"
    Assert-Equal "1.0.1" $loadedSettings.version "Version should remain as loaded"

    # Cleanup
    Remove-Item $testDirectory -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-ThemeFallbackMechanism {
  Measure-TestExecution -TestName "Theme fallback to default when theme not found" -Category "Functional" -TestBlock {
    # Arrange
    $testDirectory = "$env:TEMP\smartshell-theme-fallback-test"
    $testSettings = "$testDirectory\settings.json"
    $testThemes = "$testDirectory\themes"

    New-Item -Path $testDirectory -ItemType Directory -Force | Out-Null
    New-Item -Path $testThemes -ItemType Directory -Force | Out-Null

    # Create settings pointing to non-existent theme
    $settings = @{
      version = "1.0.2"
      theme   = @{
        current = "non-existent-theme"
        path    = $testThemes
      }
    }

    $settings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettings -Encoding UTF8

    # Act
    $loadedSettings = Get-AppSettings -ConfigPath $testSettings
    $theme = Get-Theme -ThemeName $loadedSettings.theme.current -ThemePath $loadedSettings.theme.path

    # Assert
    Assert-NotNull $theme "Should return default theme when requested theme not found"
    Assert-True ($theme.ContainsKey("colors")) "Default theme should have colors"

    # Test that we can still get colors from default theme
    $colors = Get-ThemeColors -Theme $theme
    Assert-NotNull $colors "Should be able to get colors from default theme"

    # Cleanup
    Remove-Item $testDirectory -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-LoggingSystemIntegration {
  Measure-TestExecution -TestName "Logging system integration with application" -Category "Functional" -TestBlock {
    # Arrange
    $testDirectory = "$env:TEMP\smartshell-logging-integration-test"
    $testLogs = "$testDirectory\logs"

    New-Item -Path $testDirectory -ItemType Directory -Force | Out-Null
    New-Item -Path $testLogs -ItemType Directory -Force | Out-Null

    # Act
    $initResult = Initialize-Logger -LogDirectory $testLogs

    # Test various log levels
    Write-LogEntry -Level "INFO" -Message "Test info message"
    Write-LogEntry -Level "WARN" -Message "Test warning message"
    Write-LogEntry -Level "ERROR" -Message "Test error message"    # Assert
    Assert-True $initResult "Logger should initialize successfully"

    # Verify log file exists and contains entries
    $logFiles = Get-ChildItem -Path $testLogs -Filter "smartshell_*.log"
    Assert-True ($logFiles.Count -gt 0) "Log files should be created"

    $logContent = Get-Content -Path $logFiles[0].FullName -Raw
    Assert-True ($logContent -like "*Test info message*") "Info message should be logged"
    Assert-True ($logContent -like "*Test warning message*") "Warning message should be logged"
    Assert-True ($logContent -like "*Test error message*") "Error message should be logged"

    # Cleanup
    Remove-Item $testDirectory -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-CompleteWorkflowSimulation {
  Measure-TestExecution -TestName "Complete application workflow simulation" -Category "Functional" -TestBlock {
    # This test simulates a complete user workflow without showing GUI

    # Arrange
    $testDirectory = "$env:TEMP\smartshell-workflow-test"
    $testSettings = "$testDirectory\settings.json"
    $testLogs = "$testDirectory\logs"
    $testThemes = "$PSScriptRoot\..\..\..\source\configs\themes"

    New-Item -Path $testDirectory -ItemType Directory -Force | Out-Null
    New-Item -Path $testLogs -ItemType Directory -Force | Out-Null

    # Create complete settings
    $workflowSettings = @{
      version = "1.0.2"
      theme   = @{
        current = "catppuccin-mocha"
        path    = $testThemes
      }
      window  = @{
        width           = 1024
        height          = 768
        startupPosition = "CenterScreen"
      }
      logging = @{
        enabled  = $true
        path     = $testLogs
        level    = "INFO"
        maxFiles = 10
      }
    }

    $workflowSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettings -Encoding UTF8

    # Act - Simulate complete workflow
    try {
      # 1. Load settings
      $settings = Get-AppSettings -ConfigPath $testSettings
      Write-LogEntry -Level "INFO" -Message "Settings loaded successfully"

      # 2. Initialize logger
      $logInit = Initialize-Logger -LogDirectory $settings.logging.path
      Write-LogEntry -Level "INFO" -Message "Logger initialized"

      # 3. Load theme
      $theme = Get-Theme -ThemeName $settings.theme.current -ThemePath $settings.theme.path
      Write-LogEntry -Level "INFO" -Message "Theme loaded: $($settings.theme.current)"

      # 4. Apply theme colors
      $colors = Get-ThemeColors -Theme $theme
      Write-LogEntry -Level "INFO" -Message "Theme colors applied"

      # 5. Simulate theme change
      $settings.theme.current = "catppuccin-frappe"
      $saveResult = Set-AppSettings -Settings $settings -ConfigPath $testSettings
      Write-LogEntry -Level "INFO" -Message "Theme changed to catppuccin-frappe"

      # 6. Load new theme
      $newTheme = Get-Theme -ThemeName $settings.theme.current -ThemePath $settings.theme.path
      $newColors = Get-ThemeColors -Theme $newTheme
      Write-LogEntry -Level "INFO" -Message "New theme applied successfully"      # Assert all steps completed successfully
      Assert-NotNull $settings "Settings should load"
      Assert-True $logInit "Logger should initialize"
      Assert-NotNull $theme "Initial theme should load"
      Assert-NotNull $colors "Initial colors should map"
      Assert-True $saveResult "Settings should save"
      Assert-NotNull $newTheme "New theme should load"
      Assert-NotNull $newColors "New colors should map"

      # Verify log entries were created
      $logFiles = Get-ChildItem -Path $settings.logging.path -Filter "smartshell_*.log"
      Assert-True ($logFiles.Count -gt 0) "Log files should exist"

      $logContent = Get-Content -Path $logFiles[0].FullName -Raw
      Assert-True ($logContent -like "*Settings loaded successfully*") "Settings log entry should exist"
      Assert-True ($logContent -like "*Theme changed to catppuccin-frappe*") "Theme change log should exist"

    }
    catch {
      throw "Workflow simulation failed: $($_.Exception.Message)"
    }
    finally {
      # Cleanup
      Remove-Item $testDirectory -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
}

# Execute all tests
function Invoke-ApplicationFunctionalTests {
  Initialize-TestEnvironment -TestCategory "SmartShell Application Functional Tests"

  Test-ApplicationStartupSequence
  Test-SettingsVersionCompatibility
  Test-ThemeFallbackMechanism
  Test-LoggingSystemIntegration
  Test-CompleteWorkflowSimulation

  Export-TestResults -ShowSummary $true
}

# Execute tests if script is run directly
if ($MyInvocation.InvocationName -ne '.') {
  Invoke-ApplicationFunctionalTests
}
