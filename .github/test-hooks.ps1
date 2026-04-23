# Copilot Hooks Test Script
# This script helps test the security hooks configuration

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Copilot Security Hooks Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if hooks file exists
Write-Host "[1/5] Checking hooks configuration..." -ForegroundColor Yellow
$hooksFile = ".github/hooks/security.json"
if (Test-Path $hooksFile) {
    Write-Host "  ✓ Hooks file found: $hooksFile" -ForegroundColor Green
    
    # Validate JSON
    try {
        $config = Get-Content $hooksFile | ConvertFrom-Json
        Write-Host "  ✓ Valid JSON configuration" -ForegroundColor Green
        Write-Host "  → Configured hooks: $($config.hooks.PSObject.Properties.Name -join ', ')" -ForegroundColor Gray
    } catch {
        Write-Host "  ✗ Invalid JSON: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  ✗ Hooks file not found" -ForegroundColor Red
    exit 1
}

# Check PowerShell availability
Write-Host "`n[2/5] Checking PowerShell..." -ForegroundColor Yellow
try {
    $psVersion = $PSVersionTable.PSVersion
    Write-Host "  ✓ PowerShell $psVersion available" -ForegroundColor Green
} catch {
    Write-Host "  ✗ PowerShell not available" -ForegroundColor Red
    exit 1
}

# Test log directory creation
Write-Host "`n[3/5] Testing log directory creation..." -ForegroundColor Yellow
$logDir = ".github/logs"
try {
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    Write-Host "  ✓ Log directory created/verified: $logDir" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to create log directory: $_" -ForegroundColor Red
    exit 1
}

# Simulate hook execution
Write-Host "`n[4/5] Simulating hook executions..." -ForegroundColor Yellow

# Test session start hook
try {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] SESSION_START - User: $env:USERNAME, Workspace: $PWD"
    $logFile = "$logDir/agent-sessions.log"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host "  ✓ Session start logged" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Session logging failed: $_" -ForegroundColor Red
}

# Test tool execution hook
try {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] PRE_TOOL - Tool: test_tool, Args: {test: 'data'}"
    $logFile = "$logDir/tool-executions.log"
    Add-Content -Path $logFile -Value $logEntry
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] POST_TOOL - Tool: test_tool, Status: success"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host "  ✓ Tool execution logged" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Tool logging failed: $_" -ForegroundColor Red
}

# Test file edit hook
try {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] PRE_FILE_EDIT - File: test-file.txt, User: $env:USERNAME"
    $logFile = "$logDir/file-edits.log"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host "  ✓ File edit logged" -ForegroundColor Green
} catch {
    Write-Host "  ✗ File edit logging failed: $_" -ForegroundColor Red
}

# Display log contents
Write-Host "`n[5/5] Reviewing generated logs..." -ForegroundColor Yellow

$logFiles = @(
    "$logDir/agent-sessions.log",
    "$logDir/tool-executions.log",
    "$logDir/file-edits.log"
)

foreach ($logFile in $logFiles) {
    if (Test-Path $logFile) {
        Write-Host "`n  📄 $logFile" -ForegroundColor Cyan
        $content = Get-Content $logFile -Tail 3
        foreach ($line in $content) {
            Write-Host "     $line" -ForegroundColor Gray
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " Test Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Open Copilot Chat: Ctrl+Alt+I" -ForegroundColor White
Write-Host "2. Try some commands (read files, create files, etc.)" -ForegroundColor White
Write-Host "3. Check logs: Get-Content .github/logs/*.log" -ForegroundColor White
Write-Host "4. Monitor in real-time: Get-Content .github/logs/tool-executions.log -Wait" -ForegroundColor White
Write-Host ""
Write-Host "View hook documentation: .github/hooks/README.md" -ForegroundColor Gray
