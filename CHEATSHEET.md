# GitHub MCP Server Cheat Sheet

Quick reference for using the GitHub MCP Server with VS Code Copilot.

## 🚀 Setup Commands

```powershell
# Quick setup
.\setup.ps1

# Set token manually
[System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'your_token', 'User')

# Verify token
$env:GITHUB_TOKEN

# Run .NET API
dotnet run --project src\GitHubDemo.Api
```

## 🎮 Common Copilot Commands

### Repository Operations
```
Show me my repositories
Show me all my C# repositories
Show details of owner/repo
Search my repositories for "keyword"
```

### Pull Requests
```
List my open pull requests
Show PRs in owner/repo
Show details of PR #123 in owner/repo
Create a pull request in owner/repo from branch-a to branch-b
```

### Issues
```
List issues in owner/repo
Show open issues in owner/repo
Create an issue in owner/repo titled "Title" with description "Description"
Update issue #123 in owner/repo
Close issue #123 in owner/repo
Add comment "text" to issue #123 in owner/repo
```

### Code & Commits
```
Show recent commits in owner/repo
Search for "keyword" in my code
Show file contents of path/to/file in owner/repo
List branches in owner/repo
```

### Advanced
```
Fork repository owner/repo
Create branch "branch-name" in owner/repo
Create repository "new-repo" with description "Description"
```

## 🔧 VS Code Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Open Copilot Chat | `Ctrl+Alt+I` | `Cmd+Alt+I` |
| Open Developer Tools | `F12` | `Cmd+Option+I` |
| Open Command Palette | `Ctrl+Shift+P` | `Cmd+Shift+P` |
| Reload Window | `Ctrl+R` | `Cmd+R` |

## 🔍 Verification

### Check MCP is Working
1. Open Developer Tools: `Help → Toggle Developer Tools`
2. Go to `Console` tab
3. Look for: `[MCP] Invoking tool: mcp_github_*`

### Check Token
```powershell
# PowerShell
$env:GITHUB_TOKEN

# Command Prompt
echo %GITHUB_TOKEN%
```

### Check MCP Settings
File: `.vscode/settings.json`
```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "github": { ... }
  }
}
```

## ⚙️ Configuration Files

| File | Purpose |
|------|---------|
| `.vscode/settings.json` | MCP server config |
| `.vscode/tasks.json` | Build and run tasks |
| `.vscode/launch.json` | Debug configuration |
| `GitHubDemo.sln` | .NET solution file |
| `setup.ps1` | Automated setup script |

## 🌐 API Endpoints (when running .NET API)

Base URL: `http://localhost:5000`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/github/repositories` | GET | List repositories |
| `/api/github/pullrequests/{owner}/{repo}` | GET | List PRs |
| `/api/github/issues/{owner}/{repo}` | GET | List issues |
| `/api/github/issues/{owner}/{repo}` | POST | Create issue |
| `/api/github/pullrequests/{owner}/{repo}` | POST | Create PR |

Swagger UI: `http://localhost:5000/swagger`

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "I don't have access to GitHub" | Set `GITHUB_TOKEN` and restart VS Code |
| MCP tools not found | Check `.vscode/settings.json` and enable MCP |
| Token not working | Verify scopes: `repo`, `read:org`, `read:user` |
| Node.js errors | Install Node.js v18+ from nodejs.org |
| .NET build errors | Run `dotnet restore GitHubDemo.sln` |
| Wrong mode | Switch from "Chat" to "Agent" mode |

## 📊 MCP Tools Available

| Tool | Description |
|------|-------------|
| `list_pull_requests` | List PRs in a repository |
| `get_pull_request` | Get PR details |
| `create_pull_request` | Create new PR |
| `list_issues` | List issues |
| `create_issue` | Create new issue |
| `update_issue` | Update existing issue |
| `add_issue_comment` | Comment on issue |
| `search_repositories` | Search repos |
| `search_code` | Search code |
| `search_issues` | Search issues/PRs |
| `get_file_contents` | Read file |
| `create_or_update_file` | Write file |
| `push_files` | Push multiple files |
| `create_repository` | Create new repo |
| `fork_repository` | Fork a repo |
| `create_branch` | Create branch |
| `list_commits` | List commits |

## 🎯 Best Practices

### Do's ✅
- Use Agent mode (not Chat mode)
- Be specific with owner/repo names
- Verify token scopes before use
- Watch Developer Console for debugging
- Use natural language
- Restart VS Code after setting env vars

### Don'ts ❌
- Don't commit tokens to Git
- Don't use for bulk operations
- Don't expect instant responses
- Don't forget to specify repo when needed
- Don't use Chat mode for MCP commands

## 📚 Quick Links

- **Create Token**: https://github.com/settings/tokens/new
- **Check Tokens**: https://github.com/settings/tokens
- **Node.js**: https://nodejs.org/
- **.NET SDK**: https://dotnet.microsoft.com/download
- **MCP Docs**: https://modelcontextprotocol.io
- **Octokit**: https://github.com/octokit/octokit.net

## 💡 Example Workflow

```
1. Ask: "Show me my repositories"
2. Ask: "Show open issues in owner/repo"
3. Ask: "Create an issue titled 'Bug: XYZ' in owner/repo"
4. Ask: "Show me PR #123 in owner/repo"
5. Ask: "Search my code for 'GitHubService'"
```

## 🎓 Learning Path

1. **Start**: Run `.\setup.ps1`
2. **Test**: `List my open pull requests`
3. **Create**: `Create an issue in my-repo`
4. **Search**: `Show my .NET repositories`
5. **Advanced**: Create PRs, update issues, search code
6. **Compare**: Run .NET API and try same operations

---

**Print this out and keep it handy! 📄**
