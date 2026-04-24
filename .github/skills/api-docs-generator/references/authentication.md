# Authentication Schemes

This document describes the authentication mechanisms supported by the API.

## Supported Schemes

### 1. Bearer Token (JWT)

**Recommended for**: User authentication, third-party integrations

**How it works**:
1. Obtain a JWT token from `/auth/login` endpoint
2. Include token in `Authorization` header:
   ```
   Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

**Token Structure**:
```json
{
  "sub": "user-id",
  "name": "User Name",
  "email": "user@example.com",
  "role": "admin",
  "exp": 1640995200
}
```

**Token Expiration**: 24 hours

**Refresh**: Use `/auth/refresh` endpoint with valid token

### 2. API Key

**Recommended for**: Service-to-service communication, webhooks

**How it works**:
1. Generate API key from admin panel
2. Include key in `X-API-Key` header:
   ```
   X-API-Key: sk_live_1234567890abcdef
   ```

**Key Rotation**: Keys should be rotated every 90 days

### 3. Webhook Signature (HMAC-SHA256)

**Recommended for**: GitHub webhooks, external webhook validation

**How it works**:
1. Server computes HMAC-SHA256 of payload using shared secret
2. Signature sent in `X-Hub-Signature-256` header
3. Client verifies by recomputing and comparing signatures

**Example**:
```
X-Hub-Signature-256: sha256=1234567890abcdef...
```

## Security Best Practices

1. **Always use HTTPS** in production
2. **Never expose tokens** in client-side code
3. **Store secrets securely** (environment variables, key vaults)
4. **Rotate credentials regularly**
5. **Use least privilege** principle for API keys
6. **Monitor for suspicious activity**
7. **Implement rate limiting**
8. **Log authentication failures**

## Implementation Examples

### Bearer Token in C#

```csharp
var client = new HttpClient();
client.DefaultRequestHeaders.Authorization = 
    new AuthenticationHeaderValue("Bearer", token);

var response = await client.GetAsync("https://api.example.com/endpoint");
```

### API Key in C#

```csharp
var client = new HttpClient();
client.DefaultRequestHeaders.Add("X-API-Key", apiKey);

var response = await client.GetAsync("https://api.example.com/endpoint");
```

### Webhook Signature Validation in C#

```csharp
using System.Security.Cryptography;
using System.Text;

public bool ValidateSignature(string payload, string signature, string secret)
{
    var secretBytes = Encoding.UTF8.GetBytes(secret);
    var payloadBytes = Encoding.UTF8.GetBytes(payload);
    
    using var hmac = new HMACSHA256(secretBytes);
    var hash = hmac.ComputeHash(payloadBytes);
    var computedSignature = "sha256=" + 
        BitConverter.ToString(hash).Replace("-", "").ToLower();
    
    return signature.Equals(computedSignature, 
        StringComparison.OrdinalIgnoreCase);
}
```

## Error Responses

### 401 Unauthorized

Missing or invalid authentication credentials.

```json
{
  "type": "https://tools.ietf.org/html/rfc7235#section-3.1",
  "title": "Unauthorized",
  "status": 401,
  "detail": "Invalid or missing authentication token"
}
```

### 403 Forbidden

Valid credentials but insufficient permissions.

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.3",
  "title": "Forbidden",
  "status": 403,
  "detail": "You do not have permission to access this resource"
}
```

## See Also

- [Security Best Practices](https://owasp.org/www-project-api-security/)
- [JWT.io](https://jwt.io/) - JWT debugger
- [GitHub Webhooks](https://docs.github.com/webhooks) - Webhook signature validation
