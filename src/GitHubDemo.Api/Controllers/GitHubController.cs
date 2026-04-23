using GitHubDemo.Api.Models;
using GitHubDemo.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace GitHubDemo.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class GitHubController : ControllerBase
{
    private readonly IGitHubService _gitHubService;
    private readonly ILogger<GitHubController> _logger;

    public GitHubController(IGitHubService gitHubService, ILogger<GitHubController> logger)
    {
        _gitHubService = gitHubService;
        _logger = logger;
    }

    [HttpGet("repositories")]
    public async Task<IActionResult> GetRepositories()
    {
        try
        {
            var repos = await _gitHubService.GetUserRepositoriesAsync();
            return Ok(repos.Select(r => new
            {
                r.Name,
                r.FullName,
                r.Description,
                r.HtmlUrl,
                r.Language,
                r.StargazersCount,
                r.ForksCount
            }));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching repositories");
            return StatusCode(500, new { error = ex.Message });
        }
    }

    [HttpGet("pullrequests/{owner}/{repo}")]
    public async Task<IActionResult> GetPullRequests(string owner, string repo)
    {
        try
        {
            var prs = await _gitHubService.GetPullRequestsAsync(owner, repo);
            return Ok(prs.Select(pr => new
            {
                pr.Number,
                pr.Title,
                pr.State,
                pr.User.Login,
                pr.CreatedAt,
                pr.HtmlUrl
            }));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching pull requests for {Owner}/{Repo}", owner, repo);
            return StatusCode(500, new { error = ex.Message });
        }
    }

    [HttpPost("issues/{owner}/{repo}")]
    public async Task<IActionResult> CreateIssue(string owner, string repo, [FromBody] CreateIssueRequest request)
    {
        try
        {
            var issue = await _gitHubService.CreateIssueAsync(owner, repo, request.Title, request.Body);
            return Ok(new
            {
                issue.Number,
                issue.Title,
                issue.State,
                issue.HtmlUrl
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating issue in {Owner}/{Repo}", owner, repo);
            return StatusCode(500, new { error = ex.Message });
        }
    }

    [HttpPost("pullrequests/{owner}/{repo}")]
    public async Task<IActionResult> CreatePullRequest(string owner, string repo, [FromBody] CreatePullRequestRequest request)
    {
        try
        {
            var pr = await _gitHubService.CreatePullRequestAsync(
                owner, 
                repo, 
                request.Title, 
                request.Head, 
                request.Base, 
                request.Body);
            
            return Ok(new
            {
                pr.Number,
                pr.Title,
                pr.State,
                pr.HtmlUrl
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating pull request in {Owner}/{Repo}", owner, repo);
            return StatusCode(500, new { error = ex.Message });
        }
    }

    [HttpGet("issues/{owner}/{repo}")]
    public async Task<IActionResult> GetIssues(string owner, string repo)
    {
        try
        {
            var issues = await _gitHubService.GetIssuesAsync(owner, repo);
            return Ok(issues.Select(i => new
            {
                i.Number,
                i.Title,
                i.State,
                i.User.Login,
                i.CreatedAt,
                i.HtmlUrl
            }));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching issues for {Owner}/{Repo}", owner, repo);
            return StatusCode(500, new { error = ex.Message });
        }
    }
}
