<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC
- SETTINGS.SERVICE.PS1 HANDLES APPLICATION SETTINGS

#>


# --------  CURRENT FILE  ------ #
# /ROOTDIR//PROGRAM/SMARTSHELL.PS1
# ---------  POWERSHELL  ------- #

param(
  [switch]$ran,
  [switch]$NoSplash
)

# Add Windows Forms support
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set working directory to script location
Set-Location $PSScriptRoot

# Load settings service
. "source\services\settings.service.ps1"

# Load logger service
. "source\services\logger.service.ps1"

# Load splash components
. "source\views\splash.view.ps1"
. "source\scripts\splash.script.ps1"

# Load main window components
. "source\views\window.view.ps1"
. "source\scripts\window.script.ps1"

function Start-SmartShell {
  param(
    [bool]$ShowSplash = $true,
    [bool]$RandomMode = $false
  )

  try {
    # Log application startup
    Write-InfoLog "SmartShell application starting" -Source "Main"
    Write-InfoLog "Parameters: ShowSplash=$ShowSplash, RandomMode=$RandomMode" -Source "Main"

    if ($ShowSplash) {
      Write-Host "Starting SmartShell with splash screen..." -ForegroundColor Green
      Write-InfoLog "Starting with splash screen" -Source "Main"

      # Initialize splash logic (loading, config, etc.)
      $splashReady = Initialize-SplashLogic

      if ($splashReady) {
        # Show splash screen
        $duration = Get-SplashDuration
        Write-InfoLog "Showing splash screen for $duration seconds" -Source "Splash"
        Show-SplashScreen -Duration $duration
      }
    }

    Write-Host "Launching main window..." -ForegroundColor Green
    Write-InfoLog "Launching main window" -Source "Main"

    # Launch main window
    Show-MainWindow -RandomMode $RandomMode

    Write-Host "SmartShell started successfully!" -ForegroundColor Cyan
    Write-InfoLog "SmartShell started successfully" -Source "Main"

  }
  catch {
    $errorMsg = "Failed to start SmartShell: $($_.Exception.Message)"
    Write-Error $errorMsg
    Write-ErrorLog -ErrorMessage $errorMsg -Exception $_.Exception -CallStack $_.ScriptStackTrace -Source "Main"
    exit 1
  }
  finally {
    # Close logger session when application ends
    Write-InfoLog "SmartShell application ending" -Source "Main"
    Close-Logger
  }
}

# Main execution
Write-InfoLog "SmartShell entry point reached" -Source "Main"
Write-InfoLog "Command line arguments: ran=$ran, NoSplash=$NoSplash" -Source "Main"

if ($ran) {
  Write-InfoLog "Starting in random mode" -Source "Main"
  Start-SmartShell -ShowSplash (!$NoSplash) -RandomMode $true
}
else {
  Write-InfoLog "Starting in normal mode" -Source "Main"
  Start-SmartShell -ShowSplash (!$NoSplash) -RandomMode $false
}


