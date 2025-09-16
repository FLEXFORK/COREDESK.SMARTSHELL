
param(
  [switch]$ran,
  [switch]$NoSplash
)

# Add Windows Forms support
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC

#>


# --------  CURRENT FILE  ------ #
# /ROOTDIR//PROGRAM/SMARTSHELL.PS1
# ---------  POWERSHELL  ------- #

# Set working directory to script location
Set-Location $PSScriptRoot

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
    if ($ShowSplash) {
      Write-Host "Starting SmartShell with splash screen..." -ForegroundColor Green

      # Initialize splash logic (loading, config, etc.)
      $splashReady = Initialize-SplashLogic

      if ($splashReady) {
        # Show splash screen
        $duration = Get-SplashDuration
        Show-SplashScreen -Duration $duration
      }
    }

    Write-Host "Launching main window..." -ForegroundColor Green

    # Launch main window
    Show-MainWindow -RandomMode $RandomMode

    Write-Host "SmartShell started successfully!" -ForegroundColor Cyan

  }
  catch {
    Write-Error "Failed to start SmartShell: $($_.Exception.Message)"
    exit 1
  }
}

# Main execution
if ($ran) {
  Start-SmartShell -ShowSplash (!$NoSplash) -RandomMode $true
}
else {
  Start-SmartShell -ShowSplash (!$NoSplash) -RandomMode $false
}


