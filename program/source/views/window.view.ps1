

<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC

#>


# --------------  CURRENT FILE  -------------- #
# /ROOTDIR//PROGRAM/SOURCE/VIEWS/WINDOW.VIEW.PS1
# ---------------  POWERSHELL  --------------- #

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-MainWindow {
  param(
    [bool]$RandomMode = $false
  )

  # Create main form
  $mainForm = New-Object System.Windows.Forms.Form
  $mainForm.Text = if ($RandomMode) { "SmartShell - Random Mode" } else { "SmartShell" }
  $mainForm.Size = New-Object System.Drawing.Size(800, 600)
  $mainForm.StartPosition = "CenterScreen"
  $mainForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
  $mainForm.ForeColor = [System.Drawing.Color]::White
  $mainForm.MinimumSize = New-Object System.Drawing.Size(600, 400)

  # Show the form
  $mainForm.ShowDialog()
}
