<#
.SYNOPSIS
    Test helper functions for SmartShell testing framework

.DESCRIPTION
    Common utilities and assertion functions for creating consistent tests
    across the SmartShell project.

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: Testing Infrastructure
#>

# Global test result tracking
$script:GlobalTestResults = @()

function Add-TestResult {
  param(
    [Parameter(Mandatory)]
    [string]$Name,

    [Parameter(Mandatory)]
    [ValidateSet("PASS", "FAIL", "ERROR", "SKIP")]
    [string]$Status,

    [string]$Message = "",
    [string]$Category = "General",
    [timespan]$Duration = [timespan]::Zero
  )

  $result = @{
    Name      = $Name
    Status    = $Status
    Message   = $Message
    Category  = $Category
    Duration  = $Duration
    Timestamp = Get-Date
  }

  $script:GlobalTestResults += $result

  # Immediate console output
  $statusIcon = switch ($Status) {
    "PASS" { "✅" }
    "FAIL" { "❌" }
    "ERROR" { "⚠️" }
    "SKIP" { "⏭️" }
  }

  $color = switch ($Status) {
    "PASS" { "Green" }
    "FAIL" { "Red" }
    "ERROR" { "Yellow" }
    "SKIP" { "Cyan" }
  }

  Write-Host "$statusIcon $Name" -ForegroundColor $color
  if ($Message) {
    Write-Host "   $Message" -ForegroundColor Gray
  }
}

function Assert-Equal {
  param(
    [Parameter(Mandatory)]
    $Expected,

    [Parameter(Mandatory)]
    $Actual,

    [string]$Message = ""
  )

  if ($Expected -ne $Actual) {
    $errorMsg = "Expected '$Expected', got '$Actual'"
    if ($Message) { $errorMsg += ". $Message" }
    throw $errorMsg
  }
}

function Assert-True {
  param(
    [Parameter(Mandatory)]
    [bool]$Condition,

    [string]$Message = "Condition was false"
  )

  if (-not $Condition) {
    throw "Assertion failed: $Message"
  }
}

function Assert-False {
  param(
    [Parameter(Mandatory)]
    [bool]$Condition,

    [string]$Message = "Condition was true"
  )

  if ($Condition) {
    throw "Assertion failed: $Message"
  }
}

function Assert-Null {
  param(
    [Parameter(Mandatory)]
    $Value,

    [string]$Message = "Value was not null"
  )

  if ($null -ne $Value) {
    throw "Assertion failed: $Message. Got: $Value"
  }
}

function Assert-NotNull {
  param(
    [Parameter(Mandatory)]
    $Value,

    [string]$Message = "Value was null"
  )

  if ($null -eq $Value) {
    throw "Assertion failed: $Message"
  }
}

function Assert-FileExists {
  param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string]$Message = ""
  )

  if (-not (Test-Path $Path)) {
    $errorMsg = "File does not exist: $Path"
    if ($Message) { $errorMsg += ". $Message" }
    throw $errorMsg
  }
}

function Assert-DirectoryExists {
  param(
    [Parameter(Mandatory)]
    [string]$Path,

    [string]$Message = ""
  )

  if (-not (Test-Path $Path -PathType Container)) {
    $errorMsg = "Directory does not exist: $Path"
    if ($Message) { $errorMsg += ". $Message" }
    throw $errorMsg
  }
}

function Measure-TestExecution {
  param(
    [Parameter(Mandatory)]
    [scriptblock]$TestBlock,

    [Parameter(Mandatory)]
    [string]$TestName,

    [string]$Category = "General"
  )

  $startTime = Get-Date
  $status = "PASS"
  $message = ""

  try {
    & $TestBlock
  }
  catch {
    $status = "ERROR"
    $message = $_.Exception.Message
  }
  finally {
    $endTime = Get-Date
    $duration = $endTime - $startTime
    Add-TestResult -Name $TestName -Status $status -Message $message -Category $Category -Duration $duration
  }
}

function New-MockLogger {
  return @{
    LogPath    = "$env:TEMP\mock-test.log"
    Initialize = { return $true }
    WriteLog   = { param($msg) Write-Host "MOCK LOG: $msg" }
    Close      = { }
  }
}

function New-TestSettings {
  return @{
    window      = @{
      width         = 800
      height        = 600
      startPosition = "CenterScreen"
    }
    application = @{
      version = "1.0.2"
      name    = "TestApp"
    }
    theme       = @{
      current = "test-theme"
    }
  }
}

function New-MockTheme {
  return @{
    name   = "Test Theme"
    type   = "dark"
    colors = @{
      base   = "#000000"
      text   = "#ffffff"
      mauve  = "#800080"
      red    = "#ff0000"
      yellow = "#ffff00"
    }
  }
}

function Initialize-TestEnvironment {
  param(
    [string]$TestCategory = "General"
  )

  # Clear previous test results
  $script:GlobalTestResults = @()

  # Set up test environment
  Write-Host "Initializing test environment for: $TestCategory" -ForegroundColor Cyan
  Write-Host "Test started at: $(Get-Date)" -ForegroundColor Gray
  Write-Host "----------------------------------------" -ForegroundColor Gray
}

function Export-TestResults {
  param(
    [string]$OutputPath = "",
    [switch]$ShowSummary
  )

  if ($ShowSummary) {
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host "Test Results Summary" -ForegroundColor Cyan
    Write-Host "----------------------------------------" -ForegroundColor Gray

    $totalTests = $script:GlobalTestResults.Count
    $passedTests = ($script:GlobalTestResults | Where-Object { $_.Status -eq "PASS" }).Count
    $failedTests = ($script:GlobalTestResults | Where-Object { $_.Status -eq "FAIL" }).Count
    $errorTests = ($script:GlobalTestResults | Where-Object { $_.Status -eq "ERROR" }).Count
    $skippedTests = ($script:GlobalTestResults | Where-Object { $_.Status -eq "SKIP" }).Count

    # Calculate total duration safely
    $durationResults = $script:GlobalTestResults | Where-Object { $null -ne $_.Duration }
    if ($durationResults.Count -gt 0) {
      $totalSeconds = ($durationResults | ForEach-Object { $_.Duration.TotalSeconds } | Measure-Object -Sum).Sum
      $durationText = "$($totalSeconds.ToString('F2')) seconds"
    }
    else {
      $durationText = "N/A"
    }

    Write-Host "Total Tests: $totalTests" -ForegroundColor White
    Write-Host "Passed: $passedTests" -ForegroundColor Green
    Write-Host "Failed: $failedTests" -ForegroundColor Red
    Write-Host "Errors: $errorTests" -ForegroundColor Yellow
    Write-Host "Skipped: $skippedTests" -ForegroundColor Cyan
    Write-Host "Total Duration: $durationText" -ForegroundColor Gray

    $successRate = if ($totalTests -gt 0) { ($passedTests / $totalTests * 100).ToString('F1') } else { "0" }
    Write-Host "Success Rate: $successRate%" -ForegroundColor $(if ($successRate -eq "100.0") { "Green" } else { "Yellow" })
  }

  if ($OutputPath) {
    $script:GlobalTestResults | ConvertTo-Json -Depth 3 | Set-Content -Path $OutputPath -Encoding UTF8
    Write-Host "Test results exported to: $OutputPath" -ForegroundColor Gray
  }

  return $script:GlobalTestResults
}

function Clear-TestResults {
  $script:GlobalTestResults = @()
}

# Functions are available through dot-sourcing - no export needed for scripts
