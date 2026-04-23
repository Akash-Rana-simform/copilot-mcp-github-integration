using Microsoft.AspNetCore.Mvc;

namespace GitHubDemo.Api.Controllers;

/// <summary>
/// EXAMPLE: Code generated from VAGUE prompt
/// Prompt: "Create a webhook controller for GitHub"
/// 
/// Issues with this approach:
/// - No signature validation
/// - Generic error handling
/// - Missing logging
/// - No specific models
/// - Incomplete validation
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class WebhookControllerVague : ControllerBase
{
    // ❌ No dependency injection for services
    // ❌ No logger
    
    /// <summary>
    /// Basic webhook receiver - LACKS SECURITY
    /// </summary>
    [HttpPost]
    public IActionResult ReceiveWebhook([FromBody] object payload)
    {
        // ❌ Accepts generic object - no type safety
        // ❌ No signature validation - SECURITY RISK
        // ❌ No logging
        
        try
        {
            if (payload == null)
            {
                return BadRequest("Payload is null");
            }
            
            // ❌ Generic processing - what does this even do?
            // ❌ No business logic
            
            return Ok("Webhook received");
            // ❌ Generic response - not useful
        }
        catch (Exception ex)
        {
            // ❌ Catches all exceptions - too broad
            // ❌ Exposes stack trace - security risk
            return StatusCode(500, ex.Message);
        }
    }
    
    /// <summary>
    /// List webhooks - but where are they stored?
    /// </summary>
    [HttpGet]
    public IActionResult GetWebhooks()
    {
        // ❌ No pagination
        // ❌ No actual implementation
        // ❌ No error handling
        
        return Ok(new List<object>());
        // ❌ Returns empty list - not functional
    }
}

/*
 * PROBLEMS WITH VAGUE PROMPT APPROACH:
 * ====================================
 * 
 * 1. SECURITY ISSUES:
 *    - No signature validation (anyone can send fake webhooks)
 *    - No authentication
 *    - Exposes exception details
 * 
 * 2. VALIDATION ISSUES:
 *    - Accepts generic object
 *    - No property validation
 *    - No ModelState checks
 * 
 * 3. ERROR HANDLING:
 *    - Generic try-catch
 *    - No specific error types
 *    - Poor error messages
 * 
 * 4. MAINTAINABILITY:
 *    - No separation of concerns
 *    - No testability
 *    - No logging
 *    - No documentation
 * 
 * 5. FUNCTIONALITY:
 *    - Incomplete implementation
 *    - No actual business logic
 *    - No data persistence
 * 
 * VERDICT: NOT PRODUCTION READY
 * Time to make production-ready: 2-3 hours of work
 * Code Review Score: 2/10
 */
