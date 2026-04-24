# API Versioning Strategy

This document describes the API versioning approach and best practices.

## Versioning Approach

This API uses **URL path versioning** as the primary versioning strategy.

**Format**: `/api/v{version}/{resource}`

**Example**: `/api/v1/webhooks`, `/api/v2/webhooks`

## Version Format

- **Major version only**: `v1`, `v2`, `v3`
- Semantic versioning in API info: `1.0.0`, `1.1.0`, `2.0.0`

## Version Lifecycle

### 1. Current Version (v1)

- Actively developed
- Full support
- Bug fixes and new features
- Documentation updated

### 2. Deprecated Version

- Security fixes only
- Marked as deprecated in docs
- Sunset date announced
- Migration guide provided

### 3. Retired Version

- No longer available
- Returns 410 Gone status
- Redirect to current version docs

## Breaking Changes

A new major version is required for:

- Removing endpoints
- Removing request/response fields
- Changing field types
- Changing authentication mechanisms
- Changing error response formats

## Non-Breaking Changes

These can be added to current version:

- Adding new endpoints
- Adding optional request fields
- Adding new response fields
- Adding new error codes
- Performance improvements

## Version Negotiation

### Default Version

If no version specified, redirect to latest stable version:

```http
GET /api/webhooks HTTP/1.1
→ 301 Redirect → /api/v1/webhooks
```

### Version in URL (Recommended)

```http
GET /api/v1/webhooks HTTP/1.1
```

### Version in Header (Alternative)

```http
GET /api/webhooks HTTP/1.1
Accept: application/vnd.api.v1+json
```

### Version in Query Parameter (Not Recommended)

```http
GET /api/webhooks?version=1 HTTP/1.1
```

## Migration Guide

### From v1 to v2

Example breaking changes:

**v1 Response**:
```json
{
  "id": "123",
  "name": "Resource",
  "status": "active"
}
```

**v2 Response** (status → state):
```json
{
  "id": "123",
  "name": "Resource",
  "state": "active",
  "metadata": {}
}
```

**Migration steps**:
1. Update endpoint URLs from `/api/v1/` to `/api/v2/`
2. Update code to use `state` instead of `status`
3. Handle new `metadata` field
4. Test all integrations

## Deprecation Process

### 1. Announcement (T-6 months)

- Add deprecation notice to docs
- Include sunset date
- Provide migration guide
- Send email to API consumers

### 2. Warning Headers (T-3 months)

```http
HTTP/1.1 200 OK
Deprecation: true
Sunset: Sat, 1 Jan 2027 00:00:00 GMT
Link: </api/v2/docs>; rel="successor-version"
```

### 3. Last Call (T-1 month)

- Final reminder emails
- Sunset date imminent
- Support for migration available

### 4. Retirement (T+0)

- Version returns 410 Gone
- Redirect to migration docs

```http
HTTP/1.1 410 Gone
Content-Type: application/json

{
  "type": "https://api.example.com/errors/version-retired",
  "title": "Version Retired",
  "status": 410,
  "detail": "API v1 has been retired. Please migrate to v2.",
  "migrationGuide": "https://docs.example.com/migration/v1-to-v2"
}
```

## Implementation

### ASP.NET Core

```csharp
// Startup.cs or Program.cs
builder.Services.AddApiVersioning(options =>
{
    options.DefaultApiVersion = new ApiVersion(1, 0);
    options.AssumeDefaultVersionWhenUnspecified = true;
    options.ReportApiVersions = true;
});

// Controller
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/webhooks")]
public class WebhooksV1Controller : ControllerBase
{
    // v1 endpoints
}

[ApiVersion("2.0")]
[Route("api/v{version:apiVersion}/webhooks")]
public class WebhooksV2Controller : ControllerBase
{
    // v2 endpoints
}

// Mark as deprecated
[ApiVersion("1.0", Deprecated = true)]
public class WebhooksV1Controller : ControllerBase
{
    // ...
}
```

### Version-Specific Models

```csharp
// v1
namespace Api.V1.Models
{
    public class WebhookResponse
    {
        public string Id { get; set; }
        public string Status { get; set; }
    }
}

// v2
namespace Api.V2.Models
{
    public class WebhookResponse
    {
        public string Id { get; set; }
        public string State { get; set; } // Renamed from Status
        public Dictionary<string, object> Metadata { get; set; }
    }
}
```

## OpenAPI Specification

Generate separate specs for each version:

- `/swagger/v1/swagger.json` - OpenAPI spec for v1
- `/swagger/v2/swagger.json` - OpenAPI spec for v2

```csharp
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = "v1",
        Title = "API v1 (Deprecated)",
        Description = "Version 1 of the API. Will be retired on 2027-01-01."
    });
    
    options.SwaggerDoc("v2", new OpenApiInfo
    {
        Version = "v2",
        Title = "API v2",
        Description = "Current version of the API"
    });
});
```

## Client Implementation

### Version-aware client

```csharp
public class ApiClient
{
    private readonly HttpClient _client;
    private readonly string _apiVersion;
    
    public ApiClient(HttpClient client, string apiVersion = "v1")
    {
        _client = client;
        _apiVersion = apiVersion;
    }
    
    public async Task<T> GetAsync<T>(string endpoint)
    {
        var url = $"/api/{_apiVersion}/{endpoint}";
        return await _client.GetFromJsonAsync<T>(url);
    }
}

// Usage
var clientV1 = new ApiClient(httpClient, "v1");
var clientV2 = new ApiClient(httpClient, "v2");
```

## Best Practices

1. **Plan for versioning from day one**
2. **Keep breaking changes to a minimum**
3. **Provide clear migration guides**
4. **Give adequate deprecation notice** (6-12 months)
5. **Support 2 versions maximum** at a time
6. **Version your client SDKs** too
7. **Document all breaking changes** clearly
8. **Test backwards compatibility** thoroughly

## Resources

- [API Versioning Best Practices](https://restfulapi.net/versioning/)
- [Semantic Versioning](https://semver.org/)
- [Microsoft API Versioning](https://github.com/microsoft/aspnet-api-versioning)
- [RFC 5829 - HTTP Sunset Header](https://tools.ietf.org/html/rfc8594)
