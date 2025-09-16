<#
.SYNOPSIS
    Test runner for all SmartShell unit tests

.DESCRIPTION
    Executes all unit tests in the program/tests/unit directory and provides
    consolidated reporting of test results.

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: test-runner
#>

# Import test helpers
. "$PSScriptRoot\..\helpers\test-helpers.ps1"

function Invoke-AllUnitTests {
  param(
    [switch]$Detailed,
    [switch]$StopOnError
  )

  Write-Host "SmartShell Unit Test Runner" -ForegroundColor Cyan
  Write-Host "=" * 50 -ForegroundColor Cyan
  Write-Host ""

  # Initialize test tracking
  $script:AllTestResults = @()
  $script:TestCategories = @{}

  # Get all unit test files
  $unitTestPath = "$PSScriptRoot\..\unit"
  $testFiles = Get-ChildItem -Path $unitTestPath -Filter "*.test.ps1" -Recurse

  if ($testFiles.Count -eq 0) {
    Write-Host "No unit test files found in $unitTestPath" -ForegroundColor Yellow
    return
  }

  Write-Host "Found $($testFiles.Count) unit test file(s)" -ForegroundColor Green
  Write-Host ""

  # Execute each test file
  foreach ($testFile in $testFiles) {
    $testName = $testFile.BaseName -replace '\.test$', ''
    $relativePath = $testFile.FullName.Replace("$PSScriptRoot\..\", "")

    Write-Host "Running: $relativePath" -ForegroundColor White

    try {
      # Execute the test file
      $testOutput = & $testFile.FullName

      if ($Detailed) {
        Write-Host "  ✅ Completed" -ForegroundColor Green
      }

      # Track results
      $script:TestCategories[$testName] = @{
        File   = $relativePath
        Status = "Completed"
        Output = $testOutput
      }
    }
    catch {
      $errorMessage = $_.Exception.Message
      Write-Host "  ❌ Error: $errorMessage" -ForegroundColor Red

      $script:TestCategories[$testName] = @{
        File   = $relativePath
        Status = "Error"
        Error  = $errorMessage
      }

      if ($StopOnError) {
        Write-Host "Stopping execution due to error." -ForegroundColor Red
        break
      }
    }

    if ($Detailed) {
      Write-Host ""
    }
  }

  # Summary report
  Write-Host ""
  Write-Host "Unit Test Summary" -ForegroundColor Cyan
  Write-Host "-" * 30 -ForegroundColor Cyan

  $completed = ($script:TestCategories.Values | Where-Object { $_.Status -eq "Completed" }).Count
  $failed = ($script:TestCategories.Values | Where-Object { $_.Status -eq "Error" }).Count

  Write-Host "Total Files: $($testFiles.Count)" -ForegroundColor White
  Write-Host "Completed: $completed" -ForegroundColor Green
  Write-Host "Failed: $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })

  if ($failed -gt 0) {
    Write-Host ""
    Write-Host "Failed Tests:" -ForegroundColor Red
    $script:TestCategories.GetEnumerator() | Where-Object { $_.Value.Status -eq "Error" } | ForEach-Object {
      Write-Host "  - $($_.Value.File): $($_.Value.Error)" -ForegroundColor Red
    }
  }

  # Return summary
  return @{
    TotalFiles = $testFiles.Count
    Completed  = $completed
    Failed     = $failed
    Success    = ($failed -eq 0)
  }
}

# Execute if script is run directly
if ($MyInvocation.InvocationName -ne '.') {
  $results = Invoke-AllUnitTests -Detailed

  # Exit with appropriate code
  if ($results.Success) {
    Write-Host ""
    Write-Host "All unit tests completed successfully! ✅" -ForegroundColor Green
    exit 0
  }
  else {
    Write-Host ""
    Write-Host "Some unit tests failed! ❌" -ForegroundColor Red
    exit 1
  }
}
