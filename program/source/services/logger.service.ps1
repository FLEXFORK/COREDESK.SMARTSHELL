<#

- SMARTSHELL.PS1 IS THE MAIN PROGRAM ENTRYPOINT
- WINDOW.VIEW.PS1 IS THE MAIN PROGRAM GUI
- WINDOW.SCRIPT.PS1 IS THE MAIN PROGRAM LOGIC
- SETTINGS.SERVICE.PS1 HANDLES APPLICATION SETTINGS
- LOGGER.SERVICE.PS1 HANDLES LOGGING OPERATIONS

#>

# ---------------  CURRENT FILE  ---------------------- #
# /ROOTDIR//PROGRAM/SOURCE/SERVICES/LOGGER.SERVICE.PS1
# ----------------  POWERSHELL  ----------------------- #

# Global logging variables
$script:LogSession = @{
  SessionId     = [System.Guid]::NewGuid().ToString()
  StartTime     = Get-Date
  MainLogPath   = ""
  ErrorLogPath  = ""
  IsInitialized = $false
}

function Remove-OldLogFiles {
  param(
    [Parameter(Mandatory)]
    [string]$LogDirectory,

    [int]$MaxFiles = 10
  )

  try {
    if (-not (Test-Path $LogDirectory)) {
      return
    }

    # Get all .log files in the directory, sorted by creation time (oldest first)
    $logFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log" | Sort-Object CreationTime

    # If we have more than MaxFiles, delete the oldest ones
    if ($logFiles.Count -ge $MaxFiles) {
      $filesToDelete = $logFiles | Select-Object -First ($logFiles.Count - $MaxFiles + 1)

      foreach ($file in $filesToDelete) {
        try {
          Remove-Item -Path $file.FullName -Force
          Write-Host "Deleted old log file: $($file.Name)" -ForegroundColor Yellow
        }
        catch {
          Write-Warning "Failed to delete log file: $($file.Name) - $($_.Exception.Message)"
        }
      }
    }
  }
  catch {
    Write-Warning "Failed to perform log rotation in $LogDirectory : $($_.Exception.Message)"
  }
}

function Initialize-Logger {
  param(
    [string]$LogDirectory = "$PSScriptRoot\..\..\logs",
    [string]$ErrorDirectory = "$PSScriptRoot\..\..\logs\errors"
  )

  try {
    # Ensure log directories exist
    if (-not (Test-Path $LogDirectory)) {
      New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path $ErrorDirectory)) {
      New-Item -Path $ErrorDirectory -ItemType Directory -Force | Out-Null
    }

    # Perform log rotation before creating new files
    Remove-OldLogFiles -LogDirectory $LogDirectory -MaxFiles 10
    Remove-OldLogFiles -LogDirectory $ErrorDirectory -MaxFiles 10

    # Generate timestamp for filenames
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

    # Set log file paths
    $script:LogSession.MainLogPath = Join-Path $LogDirectory "smartshell_$timestamp.log"
    $script:LogSession.ErrorLogPath = Join-Path $ErrorDirectory "errors_$timestamp.log"

    # Initialize log files with session header
    $sessionHeader = @"
================================================================================
SmartShell Logging Session
================================================================================
Session ID: $($script:LogSession.SessionId)
Start Time: $($script:LogSession.StartTime.ToString("yyyy-MM-dd HH:mm:ss"))
Log File: $($script:LogSession.MainLogPath)
Error File: $($script:LogSession.ErrorLogPath)
================================================================================

"@

    Set-Content -Path $script:LogSession.MainLogPath -Value $sessionHeader -Encoding UTF8
    Set-Content -Path $script:LogSession.ErrorLogPath -Value $sessionHeader -Encoding UTF8

    $script:LogSession.IsInitialized = $true

    Write-LogEntry -Level "INFO" -Message "Logger service initialized successfully"
    return $true
  }
  catch {
    Write-Warning "Failed to initialize logger: $($_.Exception.Message)"
    return $false
  }
}

function Write-LogEntry {
  param(
    [Parameter(Mandatory)]
    [ValidateSet("INFO", "WARN", "ERROR", "DEBUG", "INPUT", "OUTPUT")]
    [string]$Level,

    [Parameter(Mandatory)]
    [string]$Message,

    [string]$Source = "SmartShell",
    [switch]$ErrorsOnly
  )

  if (-not $script:LogSession.IsInitialized) {
    Initialize-Logger | Out-Null
  }

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
  $logEntry = "[$timestamp] [$Level] [$Source] $Message"

  try {
    # Always write to main log (unless ErrorsOnly is specified)
    if (-not $ErrorsOnly) {
      Add-Content -Path $script:LogSession.MainLogPath -Value $logEntry -Encoding UTF8
    }

    # Write errors to error log as well
    if ($Level -eq "ERROR") {
      Add-Content -Path $script:LogSession.ErrorLogPath -Value $logEntry -Encoding UTF8
    }
  }
  catch {
    Write-Warning "Failed to write log entry: $($_.Exception.Message)"
  }
}

function Write-TerminalInput {
  param(
    [Parameter(Mandatory)]
    [string]$Command,

    [string]$WorkingDirectory = (Get-Location).Path
  )

  $inputMessage = "COMMAND: $Command | PWD: $WorkingDirectory"
  Write-LogEntry -Level "INPUT" -Message $inputMessage -Source "Terminal"
}

