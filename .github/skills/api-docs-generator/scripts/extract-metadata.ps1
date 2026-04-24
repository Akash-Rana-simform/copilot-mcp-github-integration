# Extract Metadata from C# Controllers
# This script parses C# controller files to extract API endpoint metadata

param(
    [Parameter(Mandatory=$true)]
    [string]$ControllerPath,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "metadata.json"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " API Metadata Extractor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if controller file exists
if (-not (Test-Path $ControllerPath)) {
    Write-Host "Error: Controller file not found: $ControllerPath" -ForegroundColor Red
    exit 1
}

Write-Host "[1/3] Reading controller file..." -ForegroundColor Yellow
$content = Get-Content $ControllerPath -Raw

# Extract controller name
$controllerName = [System.IO.Path]::GetFileNameWithoutExtension($ControllerPath)
Write-Host "  Controller: $controllerName" -ForegroundColor Gray

Write-Host ""
Write-Host "[2/3] Extracting metadata..." -ForegroundColor Yellow

$metadata = @{
    controllerName = $controllerName
    route = ""
    endpoints = @()
}

# Extract controller route
if ($content -match '\[Route\("([^"]+)"\)\]') {
    $metadata.route = $matches[1]
    Write-Host "  Route: $($metadata.route)" -ForegroundColor Gray
}

# Extract HTTP methods and their attributes
$httpMethods = @('HttpGet', 'HttpPost', 'HttpPut', 'HttpDelete', 'HttpPatch')

foreach ($method in $httpMethods) {
    $pattern = "\[$method(?:\(`"([^`"]*)`"\))?\](?:\s|\n)*(?:\[ProducesResponseType.*?\](?:\s|\n)*)*(?:public\s+(?:async\s+)?Task<IActionResult>\s+(\w+))"
    
    if ($content -match $pattern) {
        $matches | ForEach-Object {
            if ($_ -match $pattern) {
                $endpoint = @{
                    method = $method.Replace('Http', '').ToUpper()
                    route = if ($matches[1]) { $matches[1] } else { "" }
                    actionName = $matches[2]
                }
                
                $metadata.endpoints += $endpoint
                Write-Host "    Found: $($endpoint.method) $($endpoint.route) -> $($endpoint.actionName)" -ForegroundColor Green
            }
        }
    }
}

Write-Host ""
Write-Host "[3/3] Saving metadata..." -ForegroundColor Yellow

# Convert to JSON and save
$json = $metadata | ConvertTo-Json -Depth 10
$json | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "  Saved to: $OutputPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Extraction Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Controller: $controllerName" -ForegroundColor White
Write-Host "  Endpoints found: $($metadata.endpoints.Count)" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Review metadata.json" -ForegroundColor White
Write-Host "  2. Use data to generate OpenAPI spec" -ForegroundColor White
Write-Host "  3. Create API documentation" -ForegroundColor White

exit 0
