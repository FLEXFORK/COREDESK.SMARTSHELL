<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC
- SETTINGS.SERVICE.PS1 HANDLES APPLICATION SETTINGS

#>


# ---------------  CURRENT FILE  ---------------------- #
# /ROOTDIR//PROGRAM/SOURCE/SERVICESS/SETTINGS.SERVICE.PS1
# ----------------  POWERSHELL  ----------------------- #

# Add required assemblies for color handling
Add-Type -AssemblyName System.Drawing

function Get-AppSettings {
  param(
    [string]$ConfigPath = "$PSScriptRoot\..\configs\settings.json"
  )

  try {
    if (Test-Path $ConfigPath) {
      $settingsContent = Get-Content $ConfigPath -Raw
      $settings = $settingsContent | ConvertFrom-Json
      return $settings
    }
    else {
      Write-Warning "Settings file not found at: $ConfigPath"
      return Get-DefaultSettings
    }
  }
  catch {
    Write-Error "Failed to load settings: $($_.Exception.Message)"
    return Get-DefaultSettings
  }
}

function Set-AppSettings {
  param(
    [object]$Settings,
    [string]$ConfigPath = "$PSScriptRoot\..\configs\settings.json"
  )

  try {
    $settingsJson = $Settings | ConvertTo-Json -Depth 10
    Set-Content -Path $ConfigPath -Value $settingsJson -Encoding UTF8
    Write-Host "Settings saved successfully" -ForegroundColor Green
    return $true
  }
  catch {
    Write-Error "Failed to save settings: $($_.Exception.Message)"
    return $false
  }
}

function Get-DefaultSettings {
  return @{
    window      = @{
      width         = 800
      height        = 600
      startPosition = "CenterScreen"
      resizable     = $false
    }
    application = @{
      version    = "1.0.1"
      name       = "SmartShell"
      showSplash = $true
    }
    theme       = @{
      backgroundColor = "rgb(15,15,15)"
      foregroundColor = "rgb(240,240,240)"
      accentColor     = "rgb(168,85,247)"
    }
  }
}

function Get-WindowSettings {
  $settings = Get-AppSettings
  return $settings.window
}

function Set-WindowSettings {
  param(
    [int]$Width,
    [int]$Height,
    [string]$StartPosition = "CenterScreen",
    [bool]$Resizable = $false
  )

  $settings = Get-AppSettings
  $settings.window.width = $Width
  $settings.window.height = $Height
  $settings.window.startPosition = $StartPosition
  $settings.window.resizable = $Resizable

  return Set-AppSettings -Settings $settings
}

function ConvertFrom-RgbString {
  param([string]$RgbString)

  if ($RgbString -match 'rgb\((\d+),(\d+),(\d+)\)') {
    return [System.Drawing.Color]::FromArgb([int]$Matches[1], [int]$Matches[2], [int]$Matches[3])
  }
  return [System.Drawing.Color]::Black
}

function Update-WindowSettings {
  param(
    [int]$Width,
    [int]$Height
  )

  Write-Host "Updating window settings: ${Width}x${Height}" -ForegroundColor Yellow
  return Set-WindowSettings -Width $Width -Height $Height
}


