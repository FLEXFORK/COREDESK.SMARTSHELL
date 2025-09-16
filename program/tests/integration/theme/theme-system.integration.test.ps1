<#
.SYNOPSIS
    Integration tests for Theme System

.DESCRIPTION
    Integration test suite for theme system functionality including:
    - Theme loading and switching
    - Color mapping integration
    - Settings and theme interaction
    - Theme file validation

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: integration
#>

# Import required modules and dependencies
. "$PSScriptRoot\..\..\..\source\services\settings.service.ps1"
. "$PSScriptRoot\..\..\helpers\test-helpers.ps1"

function Test-ThemeSettingsIntegration {
  Measure-TestExecution -TestName "Theme switching updates settings correctly" -Category "Theme Integration" -TestBlock {
    # Arrange
    $testSettingsPath = "$env:TEMP\test-integration-settings.json"
    $initialSettings = New-TestSettings
    $initialSettings.theme.current = "initial-theme"
    $initialSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettingsPath -Encoding UTF8

    # Act
    $settings = Get-AppSettings -ConfigPath $testSettingsPath
    $settings.theme.current = "new-theme"
    $saveResult = Set-AppSettings -Settings $settings -ConfigPath $testSettingsPath

    # Verify the change persisted
    $updatedSettings = Get-AppSettings -ConfigPath $testSettingsPath

    # Assert
    Assert-True $saveResult "Settings save should succeed"
    Assert-Equal "new-theme" $updatedSettings.theme.current "Theme should be updated in settings"

    # Cleanup
    Remove-Item $testSettingsPath -Force -ErrorAction SilentlyContinue
  }
}

function Test-ThemeFileLoadingWithSettings {
  Measure-TestExecution -TestName "Theme files load correctly with settings integration" -Category "Theme Integration" -TestBlock {
    # Arrange
    $testThemePath = "$env:TEMP\test-integration-themes"
    $testSettingsPath = "$env:TEMP\test-integration-settings-theme.json"

    # Create test theme directory and file
    New-Item -Path $testThemePath -ItemType Directory -Force | Out-Null
    $mockTheme = New-MockTheme
    $mockTheme.name = "Integration Test Theme"
    $mockTheme | ConvertTo-Json -Depth 3 | Set-Content -Path "$testThemePath\integration-theme.json" -Encoding UTF8

    # Create test settings
    $testSettings = New-TestSettings
    $testSettings.theme.current = "integration-theme"
    $testSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $testSettingsPath -Encoding UTF8

    # Act
    $settings = Get-AppSettings -ConfigPath $testSettingsPath
    $currentThemeName = $settings.theme.current
    $loadedTheme = Get-Theme -ThemeName $currentThemeName -ThemePath $testThemePath

    # Assert
    Assert-Equal "integration-theme" $currentThemeName "Current theme name should match settings"
    Assert-NotNull $loadedTheme "Theme should load successfully"
    Assert-Equal "Integration Test Theme" $loadedTheme.name "Theme name should match"

    # Cleanup
    Remove-Item $testThemePath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $testSettingsPath -Force -ErrorAction SilentlyContinue
  }
}

function Test-ThemeColorMappingIntegration {
  Measure-TestExecution -TestName "Theme color mapping works with loaded themes" -Category "Theme Integration" -TestBlock {
    # Arrange
    $testThemePath = "$env:TEMP\test-color-mapping-themes"
    New-Item -Path $testThemePath -ItemType Directory -Force | Out-Null

    # Create a theme with specific colors
    $testTheme = @{
      name   = "Color Mapping Test"
      type   = "dark"
      colors = @{
        base     = "#1a1a1a"
        text     = "#e0e0e0"
        mauve    = "#c678dd"
        mantle   = "#0f0f0f"
        surface0 = "#2a2a2a"
        surface1 = "#3a3a3a"
        red      = "#e06c75"
        yellow   = "#e5c07b"
      }
    }

    $testTheme | ConvertTo-Json -Depth 3 | Set-Content -Path "$testThemePath\color-test.json" -Encoding UTF8

    # Act
    $loadedTheme = Get-Theme -ThemeName "color-test" -ThemePath $testThemePath
    $mappedColors = Get-ThemeColors -Theme $loadedTheme

    # Assert
    Assert-NotNull $mappedColors "Mapped colors should not be null"
    Assert-Equal "#1a1a1a" $mappedColors.background "Background should map to base"
    Assert-Equal "#e0e0e0" $mappedColors.foreground "Foreground should map to text"
    Assert-Equal "#c678dd" $mappedColors.accent "Accent should map to mauve"
    Assert-Equal "#0f0f0f" $mappedColors.titlebar "Titlebar should map to mantle"
    Assert-Equal "#e06c75" $mappedColors.closeButton "Close button should map to red"
    Assert-Equal "#e5c07b" $mappedColors.minimizeButton "Minimize button should map to yellow"

    # Cleanup
    Remove-Item $testThemePath -Recurse -Force -ErrorAction SilentlyContinue
  }
}

function Test-HexColorConversionIntegration {
  Measure-TestExecution -TestName "Hex color conversion works with theme colors" -Category "Theme Integration" -TestBlock {
    # Arrange
    $mockTheme = New-MockTheme
    $mappedColors = Get-ThemeColors -Theme $mockTheme

    # Act
    $backgroundColorObject = ConvertFrom-HexString -HexString $mappedColors.background
    $accentColorObject = ConvertFrom-HexString -HexString $mappedColors.accent

    # Assert
    Assert-NotNull $backgroundColorObject "Background color object should not be null"
    Assert-NotNull $accentColorObject "Accent color object should not be null"

    # Verify color components for black (#000000)
    Assert-Equal 0 $backgroundColorObject.R "Background red should be 0"
    Assert-Equal 0 $backgroundColorObject.G "Background green should be 0"
    Assert-Equal 0 $backgroundColorObject.B "Background blue should be 0"

    # Verify color components for purple (#800080)
    Assert-Equal 128 $accentColorObject.R "Accent red should be 128"
    Assert-Equal 0 $accentColorObject.G "Accent green should be 0"
    Assert-Equal 128 $accentColorObject.B "Accent blue should be 128"
  }
}

function Test-InvalidThemeHandling {
  Measure-TestExecution -TestName "Invalid theme files are handled gracefully" -Category "Theme Integration" -TestBlock {
    # Arrange
    $testThemePath = "$env:TEMP\test-invalid-themes"
    New-Item -Path $testThemePath -ItemType Directory -Force | Out-Null

    # Create invalid theme file
    Set-Content -Path "$testThemePath\invalid-theme.json" -Value "{ invalid json }" -Encoding UTF8

    # Act & Assert - Should fall back to default theme
    $loadedTheme = Get-Theme -ThemeName "invalid-theme" -ThemePath $testThemePath

    # Should get default theme
    Assert-NotNull $loadedTheme "Should return default theme for invalid file"
    Assert-True ($loadedTheme.ContainsKey("colors")) "Default theme should have colors property"

    # Cleanup
    Remove-Item $testThemePath -Recurse -Force -ErrorAction SilentlyContinue
  }
}

# Execute all tests
function Invoke-ThemeIntegrationTests {
  Initialize-TestEnvironment -TestCategory "Theme System Integration Tests"

  Test-ThemeSettingsIntegration
  Test-ThemeFileLoadingWithSettings
  Test-ThemeColorMappingIntegration
  Test-HexColorConversionIntegration
  Test-InvalidThemeHandling

  Export-TestResults -ShowSummary $true
}

# Execute tests if script is run directly
if ($MyInvocation.InvocationName -ne '.') {
  Invoke-ThemeIntegrationTests
}
