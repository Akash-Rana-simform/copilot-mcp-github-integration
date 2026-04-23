using System.Security.Cryptography;
using System.Text;
using GitHubDemo.Api.Models;

namespace GitHubDemo.Api.Services;

/// <summary>
/// Implementation of webhook service
/// Generated from STRUCTURED prompt (Step 3)
/// </summary>
public class WebhookService : IWebhookService
{
    private readonly ILogger<WebhookService> _logger;
    private readonly List<WebhookPayload> _webhooks = new(); // In-memory storage for demo

    public WebhookService(ILogger<WebhookService> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    /// <inheritdoc/>
    public Task<bool> ValidateSignatureAsync(string payload, string signature, string secret)
    {
        if (string.IsNullOrEmpty(payload))
            throw new ArgumentNullException(nameof(payload));
        
        if (string.IsNullOrEmpty(signature))
            throw new ArgumentNullException(nameof(signature));
        
        if (string.IsNullOrEmpty(secret))
            throw new ArgumentNullException(nameof(secret));

        try
        {
            // Remove 'sha256=' prefix if present
            var signatureValue = signature.StartsWith("sha256=") 
                ? signature[7..] 
                : signature;

            // Compute HMAC-SHA256
            var secretBytes = Encoding.UTF8.GetBytes(secret);
            var payloadBytes = Encoding.UTF8.GetBytes(payload);
            
            using var hmac = new HMACSHA256(secretBytes);
            var hash = hmac.ComputeHash(payloadBytes);
            var computedSignature = BitConverter.ToString(hash).Replace("-", "").ToLower();

            var isValid = signatureValue.Equals(computedSignature, StringComparison.OrdinalIgnoreCase);

            if (!isValid)
            {
                _logger.LogWarning("Webhook signature validation failed");
            }

            return Task.FromResult(isValid);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating webhook signature");
            return Task.FromResult(false);
        }
    }

    /// <inheritdoc/>
    public Task<WebhookPayload> ProcessWebhookAsync(WebhookPayload webhook)
    {
        if (webhook == null)
            throw new ArgumentNullException(nameof(webhook));

        try
        {
            _logger.LogInformation(
                "Processing webhook: Event={Event}, Repository={Repository}, Sender={Sender}",
                webhook.Event, webhook.Repository, webhook.Sender);

            // Mark as processed
            webhook.Processed = true;
            webhook.Timestamp = DateTime.UtcNow;

            // Store webhook (in-memory for demo)
            _webhooks.Add(webhook);

            _logger.LogInformation("Webhook processed successfully: Id={Id}", webhook.Id);

            return Task.FromResult(webhook);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing webhook: Id={Id}", webhook.Id);
            throw;
        }
    }

    /// <inheritdoc/>
    public Task<PaginatedResponse<WebhookPayload>> GetWebhooksAsync(int page = 1, int pageSize = 20)
    {
        if (page < 1)
            throw new ArgumentException("Page must be greater than 0", nameof(page));
        
        if (pageSize < 1 || pageSize > 100)
            throw new ArgumentException("Page size must be between 1 and 100", nameof(pageSize));

        try
        {
            var totalCount = _webhooks.Count;
            var webhooks = _webhooks
                .OrderByDescending(w => w.Timestamp)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            _logger.LogInformation(
                "Retrieved {Count} webhooks (Page {Page}, PageSize {PageSize})",
                webhooks.Count, page, pageSize);

            var response = new PaginatedResponse<WebhookPayload>
            {
                Data = webhooks,
                Page = page,
                PageSize = pageSize,
                TotalCount = totalCount
            };

            return Task.FromResult(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving webhooks");
            throw;
        }
    }

    /// <inheritdoc/>
    public Task<WebhookPayload?> GetWebhookByIdAsync(string id)
    {
        if (string.IsNullOrEmpty(id))
            throw new ArgumentNullException(nameof(id));

        try
        {
            var webhook = _webhooks.FirstOrDefault(w => w.Id == id);

            if (webhook == null)
            {
                _logger.LogInformation("Webhook not found: Id={Id}", id);
            }
            else
            {
                _logger.LogInformation("Webhook retrieved: Id={Id}", id);
            }

            return Task.FromResult(webhook);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving webhook: Id={Id}", id);
            throw;
        }
    }
}
