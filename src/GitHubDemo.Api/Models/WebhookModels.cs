using System.ComponentModel.DataAnnotations;
using System.Text.Json;

namespace GitHubDemo.Api.Models;

/// <summary>
/// Represents a GitHub webhook payload
/// Generated from STRUCTURED prompt (Step 1)
/// </summary>
public class WebhookPayload
{
    /// <summary>
    /// Unique identifier for the webhook event
    /// </summary>
    [Required]
    [MaxLength(100)]
    public string Id { get; set; } = Guid.NewGuid().ToString();

    /// <summary>
    /// GitHub event type (push, pull_request, issues, etc.)
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string Event { get; set; } = string.Empty;

    /// <summary>
    /// Action performed (opened, closed, synchronize, etc.)
    /// </summary>
    [MaxLength(50)]
    public string? Action { get; set; }

    /// <summary>
    /// Repository full name (owner/repo)
    /// </summary>
    [Required]
    [MaxLength(200)]
    public string Repository { get; set; } = string.Empty;

    /// <summary>
    /// GitHub username who triggered the event
    /// </summary>
    [Required]
    [MaxLength(100)]
    public string Sender { get; set; } = string.Empty;

    /// <summary>
    /// Raw webhook payload from GitHub
    /// </summary>
    [Required]
    public JsonDocument Payload { get; set; } = JsonDocument.Parse("{}");

    /// <summary>
    /// X-Hub-Signature-256 header value for verification
    /// </summary>
    [Required]
    [MaxLength(256)]
    public string Signature { get; set; } = string.Empty;

    /// <summary>
    /// When the webhook was received
    /// </summary>
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// Whether the webhook has been processed
    /// </summary>
    public bool Processed { get; set; } = false;
}

/// <summary>
/// Request model for incoming webhooks
/// Generated from STRUCTURED prompt (Step 5)
/// </summary>
public class WebhookRequest
{
    [Required(ErrorMessage = "Event type is required")]
    [MaxLength(50, ErrorMessage = "Event type cannot exceed 50 characters")]
    public string Event { get; set; } = string.Empty;

    [MaxLength(50, ErrorMessage = "Action cannot exceed 50 characters")]
    public string? Action { get; set; }

    [Required(ErrorMessage = "Repository is required")]
    [MaxLength(200, ErrorMessage = "Repository name cannot exceed 200 characters")]
    public string Repository { get; set; } = string.Empty;

    [Required(ErrorMessage = "Sender is required")]
    [MaxLength(100, ErrorMessage = "Sender cannot exceed 100 characters")]
    public string Sender { get; set; } = string.Empty;

    [Required(ErrorMessage = "Payload is required")]
    public JsonDocument Payload { get; set; } = JsonDocument.Parse("{}");
}

/// <summary>
/// Response model for webhook operations
/// Generated from STRUCTURED prompt (Step 5)
/// </summary>
public class WebhookResponse
{
    public string Id { get; set; } = string.Empty;
    public string Event { get; set; } = string.Empty;
    public string Repository { get; set; } = string.Empty;
    public string Sender { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; }
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
}

/// <summary>
/// Paginated response wrapper
/// Generated from STRUCTURED prompt (Step 5)
/// </summary>
public class PaginatedResponse<T>
{
    public List<T> Data { get; set; } = new();
    
    [Range(1, int.MaxValue, ErrorMessage = "Page must be greater than 0")]
    public int Page { get; set; }
    
    [Range(1, 100, ErrorMessage = "Page size must be between 1 and 100")]
    public int PageSize { get; set; }
    
    public int TotalCount { get; set; }
    
    public int TotalPages => (int)Math.Ceiling((double)TotalCount / PageSize);
}
