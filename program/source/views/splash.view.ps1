<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC
- SETTINGS.SERVICE.PS1 HANDLES APPLICATION SETTINGS

#>


# --------------  CURRENT FILE  -------------- #
# /ROOTDIR//PROGRAM/SOURCE/VIEWS/SPLASH.VIEW.PS1
# ---------------  POWERSHELL  --------------- #


# Add Windows Forms support
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-SplashScreen {
  param(
    [int]$Duration = 3000
  )

  # Create splash form
  $splashForm = New-Object System.Windows.Forms.Form
  $splashForm.Text = "SmartShell"
  $splashForm.Size = New-Object System.Drawing.Size(500, 320)
  $splashForm.StartPosition = "CenterScreen"
  $splashForm.FormBorderStyle = "None"
  $splashForm.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
  $splashForm.TopMost = $true

  # Create main panel with flat border
  $mainPanel = New-Object System.Windows.Forms.Panel
  $mainPanel.Size = New-Object System.Drawing.Size(498, 318)
  $mainPanel.Location = New-Object System.Drawing.Point(1, 1)
  $mainPanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
  $mainPanel.BorderStyle = "FixedSingle"

  # Create accent bar
  $accentBar = New-Object System.Windows.Forms.Panel
  $accentBar.Size = New-Object System.Drawing.Size(498, 4)
  $accentBar.Location = New-Object System.Drawing.Point(0, 0)
  $accentBar.BackColor = [System.Drawing.Color]::FromArgb(168, 85, 247)

  # Create logo/title label
  $titleLabel = New-Object System.Windows.Forms.Label
  $titleLabel.Text = "SmartShell"
  $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
  $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
  $titleLabel.BackColor = [System.Drawing.Color]::Transparent
  $titleLabel.Size = New-Object System.Drawing.Size(450, 60)
  $titleLabel.Location = New-Object System.Drawing.Point(25, 90)
  $titleLabel.TextAlign = "MiddleCenter"

  # Create version label with accent
  $versionLabel = New-Object System.Windows.Forms.Label
  $versionLabel.Text = "Version 1.0.1"
  $versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
  $versionLabel.ForeColor = [System.Drawing.Color]::FromArgb(168, 85, 247)
  $versionLabel.BackColor = [System.Drawing.Color]::Transparent
  $versionLabel.Size = New-Object System.Drawing.Size(450, 30)
  $versionLabel.Location = New-Object System.Drawing.Point(25, 160)
  $versionLabel.TextAlign = "MiddleCenter"

  # Create loading label
  $loadingLabel = New-Object System.Windows.Forms.Label
  $loadingLabel.Text = "LOADING..."
  $loadingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
  $loadingLabel.ForeColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
  $loadingLabel.BackColor = [System.Drawing.Color]::Transparent
  $loadingLabel.Size = New-Object System.Drawing.Size(450, 30)
  $loadingLabel.Location = New-Object System.Drawing.Point(25, 220)
  $loadingLabel.TextAlign = "MiddleCenter"

  # Create progress indicator (flat style)
  $progressPanel = New-Object System.Windows.Forms.Panel
  $progressPanel.Size = New-Object System.Drawing.Size(200, 3)
  $progressPanel.Location = New-Object System.Drawing.Point(150, 270)
  $progressPanel.BackColor = [System.Drawing.Color]::FromArgb(168, 85, 247)

  # Add controls to panels
  $mainPanel.Controls.Add($accentBar)
  $mainPanel.Controls.Add($titleLabel)
  $mainPanel.Controls.Add($versionLabel)
  $mainPanel.Controls.Add($loadingLabel)
  $mainPanel.Controls.Add($progressPanel)
  $splashForm.Controls.Add($mainPanel)

  # Show splash and auto-close after duration
  $splashForm.Show()
  Start-Sleep -Milliseconds $Duration
  $splashForm.Close()
  $splashForm.Dispose()
}
