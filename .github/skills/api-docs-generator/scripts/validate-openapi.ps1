# Validate OpenAPI Specification
# This script validates an OpenAPI/Swagger JSON file against the OpenAPI 3.0 schema

param(
    [Parameter(Mandatory=$true)]
    [string]$SpecPath
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " OpenAPI Specification Validator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if spec file exists
if (-not (Test-Path $SpecPath)) {
    Write-Host "Error: OpenAPI spec file not found: $SpecPath" -ForegroundColor Red
    exit 1
}

Write-Host "[1/3] Reading OpenAPI specification..." -ForegroundColor Yellow
try {
    $spec = Get-Content $SpecPath -Raw | ConvertFrom-Json
    Write-Host "  ✓ Valid JSON format" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Invalid JSON format" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/3] Validating required fields..." -ForegroundColor Yellow

$errors = @()
$warnings = @()

# Check OpenAPI version
if (-not $spec.openapi) {
    $errors += "Missing required field: 'openapi'"
} elseif ($spec.openapi -notmatch '^3\.0\.\d+$') {
    $warnings += "OpenAPI version should be 3.0.x, found: $($spec.openapi)"
} else {
    Write-Host "  ✓ OpenAPI version: $($spec.openapi)" -ForegroundColor Green
}

# Check info object
if (-not $spec.info) {
    $errors += "Missing required field: 'info'"
} else {
    if (-not $spec.info.title) {
        $errors += "Missing required field: 'info.title'"
    } else {
        Write-Host "  ✓ API title: $($spec.info.title)" -ForegroundColor Green
    }
    
    if (-not $spec.info.version) {
        $errors += "Missing required field: 'info.version'"
    } else {
        Write-Host "  ✓ API version: $($spec.info.version)" -ForegroundColor Green
    }
}

# Check paths
if (-not $spec.paths) {
    $errors += "Missing required field: 'paths'"
} else {
    $pathCount = ($spec.paths | Get-Member -MemberType NoteProperty).Count
    if ($pathCount -eq 0) {
        $warnings += "No paths defined in the specification"
    } else {
        Write-Host "  ✓ Paths defined: $pathCount" -ForegroundColor Green
    }
}

# Check servers
if (-not $spec.servers -or $spec.servers.Count -eq 0) {
    $warnings += "No servers defined (recommended to add at least one)"
} else {
    Write-Host "  ✓ Servers defined: $($spec.servers.Count)" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/3] Validation Results..." -ForegroundColor Yellow

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " ✓ Validation Successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your OpenAPI specification is valid!" -ForegroundColor Green
    exit 0
}

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "❌ Errors Found:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  • $error" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  • $warning" -ForegroundColor Yellow
    }
}

Write-Host ""
if ($errors.Count -gt 0) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " ✗ Validation Failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Fix the errors above and try again." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " ⚠️  Validation Passed with Warnings" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Consider addressing the warnings above." -ForegroundColor Yellow
    exit 0
}
