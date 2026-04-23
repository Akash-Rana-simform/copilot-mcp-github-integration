namespace GitHubDemo.Api.Models;

public class CreatePullRequestRequest
{
    public string Title { get; set; } = string.Empty;
    public string Head { get; set; } = string.Empty;
    public string Base { get; set; } = string.Empty;
    public string Body { get; set; } = string.Empty;
}
