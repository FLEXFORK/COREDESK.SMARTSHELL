<#
.SYNOPSIS
    Unit tests for Settings Service

.DESCRIPTION
    Comprehensive test suite for settings.service.ps1 functionality including:
    - Settings loading and saving
    - Theme management
    - Configuration validation
    - Default settings handling

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: unit
#>

# Import required modules and dependencies
. "$PSScriptRoot\..\..\..\source\services\settings.service.ps1"
. "$PSScriptRoot\..\..\helpers\test-helpers.ps1"

function Test-SettingsLoading {
  Measure-TestExecution -TestName "Settings service loads configuration from file" -Category "Settings" -TestBlock {
    # Arrange
    $testSettingsPath = "$env:TEMP\test-settings.json"
    $testSettings = @{
      window      = @{
        width  = 1200
        height = 900
      }
      application = @{
        version = "1.0.2"
        name    = "TestApp"
      }
    }

    $testSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettingsPath -Encoding UTF8

    # Act
    $loadedSettings = Get-AppSettings -ConfigPath $testSettingsPath

    # Assert
    Assert-NotNull $loadedSettings "Settings should not be null"
    Assert-Equal 1200 $loadedSettings.window.width "Window width should match"
    Assert-Equal "TestApp" $loadedSettings.application.name "Application name should match"

    # Cleanup
    Remove-Item $testSettingsPath -Force -ErrorAction SilentlyContinue
  }
}

function Test-SettingsSaving {
  Measure-TestExecution -TestName "Settings service saves configuration to file" -Category "Settings" -TestBlock {
    # Arrange
    $testSettingsPath = "$env:TEMP\test-settings-save.json"
    $testSettings = New-TestSettings

    # Act
    $result = Set-AppSettings -Settings $testSettings -ConfigPath $testSettingsPath

    # Assert
    Assert-True $result "Settings save should return true"
    Assert-FileExists $testSettingsPath "Settings file should be created"

    $savedContent = Get-Content $testSettingsPath -Raw | ConvertFrom-Json
    Assert-Equal $testSettings.window.width $savedContent.window.width "Saved width should match"

    # Cleanup
    Remove-Item $testSettingsPath -Force -ErrorAction SilentlyContinue
  }
}

function Test-DefaultSettings {
  Measure-TestExecution -TestName "Default settings are returned when file missing" -Category "Settings" -TestBlock {
    # Arrange
    $nonExistentPath = "$env:TEMP\non-existent-settings.json"

    # Act
    $settings = Get-AppSettings -ConfigPath $nonExistentPath

    # Assert
    Assert-NotNull $settings "Default settings should not be null"
    Assert-True ($settings.ContainsKey("window")) "Should contain window settings"
    Assert-True ($settings.ContainsKey("application")) "Should contain application settings"
    Assert-Equal "1.0.2" $settings.application.version "Should have correct version"
  }
}

function Test-ThemeLoading {
  Measure-TestExecution -TestName "Theme service loads theme configuration" -Category "Settings" -TestBlock {
    # Arrange
    $testThemePath = "$env:TEMP\test-theme"
    $testThemeFile = "$testThemePath\test-theme.json"
    New-Item -Path $testThemePath -ItemType Directory -Force | Out-Null

    $mockTheme = New-MockTheme
    $mockTheme | ConvertTo-Json -Depth 3 | Set-Content -Path $testThemeFile -Encoding UTF8

    # Act
    $loadedTheme = Get-Theme -ThemeName "test-theme" -ThemePath $testThemePath

    # Assert
    Assert-NotNull $loadedTheme "Theme should not be null"
    Assert-Equal "Test Theme" $loadedTheme.name "Theme name should match"
    Assert-Equal "dark" $loadedTheme.type "Theme type should match"

    # Cleanup
    Remove-Item $testThemePath -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-ThemeColorMapping {
  Measure-TestExecution -TestName "Theme color mapping returns correct UI colors" -Category "Settings" -TestBlock {
    # Arrange
    $mockTheme = New-MockTheme

    # Act
    $themeColors = Get-ThemeColors -Theme $mockTheme

    # Assert
    Assert-NotNull $themeColors "Theme colors should not be null"
    Assert-Equal "#000000" $themeColors.background "Background should map to base color"
    Assert-Equal "#ffffff" $themeColors.foreground "Foreground should map to text color"
    Assert-Equal "#800080" $themeColors.accent "Accent should map to mauve color"
    Assert-Equal "#ff0000" $themeColors.closeButton "Close button should map to red color"
    Assert-Equal "#ffff00" $themeColors.minimizeButton "Minimize button should map to yellow color"
  }
}

function Test-HexColorConversion {
  Measure-TestExecution -TestName "Hex color strings convert to Color objects" -Category "Settings" -TestBlock {
    # Arrange
    $hexColor = "#ff0000"

    # Act
    $colorObject = ConvertFrom-HexString -HexString $hexColor

    # Assert
    Assert-NotNull $colorObject "Color object should not be null"
    Assert-Equal 255 $colorObject.R "Red component should be 255"
    Assert-Equal 0 $colorObject.G "Green component should be 0"
    Assert-Equal 0 $colorObject.B "Blue component should be 0"
  }
}

# Run all tests
function Run-SettingsServiceTests {
  Initialize-TestEnvironment -TestCategory "Settings Service Unit Tests"

  Test-SettingsLoading
  Test-SettingsSaving
  Test-DefaultSettings
  Test-ThemeLoading
  Test-ThemeColorMapping
  Test-HexColorConversion

  Export-TestResults -ShowSummary $true
}

# Execute tests if script is run directly
if ($MyInvocation.InvocationName -ne '.') {
  Run-SettingsServiceTests
}
