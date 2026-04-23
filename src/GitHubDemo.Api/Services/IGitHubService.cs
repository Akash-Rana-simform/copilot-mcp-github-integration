using Octokit;

namespace GitHubDemo.Api.Services;

public interface IGitHubService
{
    Task<IReadOnlyList<Repository>> GetUserRepositoriesAsync();
    Task<IReadOnlyList<PullRequest>> GetPullRequestsAsync(string owner, string repo);
    Task<Issue> CreateIssueAsync(string owner, string repo, string title, string body);
    Task<PullRequest> CreatePullRequestAsync(string owner, string repo, string title, string head, string baseRef, string body);
    Task<IReadOnlyList<Issue>> GetIssuesAsync(string owner, string repo);
}
