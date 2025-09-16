<#
.SYNOPSIS
    Master test runner for entire SmartShell test suite

.DESCRIPTION
    Executes all tests (unit, integration, functional) and provides comprehensive
    reporting of the entire test suite status.

.PARAMETER TestType
    Specify which type of tests to run: All, Unit, Integration, Functional

.PARAMETER Detailed
    Show detailed output for each test execution

.PARAMETER StopOnError
    Stop execution when first error is encountered

.NOTES
    Created: 2025-09-16
    Version: 1.0.2
    Category: test-runner
#>

param(
  [ValidateSet("All", "Unit", "Integration", "Functional")]
  [string]$TestType = "All",
  [switch]$Detailed,
  [switch]$StopOnError
)

# Import test helpers
. "$PSScriptRoot\test-helpers.ps1"

function Invoke-SmartShellTestSuite {
  param(
    [string]$TestType = "All",
    [switch]$Detailed,
    [switch]$StopOnError
  )

  $startTime = Get-Date

  Write-Host "SmartShell Test Suite Runner" -ForegroundColor Magenta
  Write-Host "=" * 60 -ForegroundColor Magenta
  Write-Host "Test Type: $TestType" -ForegroundColor White
  Write-Host "Start Time: $($startTime.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor White
  Write-Host ""

  # Initialize overall results
  $overallResults = @{
    Unit        = $null
    Integration = $null
    Functional  = $null
    StartTime   = $startTime
    EndTime     = $null
  }

  # Run Unit Tests
  if ($TestType -eq "All" -or $TestType -eq "Unit") {
    Write-Host "🧪 Running Unit Tests..." -ForegroundColor Yellow
    Write-Host ""

    try {
      $unitResults = & "$PSScriptRoot\run-unit-tests.ps1"
      $overallResults.Unit = $unitResults

      if (-not $unitResults.Success -and $StopOnError) {
        Write-Host "Stopping test suite due to unit test failures." -ForegroundColor Red
        return $overallResults
      }
    }
    catch {
      Write-Host "Error running unit tests: $($_.Exception.Message)" -ForegroundColor Red
      $overallResults.Unit = @{ Success = $false; Error = $_.Exception.Message }

      if ($StopOnError) {
        return $overallResults
      }
    }

    Write-Host ""
  }

  # Run Integration Tests
  if ($TestType -eq "All" -or $TestType -eq "Integration") {
    Write-Host "🔗 Running Integration Tests..." -ForegroundColor Yellow
    Write-Host ""

    try {
      $integrationResults = & "$PSScriptRoot\run-integration-tests.ps1"
      $overallResults.Integration = $integrationResults

      if (-not $integrationResults.Success -and $StopOnError) {
        Write-Host "Stopping test suite due to integration test failures." -ForegroundColor Red
        return $overallResults
      }
    }
    catch {
      Write-Host "Error running integration tests: $($_.Exception.Message)" -ForegroundColor Red
      $overallResults.Integration = @{ Success = $false; Error = $_.Exception.Message }

      if ($StopOnError) {
        return $overallResults
      }
    }

    Write-Host ""
  }

  # Run Functional Tests
  if ($TestType -eq "All" -or $TestType -eq "Functional") {
    Write-Host "⚙️ Running Functional Tests..." -ForegroundColor Yellow
    Write-Host ""

    try {
      # Get all functional test files
      $functionalTestPath = "$PSScriptRoot\..\functional"
      $functionalTestFiles = Get-ChildItem -Path $functionalTestPath -Filter "*.test.ps1" -Recurse

      $functionalResults = @{
        TotalFiles = $functionalTestFiles.Count
        Completed  = 0
        Failed     = 0
        Success    = $true
      }

      foreach ($testFile in $functionalTestFiles) {
        $testName = $testFile.BaseName
        Write-Host "Running: $testName" -ForegroundColor White

        try {
          & $testFile.FullName
          $functionalResults.Completed++
          if ($Detailed) {
            Write-Host "  ✅ Completed" -ForegroundColor Green
          }
        }
        catch {
          Write-Host "  ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
          $functionalResults.Failed++
          $functionalResults.Success = $false

          if ($StopOnError) {
            break
          }
        }
      }

      $overallResults.Functional = $functionalResults

      if (-not $functionalResults.Success -and $StopOnError) {
        Write-Host "Stopping test suite due to functional test failures." -ForegroundColor Red
        return $overallResults
      }
    }
    catch {
      Write-Host "Error running functional tests: $($_.Exception.Message)" -ForegroundColor Red
      $overallResults.Functional = @{ Success = $false; Error = $_.Exception.Message }

      if ($StopOnError) {
        return $overallResults
      }
    }

    Write-Host ""
  }

  $overallResults.EndTime = Get-Date
  return $overallResults
}