function Write-TerminalOutput {
  param(
    [Parameter(Mandatory)]
    [string]$Output,

    [int]$ExitCode = 0,
    [string]$Command = ""
  )

  if ($ExitCode -eq 0) {
    $outputMessage = "OUTPUT: $Output"
    if ($Command) {
      $outputMessage = "OUTPUT for '$Command': $Output"
    }
    Write-LogEntry -Level "OUTPUT" -Message $outputMessage -Source "Terminal"
  }
  else {
    $errorMessage = "COMMAND FAILED (Exit Code: $ExitCode): $Command | OUTPUT: $Output"
    Write-LogEntry -Level "ERROR" -Message $errorMessage -Source "Terminal"
  }
}

function Write-ErrorLog {
  param(
    [Parameter(Mandatory)]
    [string]$ErrorMessage,

    [string]$Source = "SmartShell",
    [string]$CallStack = "",
    [object]$Exception = $null
  )

  $fullErrorMessage = $ErrorMessage

  if ($Exception) {
    $fullErrorMessage += " | Exception: $($Exception.GetType().Name)"
    if ($Exception.InnerException) {
      $fullErrorMessage += " | Inner: $($Exception.InnerException.Message)"
    }
  }

  if ($CallStack) {
    $fullErrorMessage += " | Stack: $CallStack"
  }

  Write-LogEntry -Level "ERROR" -Message $fullErrorMessage -Source $Source
}

function Write-DebugLog {
  param(
    [Parameter(Mandatory)]
    [string]$Message,

    [string]$Source = "SmartShell"
  )

  Write-LogEntry -Level "DEBUG" -Message $Message -Source $Source
}

function Write-InfoLog {
  param(
    [Parameter(Mandatory)]
    [string]$Message,

    [string]$Source = "SmartShell"
  )

  Write-LogEntry -Level "INFO" -Message $Message -Source $Source
}

function Write-WarnLog {
  param(
    [Parameter(Mandatory)]
    [string]$Message,

    [string]$Source = "SmartShell"
  )

  Write-LogEntry -Level "WARN" -Message $Message -Source $Source
}

function Get-LogSession {
  return $script:LogSession
}

function Get-LogFilePaths {
  return @{
    MainLog   = $script:LogSession.MainLogPath
    ErrorLog  = $script:LogSession.ErrorLogPath
    SessionId = $script:LogSession.SessionId
    StartTime = $script:LogSession.StartTime
  }
}

function Get-LogRotationStats {
  param(
    [string]$LogDirectory = "$PSScriptRoot\..\..\logs",
    [string]$ErrorDirectory = "$PSScriptRoot\..\..\logs\errors"
  )

  $stats = @{
    MainLogs  = 0
    ErrorLogs = 0
    TotalSize = 0
  }

  try {
    if (Test-Path $LogDirectory) {
      $mainLogFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log"
      $stats.MainLogs = $mainLogFiles.Count
      $stats.TotalSize += ($mainLogFiles | Measure-Object -Property Length -Sum).Sum
    }

    if (Test-Path $ErrorDirectory) {
      $errorLogFiles = Get-ChildItem -Path $ErrorDirectory -Filter "*.log"
      $stats.ErrorLogs = $errorLogFiles.Count
      $stats.TotalSize += ($errorLogFiles | Measure-Object -Property Length -Sum).Sum
    }
  }
  catch {
    Write-Warning "Failed to get log rotation stats: $($_.Exception.Message)"
  }

  return $stats
}

function Start-TerminalLogging {
  param(
    [string]$Command,
    [scriptblock]$ScriptBlock
  )

  if (-not $script:LogSession.IsInitialized) {
    Initialize-Logger | Out-Null
  }

  Write-TerminalInput -Command $Command -WorkingDirectory (Get-Location).Path

  try {
    $output = & $ScriptBlock
    $exitCode = $LASTEXITCODE

    if ($null -eq $exitCode) { $exitCode = 0 }

    Write-TerminalOutput -Output ($output -join "`n") -ExitCode $exitCode -Command $Command

    return $output
  }
  catch {
    Write-ErrorLog -ErrorMessage "Failed to execute command: $Command" -Exception $_.Exception -CallStack $_.ScriptStackTrace -Source "Terminal"
    throw
  }
}

function Close-Logger {
  if ($script:LogSession.IsInitialized) {
    $endTime = Get-Date
    $duration = $endTime - $script:LogSession.StartTime

    # Get log rotation statistics
    $rotationStats = Get-LogRotationStats
    $totalSizeKB = [math]::Round($rotationStats.TotalSize / 1024, 2)

    $sessionFooter = @"

================================================================================
Session End: $($endTime.ToString("yyyy-MM-dd HH:mm:ss"))
Duration: $($duration.ToString("hh\:mm\:ss"))
Log Files: $($rotationStats.MainLogs) main, $($rotationStats.ErrorLogs) error (Total: $totalSizeKB KB)
================================================================================
"@

    Add-Content -Path $script:LogSession.MainLogPath -Value $sessionFooter -Encoding UTF8
    Add-Content -Path $script:LogSession.ErrorLogPath -Value $sessionFooter -Encoding UTF8

    Write-LogEntry -Level "INFO" -Message "Logger session closed. Duration: $($duration.ToString("hh\:mm\:ss"))"
  }
}

# Auto-initialize logger when service is loaded
Initialize-Logger | Out-Null
