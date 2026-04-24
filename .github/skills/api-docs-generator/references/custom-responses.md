# Custom Response Types

This document describes custom response types used across the API.

## Standard Responses

### Success Response (200 OK)

Generic successful response with data.

```json
{
  "data": {},
  "message": "Success"
}
```

### Created Response (201 Created)

Resource successfully created.

```json
{
  "id": "resource-id",
  "message": "Resource created successfully",
  "location": "/api/resource/resource-id"
}
```

### No Content (204 No Content)

Successful operation with no response body.

Used for: DELETE operations, successful updates without data return.

## Error Responses

### ProblemDetails (RFC 7807)

Standard error response format.

```json
{
  "type": "string",
  "title": "string",
  "status": 400,
  "detail": "string",
  "instance": "string",
  "errors": {}
}
```

**Properties**:
- `type` (string) - URI identifying the problem type
- `title` (string) - Short, human-readable summary
- `status` (integer) - HTTP status code
- `detail` (string) - Detailed explanation
- `instance` (string, optional) - URI reference to specific occurrence
- `errors` (object, optional) - Validation errors by field

### ValidationProblemDetails

Extended error response for validation failures.

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred",
  "status": 400,
  "errors": {
    "field1": ["Error message 1", "Error message 2"],
    "field2": ["Error message"]
  }
}
```

## Pagination Responses

### PaginatedResponse<T>

Standard pagination wrapper.

```json
{
  "data": [],
  "page": 1,
  "pageSize": 20,
  "totalCount": 100,
  "totalPages": 5,
  "hasNextPage": true,
  "hasPreviousPage": false
}
```

**Properties**:
- `data` (array) - Array of items for current page
- `page` (integer) - Current page number (1-based)
- `pageSize` (integer) - Number of items per page
- `totalCount` (integer) - Total number of items
- `totalPages` (integer) - Total number of pages
- `hasNextPage` (boolean) - Whether there's a next page
- `hasPreviousPage` (boolean) - Whether there's a previous page

**Example Implementation**:

```csharp
public class PaginatedResponse<T>
{
    public List<T> Data { get; set; } = new();
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int TotalCount { get; set; }
    public int TotalPages => (int)Math.Ceiling((double)TotalCount / PageSize);
    public bool HasNextPage => Page < TotalPages;
    public bool HasPreviousPage => Page > 1;
}
```

## Async Operation Responses

### AcceptedResponse (202 Accepted)

Operation accepted for processing.

```json
{
  "operationId": "op-123456",
  "status": "pending",
  "statusUrl": "/api/operations/op-123456",
  "estimatedCompletionTime": "2026-04-24T10:05:00Z"
}
```

Use for: Long-running operations, background jobs.

### OperationStatus

Check status of async operation.

```json
{
  "operationId": "op-123456",
  "status": "completed",
  "progress": 100,
  "result": {},
  "error": null,
  "startedAt": "2026-04-24T10:00:00Z",
  "completedAt": "2026-04-24T10:04:30Z"
}
```

**Status values**: `pending`, `running`, `completed`, `failed`, `cancelled`

## Rate Limit Response

### Headers

Rate limit information in response headers:

```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1640995200
X-RateLimit-Retry-After: 30
```

### 429 Too Many Requests

```json
{
  "type": "https://tools.ietf.org/html/rfc6585#section-4",
  "title": "Too Many Requests",
  "status": 429,
  "detail": "Rate limit exceeded. Try again in 30 seconds.",
  "retryAfter": 30
}
```

## Batch Operation Responses

### BatchResult<T>

Result of batch operation.

```json
{
  "totalRequested": 10,
  "successCount": 8,
  "failureCount": 2,
  "results": [
    {
      "index": 0,
      "success": true,
      "data": {}
    },
    {
      "index": 5,
      "success": false,
      "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid data"
      }
    }
  ]
}
```

## Health Check Response

### HealthStatus

API health status.

```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2026-04-24T10:00:00Z",
  "services": {
    "database": "healthy",
    "cache": "healthy",
    "external-api": "degraded"
  }
}
```

**Status values**: `healthy`, `degraded`, `unhealthy`

## Implementation Examples

### C# Response Models

```csharp
// Success with data
public class SuccessResponse<T>
{
    public T Data { get; set; }
    public string Message { get; set; } = "Success";
}

// Created response
public class CreatedResponse
{
    public string Id { get; set; }
    public string Message { get; set; }
    public string Location { get; set; }
}

// Async operation
public class AsyncOperationResponse
{
    public string OperationId { get; set; }
    public string Status { get; set; }
    public string StatusUrl { get; set; }
    public DateTime? EstimatedCompletionTime { get; set; }
}
```

### Controller Usage

```csharp
// Return paginated data
[HttpGet]
public async Task<ActionResult<PaginatedResponse<Item>>> GetItems(
    [FromQuery] int page = 1,
    [FromQuery] int pageSize = 20)
{
    var items = await _service.GetItemsAsync(page, pageSize);
    return Ok(items);
}

// Return created resource
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateRequest request)
{
    var created = await _service.CreateAsync(request);
    
    return CreatedAtAction(
        nameof(GetById),
        new { id = created.Id },
        new CreatedResponse
        {
            Id = created.Id,
            Message = "Resource created successfully",
            Location = $"/api/resource/{created.Id}"
        }
    );
}

// Return validation error
[HttpPost]
public IActionResult Validate([FromBody] Request request)
{
    if (!ModelState.IsValid)
    {
        return BadRequest(new ValidationProblemDetails(ModelState));
    }
    
    return Ok();
}
```

## See Also

- [RFC 7807 - Problem Details](https://tools.ietf.org/html/rfc7807)
- [HTTP Status Codes](https://httpstatuses.com/)
- [REST API Best Practices](https://restfulapi.net/)
