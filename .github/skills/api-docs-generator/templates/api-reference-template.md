# API Reference

> **Version**: 1.0.0  
> **Base URL**: `https://api.example.com`  
> **Last Updated**: [Date]

## Table of Contents

- [Authentication](#authentication)
- [Rate Limiting](#rate-limiting)
- [Error Handling](#error-handling)
- [Endpoints](#endpoints)
  - [Resource Name](#resource-name)
- [Models](#models)
- [Examples](#examples)

---

## Authentication

This API uses **Bearer Token** authentication. Include your API token in the `Authorization` header:

```
Authorization: Bearer YOUR_API_TOKEN
```

### Getting a Token

[Instructions for obtaining an API token]

### Token Expiration

Tokens expire after 24 hours. Refresh your token using the `/auth/refresh` endpoint.

---

## Rate Limiting

- **Requests per minute**: 60
- **Requests per hour**: 1000

Rate limit headers are included in every response:

```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1640995200
```

When you exceed the rate limit, you'll receive a `429 Too Many Requests` response.

---

## Error Handling

All errors follow the [RFC 7807](https://tools.ietf.org/html/rfc7807) Problem Details format:

```json
{
  "type": "https://example.com/errors/validation",
  "title": "Validation Error",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "errors": {
    "field": ["Error message"]
  }
}
```

### Common Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Successful request |
| 201 | Created | Resource successfully created |
| 400 | Bad Request | Invalid input or validation error |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server-side error |

---

## Endpoints

### Resource Name

#### GET /api/resource

Get a list of resources.

**Request**:
```http
GET /api/resource?page=1&pageSize=20 HTTP/1.1
Host: api.example.com
Authorization: Bearer YOUR_TOKEN
```

**Query Parameters**:
- `page` (integer, optional) - Page number (default: 1)
- `pageSize` (integer, optional) - Items per page (default: 20, max: 100)

**Response** `200 OK`:
```json
{
  "data": [],
  "page": 1,
  "pageSize": 20,
  "totalCount": 100,
  "totalPages": 5
}
```

**Errors**:
- `400` - Invalid pagination parameters
- `401` - Not authenticated
- `500` - Server error

---

#### POST /api/resource

Create a new resource.

**Request**:
```http
POST /api/resource HTTP/1.1
Host: api.example.com
Authorization: Bearer YOUR_TOKEN
Content-Type: application/json

{
  "name": "Resource Name",
  "description": "Description"
}
```

**Request Body**:
```json
{
  "name": "string (required, max 100 chars)",
  "description": "string (optional, max 500 chars)"
}
```

**Response** `201 Created`:
```json
{
  "id": "abc123",
  "name": "Resource Name",
  "description": "Description",
  "createdAt": "2026-04-24T10:00:00Z"
}
```

**Errors**:
- `400` - Validation error
- `401` - Not authenticated
- `500` - Server error

---

#### GET /api/resource/{id}

Get a specific resource by ID.

**Request**:
```http
GET /api/resource/abc123 HTTP/1.1
Host: api.example.com
Authorization: Bearer YOUR_TOKEN
```

**Path Parameters**:
- `id` (string, required) - Resource ID

**Response** `200 OK`:
```json
{
  "id": "abc123",
  "name": "Resource Name",
  "description": "Description",
  "createdAt": "2026-04-24T10:00:00Z"
}
```

**Errors**:
- `404` - Resource not found
- `401` - Not authenticated
- `500` - Server error

---

## Models

### ResourceModel

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "createdAt": "string (ISO 8601 date-time)"
}
```

**Properties**:
- `id` (string, read-only) - Unique identifier
- `name` (string, required) - Resource name (max 100 chars)
- `description` (string, optional) - Description (max 500 chars)
- `createdAt` (string, read-only) - Creation timestamp

---

### PaginatedResponse

```json
{
  "data": [],
  "page": 1,
  "pageSize": 20,
  "totalCount": 100,
  "totalPages": 5
}
```

**Properties**:
- `data` (array) - Array of resources
- `page` (integer) - Current page number
- `pageSize` (integer) - Items per page
- `totalCount` (integer) - Total number of items
- `totalPages` (integer) - Total number of pages

---

### ProblemDetails

```json
{
  "type": "string",
  "title": "string",
  "status": 400,
  "detail": "string",
  "errors": {}
}
```

**Properties**:
- `type` (string) - URI reference to error type
- `title` (string) - Short, human-readable title
- `status` (integer) - HTTP status code
- `detail` (string) - Detailed error description
- `errors` (object, optional) - Validation errors by field

---

## Examples

### cURL Examples

```bash
# Get all resources
curl -X GET "https://api.example.com/api/resource?page=1&pageSize=20" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Create a resource
curl -X POST "https://api.example.com/api/resource" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Resource",
    "description": "Description here"
  }'

# Get specific resource
curl -X GET "https://api.example.com/api/resource/abc123" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### C# Examples

```csharp
using System.Net.Http;
using System.Net.Http.Json;

var client = new HttpClient
{
    BaseAddress = new Uri("https://api.example.com")
};
client.DefaultRequestHeaders.Add("Authorization", "Bearer YOUR_TOKEN");

// Get all resources
var response = await client.GetFromJsonAsync<PaginatedResponse<ResourceModel>>(
    "/api/resource?page=1&pageSize=20");

// Create a resource
var newResource = new { name = "New Resource", description = "Description" };
var createResponse = await client.PostAsJsonAsync("/api/resource", newResource);
var created = await createResponse.Content.ReadFromJsonAsync<ResourceModel>();

// Get specific resource
var resource = await client.GetFromJsonAsync<ResourceModel>("/api/resource/abc123");
```

---

## Support

For questions or issues:
- **Email**: support@example.com
- **Documentation**: https://docs.example.com
- **GitHub**: https://github.com/org/repo

---

**Generated**: [Date]  
**Generator**: API Docs Generator Skill
