<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC
- SETTINGS.SERVICE.PS1 HANDLES APPLICATION SETTINGS

#>


# --------------  CURRENT FILE  -------------- #
# /ROOTDIR//PROGRAM/SOURCE/VIEWS/WINDOW.VIEW.PS1
# ---------------  POWERSHELL  --------------- #

# Add Windows Forms support
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-MainWindow {
  param(
    [bool]$RandomMode = $false
  )

  # Load window settings from configuration
  $windowSettings = Get-WindowSettings
  $settings = Get-AppSettings

  # Parse colors from settings
  $backgroundColor = ConvertFrom-RgbString $settings.theme.backgroundColor
  $foregroundColor = ConvertFrom-RgbString $settings.theme.foregroundColor

  # Create main form
  $mainForm = New-Object System.Windows.Forms.Form
  $mainForm.Text = if ($RandomMode) { "$($settings.application.name) - Random Mode" } else { $settings.application.name }
  $mainForm.Size = New-Object System.Drawing.Size($windowSettings.width, $windowSettings.height)
  $mainForm.StartPosition = $windowSettings.startPosition
  $mainForm.BackColor = $backgroundColor
  $mainForm.ForeColor = $foregroundColor
  $mainForm.FormBorderStyle = "FixedSingle"
  $mainForm.MaximizeBox = $false

  # Create main content area (blank)
  $mainContent = New-Object System.Windows.Forms.Panel
  $mainContent.BackColor = $backgroundColor
  $mainContent.Dock = "Fill"

  # Add components to form
  $mainForm.Controls.Add($mainContent)

  # Show the form
  $mainForm.ShowDialog()
}
