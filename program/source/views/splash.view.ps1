

<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC

#>


# --------------  CURRENT FILE  -------------- #
# /ROOTDIR//PROGRAM/SOURCE/VIEWS/SPLASH.VIEW.PS1
# ---------------  POWERSHELL  --------------- #


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-SplashScreen {
  param(
    [int]$Duration = 3000
  )

  # Create splash form
  $splashForm = New-Object System.Windows.Forms.Form
  $splashForm.Text = "SmartShell"
  $splashForm.Size = New-Object System.Drawing.Size(400, 250)
  $splashForm.StartPosition = "CenterScreen"
  $splashForm.FormBorderStyle = "None"
  $splashForm.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
  $splashForm.TopMost = $true

  # Create logo/title label
  $titleLabel = New-Object System.Windows.Forms.Label
  $titleLabel.Text = "SmartShell"
  $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
  $titleLabel.ForeColor = [System.Drawing.Color]::White
  $titleLabel.BackColor = [System.Drawing.Color]::Transparent
  $titleLabel.Size = New-Object System.Drawing.Size(350, 50)
  $titleLabel.Location = New-Object System.Drawing.Point(25, 70)
  $titleLabel.TextAlign = "MiddleCenter"

  # Create version label
  $versionLabel = New-Object System.Windows.Forms.Label
  $versionLabel.Text = "Version 1.0.0"
  $versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
  $versionLabel.ForeColor = [System.Drawing.Color]::LightGray
  $versionLabel.BackColor = [System.Drawing.Color]::Transparent
  $versionLabel.Size = New-Object System.Drawing.Size(350, 20)
  $versionLabel.Location = New-Object System.Drawing.Point(25, 130)
  $versionLabel.TextAlign = "MiddleCenter"

  # Create loading label
  $loadingLabel = New-Object System.Windows.Forms.Label
  $loadingLabel.Text = "Loading..."
  $loadingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
  $loadingLabel.ForeColor = [System.Drawing.Color]::Gray
  $loadingLabel.BackColor = [System.Drawing.Color]::Transparent
  $loadingLabel.Size = New-Object System.Drawing.Size(350, 20)
  $loadingLabel.Location = New-Object System.Drawing.Point(25, 180)
  $loadingLabel.TextAlign = "MiddleCenter"

  # Add controls to form
  $splashForm.Controls.Add($titleLabel)
  $splashForm.Controls.Add($versionLabel)
  $splashForm.Controls.Add($loadingLabel)

  # Show splash and auto-close after duration
  $splashForm.Show()
  Start-Sleep -Milliseconds $Duration
  $splashForm.Close()
  $splashForm.Dispose()
}
