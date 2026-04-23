# GitHub Webhook Service Guide

A comprehensive guide to using the GitHub Webhook Service for secure webhook handling and processing.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [API Reference](#api-reference)
- [Security](#security)
- [Common Scenarios](#common-scenarios)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Overview

The Webhook Service provides a secure, production-ready solution for receiving and processing GitHub webhooks in your .NET application. It includes:

- ✅ **HMAC-SHA256 signature validation** for security
- ✅ **Structured payload handling** with validation
- ✅ **Comprehensive logging** for debugging
- ✅ **Pagination support** for webhook history
- ✅ **Type-safe models** with data annotations

**Use Cases:**
- Automate deployments when code is pushed
- Trigger CI/CD pipelines on pull requests
- Monitor repository activity
- Sync data with external systems
- Audit repository changes

---

## Prerequisites

Before using the Webhook Service, ensure you have:

1. **.NET 8 SDK** installed
2. **GitHub repository** with admin access
3. **Webhook secret** configured in GitHub
4. **This project** running and accessible from the internet (or use tunneling for local dev)

---

## Quick Start

### 1. Register the Service

The service is already registered in `Program.cs`:

```csharp
builder.Services.AddSingleton<IWebhookService, WebhookService>();
```

### 2. Configure the Webhook Secret

Add your GitHub webhook secret to `appsettings.json`:

```json
{
  "WebhookSecret": "your-webhook-secret-from-github"
}
```

⚠️ **Security**: In production, use environment variables or Azure Key Vault instead of storing secrets in `appsettings.json`.

### 3. Set Up GitHub Webhook

1. Go to your GitHub repository → **Settings** → **Webhooks**
2. Click **Add webhook**
3. Configure:
   - **Payload URL**: `https://your-domain.com/api/webhook`
   - **Content type**: `application/json`
   - **Secret**: Enter a strong secret (save this for step 2)
   - **Events**: Select events you want to receive
4. Click **Add webhook**

### 4. Test the Integration

Send a test webhook from GitHub or use the test endpoint:

```bash
curl -X POST https://your-domain.com/api/webhook \
  -H "Content-Type: application/json" \
  -H "X-Hub-Signature-256: sha256=YOUR_SIGNATURE" \
  -d '{
    "event": "push",
    "repository": "owner/repo",
    "sender": "username",
    "payload": {}
  }'
```

---

## How It Works

### Architecture

```
GitHub → Webhook → Controller → Service → Storage
                      ↓
                 Validation
```

1. **GitHub sends webhook** with `X-Hub-Signature-256` header
2. **Controller receives** and extracts signature
3. **Service validates** signature using HMAC-SHA256
4. **If valid**: Process and store webhook
5. **If invalid**: Return 401 Unauthorized

### Signature Validation Process

GitHub signs each webhook with your secret using HMAC-SHA256:

```
HMAC-SHA256(webhook_secret, payload_body) = signature
```

Our service:
1. Receives the payload and signature
2. Computes its own signature using the same secret
3. Compares signatures
4. Accepts only if they match

This ensures:
- ✅ The webhook came from GitHub
- ✅ The payload wasn't tampered with
- ✅ The sender knows the secret

---

## API Reference

### `IWebhookService`

The main service interface for webhook operations.

#### `ValidateSignatureAsync`

Validates GitHub webhook signature using HMAC-SHA256.

```csharp
Task<bool> ValidateSignatureAsync(
    string payload,     // Raw JSON payload
    string signature,   // X-Hub-Signature-256 header value
    string secret       // Your webhook secret
)
```

**Returns**: `true` if signature is valid, `false` otherwise

**Throws**:
- `ArgumentNullException` if any parameter is null or empty

**Example**:

```csharp
var isValid = await _webhookService.ValidateSignatureAsync(
    payloadJson,
    "sha256=abcdef123456...",
    "my-webhook-secret"
);

if (!isValid)
{
    return Unauthorized("Invalid signature");
}
```

**How it works**:
1. Removes `sha256=` prefix from signature
2. Converts payload and secret to bytes
3. Computes HMAC-SHA256 hash
4. Compares computed hash with provided signature
5. Returns true if they match (case-insensitive)

---

#### `ProcessWebhookAsync`

Processes a validated webhook payload.

```csharp
Task<WebhookPayload> ProcessWebhookAsync(WebhookPayload webhook)
```

**Parameters**:
- `webhook`: The webhook payload to process (must not be null)

**Returns**: The processed webhook with updated timestamp and status

**Throws**:
- `ArgumentNullException` if webhook is null
- `Exception` if processing fails (logged and re-thrown)

**Example**:

```csharp
var webhook = new WebhookPayload
{
    Event = "push",
    Repository = "owner/repo",
    Sender = "username",
    Payload = JsonDocument.Parse(requestBody)
};

var processed = await _webhookService.ProcessWebhookAsync(webhook);

Console.WriteLine($"Processed webhook {processed.Id} at {processed.Timestamp}");
```

**What it does**:
1. Validates webhook is not null
2. Logs webhook details (event, repository, sender)
3. Marks webhook as processed
4. Updates timestamp to current UTC time
5. Stores webhook (in-memory for demo, use database in production)
6. Returns the processed webhook

---

#### `GetWebhooksAsync`

Retrieves a paginated list of webhooks.

```csharp
Task<PaginatedResponse<WebhookPayload>> GetWebhooksAsync(
    int page = 1,       // Page number (1-based)
    int pageSize = 20   // Items per page (1-100)
)
```

**Returns**: `PaginatedResponse<WebhookPayload>` containing:
- `Data`: List of webhooks for this page
- `Page`: Current page number
- `PageSize`: Items per page
- `TotalCount`: Total number of webhooks
- `TotalPages`: Total number of pages

**Throws**:
- `ArgumentException` if page < 1 or pageSize not in range [1, 100]

**Example**:

```csharp
// Get first page
var page1 = await _webhookService.GetWebhooksAsync(1, 10);
Console.WriteLine($"Showing {page1.Data.Count} of {page1.TotalCount} webhooks");

// Get next page
var page2 = await _webhookService.GetWebhooksAsync(2, 10);
```

---

#### `GetWebhookByIdAsync`

Retrieves a specific webhook by its ID.

```csharp
Task<WebhookPayload?> GetWebhookByIdAsync(string id)
```

**Returns**: The webhook if found, `null` otherwise

**Throws**:
- `ArgumentNullException` if id is null or empty

**Example**:

```csharp
var webhook = await _webhookService.GetWebhookByIdAsync("webhook-id-123");

if (webhook == null)
{
    return NotFound($"Webhook {id} not found");
}

return Ok(webhook);
```

---

## Security

### Signature Validation

**Always validate signatures** before processing webhooks. This prevents:
- ❌ Fake webhooks from malicious actors
- ❌ Payload tampering
- ❌ Replay attacks (with timestamp checks)

### Best Practices

1. **Use Strong Secrets**
   ```bash
   # Generate a strong secret
   openssl rand -base64 32
   ```

2. **Store Secrets Securely**
   - ✅ Environment variables
   - ✅ Azure Key Vault
   - ✅ AWS Secrets Manager
   - ❌ NOT in source code
   - ❌ NOT in appsettings.json (production)

3. **Use HTTPS**
   - Always use HTTPS endpoints
   - GitHub won't send webhooks to HTTP in production

4. **Log Security Events**
   ```csharp
   if (!isValid)
   {
       _logger.LogWarning(
           "Invalid webhook signature from {Sender}",
           webhook.Sender
       );
   }
   ```

5. **Rate Limiting**
   - Consider adding rate limiting to prevent abuse
   - Use ASP.NET Core rate limiting middleware

---

## Common Scenarios

### Scenario 1: Deploy on Push to Main

```csharp
public async Task<IActionResult> ReceiveWebhook([FromBody] WebhookRequest request)
{
    // ... validation ...

    if (request.Event == "push" && request.Repository == "owner/repo")
    {
        var payload = request.Payload.RootElement;
        var branch = payload.GetProperty("ref").GetString();

        if (branch == "refs/heads/main")
        {
            _logger.LogInformation("Push to main detected, triggering deployment");
            await TriggerDeploymentAsync();
        }
    }

    // ... process webhook ...
}
```

### Scenario 2: Notify Team of New PRs

```csharp
if (request.Event == "pull_request" && request.Action == "opened")
{
    var prNumber = request.Payload.RootElement
        .GetProperty("number")
        .GetInt32();

    var prTitle = request.Payload.RootElement
        .GetProperty("pull_request")
        .GetProperty("title")
        .GetString();

    await NotifyTeamAsync($"New PR #{prNumber}: {prTitle}");
}
```

### Scenario 3: Audit Repository Changes

```csharp
// Log all webhook events for audit
_logger.LogInformation(
    "Webhook received: Event={Event}, Action={Action}, Repository={Repository}, User={User}",
    request.Event,
    request.Action ?? "N/A",
    request.Repository,
    request.Sender
);

// Store in database for compliance
await _auditService.LogWebhookAsync(webhook);
```

---

## Troubleshooting

### Issue: "Invalid signature" errors

**Symptoms**: Webhooks return 401 Unauthorized

**Solutions**:
1. Verify the webhook secret matches in both GitHub and your app
2. Check that you're using the raw payload body (not parsed JSON)
3. Ensure signature includes `sha256=` prefix
4. Verify you're reading the `X-Hub-Signature-256` header correctly

**Debug**:
```csharp
_logger.LogDebug(
    "Signature validation - Received: {Received}, Computed: {Computed}",
    signature,
    computedSignature
);
```

### Issue: Webhooks not being received

**Solutions**:
1. Check GitHub webhook delivery history (Settings → Webhooks → Recent Deliveries)
2. Verify your endpoint is publicly accessible
3. Check firewall rules
4. For local development, use ngrok or similar tunneling tool
5. Verify the webhook URL is correct

**Test locally**:
```bash
# Use ngrok for local testing
ngrok http 5000

# Update GitHub webhook URL to:
# https://your-ngrok-url.ngrok.io/api/webhook
```

### Issue: "Page must be greater than 0" error

**Cause**: Invalid pagination parameters

**Solution**:
```csharp
// Validate parameters
if (page < 1) page = 1;
if (pageSize < 1) pageSize = 20;
if (pageSize > 100) pageSize = 100;

var webhooks = await _webhookService.GetWebhooksAsync(page, pageSize);
```

### Issue: Memory issues with many webhooks

**Cause**: In-memory storage (demo implementation)

**Solution**: Use a database for production:

```csharp
// Replace in-memory list with database
public class WebhookService : IWebhookService
{
    private readonly DbContext _context;

    public async Task<WebhookPayload> ProcessWebhookAsync(WebhookPayload webhook)
    {
        webhook.Processed = true;
        webhook.Timestamp = DateTime.UtcNow;

        await _context.Webhooks.AddAsync(webhook);
        await _context.SaveChangesAsync();

        return webhook;
    }
}
```

---

## Best Practices

### 1. **Async Processing**

For long-running operations, use background processing:

```csharp
public async Task<IActionResult> ReceiveWebhook([FromBody] WebhookRequest request)
{
    // Validate and respond quickly
    var isValid = await ValidateAsync(request);
    if (!isValid) return Unauthorized();

    // Queue for background processing
    await _queue.EnqueueAsync(new WebhookJob
    {
        WebhookId = webhook.Id,
        Event = webhook.Event
    });

    return Ok(new { message = "Webhook queued for processing" });
}
```

### 2. **Idempotency**

Handle duplicate webhooks gracefully:

```csharp
public async Task ProcessWebhookAsync(WebhookPayload webhook)
{
    // Check if already processed
    var existing = await _context.Webhooks
        .FirstOrDefaultAsync(w => w.Id == webhook.Id);

    if (existing?.Processed == true)
    {
        _logger.LogInformation("Webhook {Id} already processed", webhook.Id);
        return;
    }

    // Process...
}
```

### 3. **Logging**

Log important events:

```csharp
// Success
_logger.LogInformation(
    "Webhook processed: Event={Event}, Repository={Repository}, Duration={Duration}ms",
    webhook.Event,
    webhook.Repository,
    stopwatch.ElapsedMilliseconds
);

// Warnings
_logger.LogWarning(
    "Invalid signature from {Sender} for {Repository}",
    webhook.Sender,
    webhook.Repository
);

// Errors
_logger.LogError(
    exception,
    "Failed to process webhook {Id}: {Event} from {Repository}",
    webhook.Id,
    webhook.Event,
    webhook.Repository
);
```

### 4. **Error Handling**

Return appropriate status codes:

```csharp
try
{
    await ProcessWebhookAsync(webhook);
    return Ok();
}
catch (ArgumentException ex)
{
    return BadRequest(new { error = ex.Message });
}
catch (UnauthorizedAccessException)
{
    return Unauthorized();
}
catch (Exception ex)
{
    _logger.LogError(ex, "Webhook processing failed");
    return StatusCode(500, new { error = "Internal server error" });
}
```

---

## Additional Resources

- **[GitHub Webhooks Documentation](https://docs.github.com/webhooks)**
- **[Webhook Controller Implementation](../../src/GitHubDemo.Api/Controllers/WebhookController.cs)**
- **[Prompt Engineering Experiment](./prompt-engineering-experiment.md)** - How this was built
- **[API Testing Script](./test-webhook-comparison.ps1)**

---

## Summary

The Webhook Service provides:

- ✅ **Security**: HMAC-SHA256 signature validation
- ✅ **Type Safety**: Strongly-typed models with validation
- ✅ **Observability**: Comprehensive logging
- ✅ **Scalability**: Pagination and async processing
- ✅ **Maintainability**: Clean architecture with dependency injection

**Next Steps**:
1. Configure your webhook secret
2. Set up GitHub webhook
3. Test with sample events
4. Implement your custom webhook handlers
5. Deploy to production with proper secret management

**Questions?** Check the [FAQ](./FAQ.md) or open an issue on GitHub.

---

**Last Updated**: April 23, 2026  
**Version**: 1.0  
**Author**: Documentation Writer Agent
