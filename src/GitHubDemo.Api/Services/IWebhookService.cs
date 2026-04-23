using GitHubDemo.Api.Models;

namespace GitHubDemo.Api.Services;

/// <summary>
/// Service interface for webhook operations
/// Generated from STRUCTURED prompt (Step 2)
/// </summary>
public interface IWebhookService
{
    /// <summary>
    /// Validates GitHub webhook signature using HMAC-SHA256
    /// </summary>
    /// <param name="payload">Raw payload string</param>
    /// <param name="signature">X-Hub-Signature-256 header value</param>
    /// <param name="secret">Webhook secret from GitHub</param>
    /// <returns>True if signature is valid, false otherwise</returns>
    Task<bool> ValidateSignatureAsync(string payload, string signature, string secret);

    /// <summary>
    /// Processes a webhook payload
    /// </summary>
    /// <param name="webhook">The webhook to process</param>
    /// <returns>The processed webhook</returns>
    /// <exception cref="ArgumentNullException">If webhook is null</exception>
    Task<WebhookPayload> ProcessWebhookAsync(WebhookPayload webhook);

    /// <summary>
    /// Gets paginated list of webhooks
    /// </summary>
    /// <param name="page">Page number (1-based)</param>
    /// <param name="pageSize">Number of items per page</param>
    /// <returns>Paginated webhook list</returns>
    Task<PaginatedResponse<WebhookPayload>> GetWebhooksAsync(int page = 1, int pageSize = 20);

    /// <summary>
    /// Gets a specific webhook by ID
    /// </summary>
    /// <param name="id">Webhook ID</param>
    /// <returns>Webhook if found, null otherwise</returns>
    Task<WebhookPayload?> GetWebhookByIdAsync(string id);
}
