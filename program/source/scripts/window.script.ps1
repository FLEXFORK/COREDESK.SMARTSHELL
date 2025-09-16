<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC
- SETTINGS.SERVICE.PS1 HANDLES APPLICATION SETTINGS

#>


# ---------------  CURRENT FILE  ----------------- #
# /ROOTDIR//PROGRAM/SOURCE/SCRIPTS/WINDOW.SCRIPT.PS1
# ----------------  POWERSHELL  ------------------ #

function Get-WindowLogic {
  return @{
    Version    = "1.0.2"
    Author     = "SmartShell Team"
    LastUpdate = (Get-Date)
  }
}


