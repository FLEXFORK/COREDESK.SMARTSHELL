<#
.SYNOPSIS
    Verification test for window settings changes

.DESCRIPTION
    Tests to verify that window dimensions have been correctly updated to 800x600
    and that the settings are properly loaded from both default settings and config file.

.NOTES
    Created: 2025-09-16
    Version: 1.0.1
    Category: unit
#>

# Import required modules and dependencies
. "$PSScriptRoot\..\..\source\services\settings.service.ps1"
. "$PSScriptRoot\..\helpers\test-helpers.ps1"

function Test-DefaultWindowDimensions {
  Measure-TestExecution -TestName "Default window settings use 800x600 dimensions" -Category "WindowSettings" -TestBlock {
    # Act
    $defaultSettings = Get-DefaultSettings

    # Assert
    Assert-Equal 800 $defaultSettings.window.width "Default width should be 800"
    Assert-Equal 600 $defaultSettings.window.height "Default height should be 600"
    Assert-Equal "CenterScreen" $defaultSettings.window.startPosition "Default position should be CenterScreen"
  }
}

function Test-ConfigFileWindowDimensions {
  Measure-TestExecution -TestName "Config file contains 800x600 dimensions" -Category "WindowSettings" -TestBlock {
    # Act
    $settings = Get-AppSettings

    # Assert
    Assert-Equal 800 $settings.window.width "Config width should be 800"
    Assert-Equal 600 $settings.window.height "Config height should be 600"
    Assert-Equal "CenterScreen" $settings.window.startPosition "Config position should be CenterScreen"
  }
}

function Test-WindowSettingsFunction {
  Measure-TestExecution -TestName "Get-WindowSettings returns correct dimensions" -Category "WindowSettings" -TestBlock {
    # Act
    $windowSettings = Get-WindowSettings

    # Assert
    Assert-Equal 800 $windowSettings.width "Window settings width should be 800"
    Assert-Equal 600 $windowSettings.height "Window settings height should be 600"
    Assert-Equal "CenterScreen" $windowSettings.startPosition "Window settings position should be CenterScreen"
  }
}

function Test-WindowSizeUpdate {
  Measure-TestExecution -TestName "Window settings can be updated programmatically" -Category "WindowSettings" -TestBlock {
    # Arrange
    $originalSettings = Get-AppSettings
    $originalWidth = $originalSettings.window.width
    $originalHeight = $originalSettings.window.height

    # Act - Test the update function
    $result = Set-WindowSettings -Width 1024 -Height 768

    # Assert the function completed successfully
    Assert-True $result "Set-WindowSettings should return true on success"

    # Restore original settings for cleanup
    Set-WindowSettings -Width $originalWidth -Height $originalHeight
  }
}

# Run all tests
Test-DefaultWindowDimensions
Test-ConfigFileWindowDimensions
Test-WindowSettingsFunction
Test-WindowSizeUpdate

# Export test results
Export-TestResults