function Show-TestSuiteSummary {
  param($Results)

  $endTime = $Results.EndTime
  $duration = $endTime - $Results.StartTime

  Write-Host ""
  Write-Host "Test Suite Summary" -ForegroundColor Magenta
  Write-Host "=" * 60 -ForegroundColor Magenta
  Write-Host "End Time: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor White
  Write-Host "Duration: $($duration.TotalSeconds.ToString('F2')) seconds" -ForegroundColor White
  Write-Host ""

  $overallSuccess = $true
  $totalTests = 0
  $totalPassed = 0
  $totalFailed = 0

  # Unit Test Results
  if ($Results.Unit) {
    $status = if ($Results.Unit.Success) { "✅ PASSED" } else { "❌ FAILED" }
    Write-Host "Unit Tests: $status" -ForegroundColor $(if ($Results.Unit.Success) { "Green" } else { "Red" })
    if ($Results.Unit.TotalFiles) {
      Write-Host "  Files: $($Results.Unit.TotalFiles), Completed: $($Results.Unit.Completed), Failed: $($Results.Unit.Failed)" -ForegroundColor Gray
      $totalTests += $Results.Unit.TotalFiles
      $totalPassed += $Results.Unit.Completed
      $totalFailed += $Results.Unit.Failed
    }
    $overallSuccess = $overallSuccess -and $Results.Unit.Success
  }

  # Integration Test Results
  if ($Results.Integration) {
    $status = if ($Results.Integration.Success) { "✅ PASSED" } else { "❌ FAILED" }
    Write-Host "Integration Tests: $status" -ForegroundColor $(if ($Results.Integration.Success) { "Green" } else { "Red" })
    if ($Results.Integration.TotalFiles) {
      Write-Host "  Files: $($Results.Integration.TotalFiles), Completed: $($Results.Integration.Completed), Failed: $($Results.Integration.Failed)" -ForegroundColor Gray
      $totalTests += $Results.Integration.TotalFiles
      $totalPassed += $Results.Integration.Completed
      $totalFailed += $Results.Integration.Failed
    }
    $overallSuccess = $overallSuccess -and $Results.Integration.Success
  }

  # Functional Test Results
  if ($Results.Functional) {
    $status = if ($Results.Functional.Success) { "✅ PASSED" } else { "❌ FAILED" }
    Write-Host "Functional Tests: $status" -ForegroundColor $(if ($Results.Functional.Success) { "Green" } else { "Red" })
    if ($Results.Functional.TotalFiles) {
      Write-Host "  Files: $($Results.Functional.TotalFiles), Completed: $($Results.Functional.Completed), Failed: $($Results.Functional.Failed)" -ForegroundColor Gray
      $totalTests += $Results.Functional.TotalFiles
      $totalPassed += $Results.Functional.Completed
      $totalFailed += $Results.Functional.Failed
    }
    $overallSuccess = $overallSuccess -and $Results.Functional.Success
  }

  Write-Host ""
  Write-Host "Overall Results:" -ForegroundColor White
  Write-Host "  Total Test Files: $totalTests" -ForegroundColor White
  Write-Host "  Passed: $totalPassed" -ForegroundColor Green
  Write-Host "  Failed: $totalFailed" -ForegroundColor $(if ($totalFailed -gt 0) { "Red" } else { "Green" })
  Write-Host ""

  $finalStatus = if ($overallSuccess) { "ALL TESTS PASSED! 🎉" } else { "SOME TESTS FAILED! ⚠️" }
  $finalColor = if ($overallSuccess) { "Green" } else { "Red" }
  Write-Host $finalStatus -ForegroundColor $finalColor

  return $overallSuccess
}

# Execute if script is run directly
if ($MyInvocation.InvocationName -ne '.') {
  $results = Invoke-SmartShellTestSuite -TestType $TestType -Detailed:$Detailed -StopOnError:$StopOnError
  $success = Show-TestSuiteSummary -Results $results

  # Exit with appropriate code
  exit $(if ($success) { 0 } else { 1 })
}
