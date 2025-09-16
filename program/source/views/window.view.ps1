

<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC

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

  # Create main form
  $mainForm = New-Object System.Windows.Forms.Form
  $mainForm.Text = if ($RandomMode) { "SmartShell - Random Mode" } else { "SmartShell" }
  $mainForm.Size = New-Object System.Drawing.Size(1400, 900)
  $mainForm.StartPosition = "CenterScreen"
  $mainForm.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
  $mainForm.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
  $mainForm.MinimumSize = New-Object System.Drawing.Size(1200, 700)

  # Create main content area (blank)
  $mainContent = New-Object System.Windows.Forms.Panel
  $mainContent.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
  $mainContent.Dock = "Fill"

  # Add components to form
  $mainForm.Controls.Add($mainContent)

  # Show the form
  $mainForm.ShowDialog()
}
