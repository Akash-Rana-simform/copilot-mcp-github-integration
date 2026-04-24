# Generate Realistic API Examples
# This script generates realistic request/response examples for API documentation

param(
    [Parameter(Mandatory=$true)]
    [string]$ModelType,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "examples"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " API Example Generator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

Write-Host "[1/2] Generating examples for: $ModelType" -ForegroundColor Yellow

# Example data generators
function Get-WebhookExample {
    return @{
        event = "push"
        action = "synchronize"
        repository = "octocat/hello-world"
        sender = "octocat"
        payload = @{
            ref = "refs/heads/main"
            before = "abc123def456"
            after = "def456ghi789"
            commits = @(
                @{
                    id = "def456ghi789"
                    message = "Update README"
                    timestamp = "2026-04-24T10:00:00Z"
                    author = @{
                        name = "Octocat"
                        email = "octocat@github.com"
                    }
                }
            )
        }
    }
}

function Get-PaginatedResponseExample {
    return @{
        data = @()
        page = 1
        pageSize = 20
        totalCount = 100
        totalPages = 5
    }
}

function Get-ErrorExample {
    param([int]$StatusCode)
    
    $examples = @{
        400 = @{
            type = "https://tools.ietf.org/html/rfc7231#section-6.5.1"
            title = "Bad Request"
            status = 400
            detail = "One or more validation errors occurred"
            errors = @{
                field = @("The field is required", "The field must be between 1 and 100 characters")
            }
        }
        401 = @{
            type = "https://tools.ietf.org/html/rfc7235#section-3.1"
            title = "Unauthorized"
            status = 401
            detail = "Invalid or missing authentication token"
        }
        404 = @{
            type = "https://tools.ietf.org/html/rfc7231#section-6.5.4"
            title = "Not Found"
            status = 404
            detail = "The requested resource was not found"
        }
        500 = @{
            type = "https://tools.ietf.org/html/rfc7231#section-6.6.1"
            title = "Internal Server Error"
            status = 500
            detail = "An unexpected error occurred while processing your request"
        }
    }
    
    return $examples[$StatusCode]
}

# Generate examples based on model type
$examples = @{}

switch -Wildcard ($ModelType) {
    "*Webhook*" {
        Write-Host "  Generating webhook examples..." -ForegroundColor Gray
        $examples["request"] = Get-WebhookExample
        $examples["response"] = Get-WebhookExample | Select-Object -Property @{Name="id";Expression={"wh_" + (New-Guid).ToString("N").Substring(0,12)}}, event, repository, sender, @{Name="timestamp";Expression={(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")}}, @{Name="processed";Expression={$true}}
    }
    "*Paginated*" {
        Write-Host "  Generating pagination examples..." -ForegroundColor Gray
        $examples["response"] = Get-PaginatedResponseExample
    }
    default {
        Write-Host "  Generating generic examples..." -ForegroundColor Gray
        $examples["request"] = @{
            name = "Example Resource"
            description = "This is an example resource"
            value = 42
        }
        $examples["response"] = @{
            id = "res_" + (New-Guid).ToString("N").Substring(0,12)
            name = "Example Resource"
            description = "This is an example resource"
            value = 42
            createdAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        }
    }
}

# Generate error examples
Write-Host "  Generating error examples..." -ForegroundColor Gray
$examples["errors"] = @{
    "400" = Get-ErrorExample -StatusCode 400
    "401" = Get-ErrorExample -StatusCode 401
    "404" = Get-ErrorExample -StatusCode 404
    "500" = Get-ErrorExample -StatusCode 500
}

Write-Host ""
Write-Host "[2/2] Saving examples..." -ForegroundColor Yellow

# Save examples as JSON files
foreach ($key in $examples.Keys) {
    $filename = "$ModelType-$key.json"
    $filepath = Join-Path $OutputPath $filename
    $examples[$key] | ConvertTo-Json -Depth 10 | Out-File -FilePath $filepath -Encoding UTF8
    Write-Host "  ✓ Saved: $filename" -ForegroundColor Green
}

# Generate cURL examples
Write-Host "  Generating cURL examples..." -ForegroundColor Gray
$curlScript = @"
#!/bin/bash
# cURL examples for $ModelType API

# Example 1: Create request
curl -X POST "https://api.example.com/api/endpoint" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '@$ModelType-request.json'

# Example 2: Get request
curl -X GET "https://api.example.com/api/endpoint/id" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Example 3: List with pagination
curl -X GET "https://api.example.com/api/endpoint?page=1&pageSize=20" \
  -H "Authorization: Bearer YOUR_TOKEN"
"@

$curlPath = Join-Path $OutputPath "$ModelType-curl-examples.sh"
$curlScript | Out-File -FilePath $curlPath -Encoding UTF8
Write-Host "  ✓ Saved: $ModelType-curl-examples.sh" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Generation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Generated files in: $OutputPath" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Review generated examples" -ForegroundColor White
Write-Host "  2. Customize with your actual data" -ForegroundColor White
Write-Host "  3. Use in API documentation" -ForegroundColor White

exit 0
