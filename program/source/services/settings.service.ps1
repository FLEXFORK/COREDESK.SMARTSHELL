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
      width          = 1000
      height         = 800
      startPosition  = "CenterScreen"
      resizable      = $false
      frameless      = $true
      customTitlebar = $true
    }
    application = @{
      version    = "1.0.1"
      name       = "SmartShell"
      showSplash = $true
    }
    theme       = @{
      current         = "catppuccin-frappe"
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

function Get-Theme {
  param(
    [string]$ThemeName = "",
    [string]$ThemePath = "$PSScriptRoot\..\configs\themes"
  )

  # Get current theme from settings if not specified
  if ([string]::IsNullOrEmpty($ThemeName)) {
    $settings = Get-AppSettings
    $ThemeName = $settings.theme.current
  }

  $themeFile = Join-Path $ThemePath "$ThemeName.json"

  try {
    if (Test-Path $themeFile) {
      $themeContent = Get-Content $themeFile -Raw
      $theme = $themeContent | ConvertFrom-Json
      return $theme
    }
    else {
      Write-Warning "Theme file not found: $themeFile"
      return Get-DefaultTheme
    }
  }
  catch {
    Write-Error "Failed to load theme: $($_.Exception.Message)"
    return Get-DefaultTheme
  }
}

function Get-DefaultTheme {
  return @{
    name   = "Default Dark"
    type   = "dark"
    colors = @{
      base     = "#1e1e2e"
      text     = "#cdd6f4"
      mauve    = "#cba6f7"
      mantle   = "#181825"
      surface0 = "#313244"
      surface1 = "#45475a"
      red      = "#f38ba8"
      yellow   = "#f9e2af"
    }
  }
}

function Get-ThemeColors {
  param(
    [object]$Theme
  )

  # Map theme colors to UI elements using appropriate Catppuccin colors
  return @{
    background     = $Theme.colors.base      # Main background
    foreground     = $Theme.colors.text      # Main text color
    accent         = $Theme.colors.mauve     # Accent color for highlights
    titlebar       = $Theme.colors.mantle    # Titlebar background
    surface        = $Theme.colors.surface0  # Surface elements
    border         = $Theme.colors.surface1  # Borders and outlines
    hover          = $Theme.colors.surface1  # Hover states
    closeButton    = $Theme.colors.red       # Close button danger color
    minimizeButton = $Theme.colors.yellow    # Minimize button warning color
  }
}

function Set-CurrentTheme {
  param(
    [string]$ThemeName
  )

  $settings = Get-AppSettings
  $settings.theme.current = $ThemeName
  return Set-AppSettings -Settings $settings
}

function ConvertFrom-HexString {
  param([string]$HexString)

  # Remove # if present
  $hex = $HexString -replace '^#', ''

  if ($hex.Length -eq 6) {
    $r = [Convert]::ToInt32($hex.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($hex.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($hex.Substring(4, 2), 16)
    return [System.Drawing.Color]::FromArgb($r, $g, $b)
  }
  return [System.Drawing.Color]::Black
}

function Get-AvailableThemes {
  param(
    [string]$ThemePath = "$PSScriptRoot\..\configs\themes"
  )

  $themes = @()
  if (Test-Path $ThemePath) {
    $themeFiles = Get-ChildItem -Path $ThemePath -Filter "*.json"
    foreach ($file in $themeFiles) {
      $themeName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
      try {
        $themeContent = Get-Content $file.FullName -Raw | ConvertFrom-Json
        $themes += @{
          id   = $themeName
          name = $themeContent.name
          type = $themeContent.type
          file = $file.Name
        }
      }
      catch {
        Write-Warning "Failed to load theme: $($file.Name)"
      }
    }
  }
  return $themes
}
