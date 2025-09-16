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

  # Load current theme
  $theme = Get-Theme

  # Parse colors from theme
  $backgroundColor = ConvertFrom-HexString $theme.application.background
  $foregroundColor = ConvertFrom-HexString $theme.application.foreground
  $titlebarColor = ConvertFrom-HexString $theme.application.titlebar
  $hoverColor = ConvertFrom-HexString $theme.application.hover
  $closeButtonColor = ConvertFrom-HexString $theme.application.closeButton
  $minimizeButtonColor = ConvertFrom-HexString $theme.application.minimizeButton  # Create main form (frameless)
  $mainForm = New-Object System.Windows.Forms.Form
  $mainForm.Text = if ($RandomMode) { "$($settings.application.name) - Random Mode" } else { $settings.application.name }
  $mainForm.Size = New-Object System.Drawing.Size($windowSettings.width, $windowSettings.height)
  $mainForm.StartPosition = $windowSettings.startPosition
  $mainForm.BackColor = $backgroundColor
  $mainForm.ForeColor = $foregroundColor
  $mainForm.FormBorderStyle = "None"
  $mainForm.TopMost = $false

  # Create custom titlebar panel
  $titleBar = New-Object System.Windows.Forms.Panel
  $titleBar.Size = New-Object System.Drawing.Size($windowSettings.width, 35)
  $titleBar.Location = New-Object System.Drawing.Point(0, 0)
  $titleBar.BackColor = $titlebarColor
  $titleBar.Dock = "Top"

  # Create title label
  $titleLabel = New-Object System.Windows.Forms.Label
  $titleLabel.Text = if ($RandomMode) { "$($settings.application.name) - Random Mode" } else { $settings.application.name }
  $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
  $titleLabel.ForeColor = $foregroundColor
  $titleLabel.BackColor = [System.Drawing.Color]::Transparent
  $titleLabel.Size = New-Object System.Drawing.Size(300, 35)
  $titleLabel.Location = New-Object System.Drawing.Point(15, 0)
  $titleLabel.TextAlign = "MiddleLeft"

  # Create close button
  $closeButton = New-Object System.Windows.Forms.Button
  $closeButton.Text = "X"
  $closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
  $closeButton.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
  $closeButton.BackColor = [System.Drawing.Color]::Transparent
  $closeButton.FlatStyle = "Flat"
  $closeButton.FlatAppearance.BorderSize = 0
  $closeButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(232, 17, 35)
  $closeButton.Size = New-Object System.Drawing.Size(45, 35)
  $closeButton.Location = New-Object System.Drawing.Point(($windowSettings.width - 45), 0)
  $closeButton.Anchor = "Top,Right"
  $closeButton.Cursor = "Hand"

  # Create minimize button
  $minimizeButton = New-Object System.Windows.Forms.Button
  $minimizeButton.Text = "-"
  $minimizeButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
  $minimizeButton.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
  $minimizeButton.BackColor = [System.Drawing.Color]::Transparent
  $minimizeButton.FlatStyle = "Flat"
  $minimizeButton.FlatAppearance.BorderSize = 0
  $minimizeButton.FlatAppearance.MouseOverBackColor = $hoverColor
  $minimizeButton.Size = New-Object System.Drawing.Size(45, 35)
  $minimizeButton.Location = New-Object System.Drawing.Point(($windowSettings.width - 90), 0)
  $minimizeButton.Anchor = "Top,Right"
  $minimizeButton.Cursor = "Hand"

  # Add button event handlers
  $closeButton.Add_Click({
      $mainForm.Close()
    })

  $minimizeButton.Add_Click({
      $mainForm.WindowState = "Minimized"
    })

  # Add hover effects for close button
  $closeButton.Add_MouseEnter({
      $this.ForeColor = [System.Drawing.Color]::White
      $this.BackColor = $closeButtonColor
    })
  $closeButton.Add_MouseLeave({
      $this.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
      $this.BackColor = [System.Drawing.Color]::Transparent
    })

  # Add hover effects for minimize button
  $minimizeButton.Add_MouseEnter({
      $this.ForeColor = [System.Drawing.Color]::White
    })
  $minimizeButton.Add_MouseLeave({
      $this.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    })  # Variables for window dragging
  $script:isDragging = $false
  $script:lastCursor = [System.Drawing.Point]::Empty

  # Add mouse events for titlebar dragging
  $titleBar.Add_MouseDown({
      param($source, $e)
      if ($e.Button -eq "Left") {
        $script:isDragging = $true
        $script:lastCursor = $e.Location
      }
    })

  $titleBar.Add_MouseMove({
      param($source, $e)
      if ($script:isDragging) {
        $currentLocation = $mainForm.Location
        $newX = $currentLocation.X + ($e.X - $script:lastCursor.X)
        $newY = $currentLocation.Y + ($e.Y - $script:lastCursor.Y)
        $mainForm.Location = New-Object System.Drawing.Point($newX, $newY)
      }
    })

  $titleBar.Add_MouseUp({
      param($source, $e)
      $script:isDragging = $false
    })

  # Also add dragging to title label
  $titleLabel.Add_MouseDown({
      param($source, $e)
      if ($e.Button -eq "Left") {
        $script:isDragging = $true
        $script:lastCursor = New-Object System.Drawing.Point($e.X + 15, $e.Y)
      }
    })

  $titleLabel.Add_MouseMove({
      param($source, $e)
      if ($script:isDragging) {
        $currentLocation = $mainForm.Location
        $newX = $currentLocation.X + ($e.X + 15 - $script:lastCursor.X)
        $newY = $currentLocation.Y + ($e.Y - $script:lastCursor.Y)
        $mainForm.Location = New-Object System.Drawing.Point($newX, $newY)
      }
    })

  $titleLabel.Add_MouseUp({
      param($source, $e)
      $script:isDragging = $false
    })

  # Add controls to titlebar
  $titleBar.Controls.Add($titleLabel)
  $titleBar.Controls.Add($minimizeButton)
  $titleBar.Controls.Add($closeButton)

  # Create main content area (blank)
  $mainContent = New-Object System.Windows.Forms.Panel
  $mainContent.BackColor = $backgroundColor
  $mainContent.Dock = "Fill"

  # Add components to form
  $mainForm.Controls.Add($titleBar)
  $mainForm.Controls.Add($mainContent)

  # Show the form
  $mainForm.ShowDialog()
}
