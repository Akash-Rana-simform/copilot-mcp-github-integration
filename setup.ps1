# PowerShell Setup Script for GitHub MCP Demo
# This script configures your environment for the GitHub MCP Server demo

param(
    [switch]$SkipTokenSetup
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " GitHub MCP Server Demo Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js installation
Write-Host "[1/4] Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "  ✓ Node.js $nodeVersion is installed" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Node.js is not installed" -ForegroundColor Red
    Write-Host "  Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Check .NET SDK installation
Write-Host "[2/4] Checking .NET SDK installation..." -ForegroundColor Yellow
try {
    $dotnetVersion = dotnet --version
    Write-Host "  ✓ .NET SDK $dotnetVersion is installed" -ForegroundColor Green
} catch {
    Write-Host "  ✗ .NET SDK is not installed" -ForegroundColor Red
    Write-Host "  Please install .NET SDK from https://dotnet.microsoft.com/download" -ForegroundColor Red
    exit 1
}

# Setup GitHub Token
if (-not $SkipTokenSetup) {
    Write-Host "[3/4] Setting up GitHub Token..." -ForegroundColor Yellow
    
    $existingToken = [System.Environment]::GetEnvironmentVariable('GITHUB_TOKEN', 'User')
    
    if ($existingToken) {
        Write-Host "  ! GITHUB_TOKEN is already set" -ForegroundColor Yellow
        $overwrite = Read-Host "  Do you want to overwrite it? (y/n)"
        if ($overwrite -ne 'y') {
            Write-Host "  → Keeping existing token" -ForegroundColor Gray
        } else {
            $token = Read-Host "  Enter your GitHub Personal Access Token" -AsSecureString
            $tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
            
            [System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', $tokenPlain, 'User')
            Write-Host "  ✓ GITHUB_TOKEN updated" -ForegroundColor Green
        }
    } else {
        Write-Host ""
        Write-Host "  To create a GitHub Personal Access Token:" -ForegroundColor Cyan
        Write-Host "  1. Go to: https://github.com/settings/tokens/new" -ForegroundColor Gray
        Write-Host "  2. Name: 'MCP Server Demo'" -ForegroundColor Gray
        Write-Host "  3. Scopes: repo, read:org, read:user" -ForegroundColor Gray
        Write-Host "  4. Generate and copy the token" -ForegroundColor Gray
        Write-Host ""
        
        $token = Read-Host "  Enter your GitHub Personal Access Token" -AsSecureString
        $tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
        
        if ([string]::IsNullOrWhiteSpace($tokenPlain)) {
            Write-Host "  ✗ Token cannot be empty" -ForegroundColor Red
            exit 1
        }
        
        [System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', $tokenPlain, 'User')
        Write-Host "  ✓ GITHUB_TOKEN set successfully" -ForegroundColor Green
    }
} else {
    Write-Host "[3/4] Skipping token setup..." -ForegroundColor Yellow
}

# Restore .NET dependencies
Write-Host "[4/4] Restoring .NET dependencies..." -ForegroundColor Yellow
try {
    $output = dotnet restore GitHubDemo.sln 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Dependencies restored" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to restore dependencies" -ForegroundColor Red
        Write-Host $output
    }
} catch {
    Write-Host "  ✗ Error restoring dependencies: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. RESTART VS Code completely (close all windows)" -ForegroundColor White
Write-Host "2. Open Copilot Chat (Ctrl+Alt+I)" -ForegroundColor White
Write-Host "3. Switch to 'Agent' mode" -ForegroundColor White
Write-Host "4. Try: 'List my open pull requests'" -ForegroundColor White
Write-Host ""
Write-Host "To run the demo API:" -ForegroundColor Yellow
Write-Host "  dotnet run --project src\GitHubDemo.Api" -ForegroundColor Cyan
Write-Host ""
Write-Host "To verify MCP is working:" -ForegroundColor Yellow
Write-Host "  Help → Toggle Developer Tools → Console" -ForegroundColor Cyan
Write-Host "  Look for 'mcp_github_*' tool invocations" -ForegroundColor Cyan
Write-Host ""
