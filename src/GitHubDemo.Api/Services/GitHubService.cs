using Octokit;

namespace GitHubDemo.Api.Services;

public class GitHubService : IGitHubService
{
    private readonly GitHubClient _client;

    public GitHubService(string token)
    {
        _client = new GitHubClient(new ProductHeaderValue("GitHubMCPDemo"))
        {
            Credentials = new Credentials(token)
        };
    }

    public async Task<IReadOnlyList<Repository>> GetUserRepositoriesAsync()
    {
        return await _client.Repository.GetAllForCurrent();
    }

    public async Task<IReadOnlyList<PullRequest>> GetPullRequestsAsync(string owner, string repo)
    {
        return await _client.PullRequest.GetAllForRepository(owner, repo);
    }

    public async Task<Issue> CreateIssueAsync(string owner, string repo, string title, string body)
    {
        var newIssue = new NewIssue(title)
        {
            Body = body
        };
        return await _client.Issue.Create(owner, repo, newIssue);
    }

    public async Task<PullRequest> CreatePullRequestAsync(string owner, string repo, string title, string head, string baseRef, string body)
    {
        var newPullRequest = new NewPullRequest(title, head, baseRef)
        {
            Body = body
        };
        return await _client.PullRequest.Create(owner, repo, newPullRequest);
    }

    public async Task<IReadOnlyList<Issue>> GetIssuesAsync(string owner, string repo)
    {
        return await _client.Issue.GetAllForRepository(owner, repo);
    }
}
