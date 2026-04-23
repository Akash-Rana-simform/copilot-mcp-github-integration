# GitHub MCP Server + .NET Demo

A complete demonstration of integrating the **GitHub MCP (Model Context Protocol) Server** with **VS Code Copilot** and a **.NET 8 Web API**.

## 🎯 What This Demo Shows

1. **Configure GitHub MCP Server** in VS Code
2. **Use Copilot in Agent Mode** to interact with GitHub via natural language
3. **Compare MCP vs traditional API** with a .NET example
4. **Verify MCP tools** are actually being used

## 🚀 Quick Start

### Prerequisites

- ✅ **VS Code** with GitHub Copilot extension
- ✅ **Node.js** v18+ ([Download](https://nodejs.org/))
- ✅ **.NET 8 SDK** ([Download](https://dotnet.microsoft.com/download))
- ✅ **GitHub Personal Access Token** ([Create one](https://github.com/settings/tokens/new))

### Setup (5 minutes)

1. **Open this workspace in VS Code**
   ```powershell
   cd copilot-mcp-github-integration
   code .
   ```

2. **Run setup script**
   ```powershell
   .\setup.ps1
   ```
   
   This will:
   - Check prerequisites
   - Prompt for your GitHub token
   - Restore .NET dependencies
   - Configure everything

3. **Restart VS Code** (important!)
   - Close ALL VS Code windows
   - Reopen the workspace

4. **Test the integration**
   - Open Copilot Chat: `Ctrl+Alt+I` (Windows) or `Cmd+Alt+I` (Mac)
   - Switch to **Agent** mode
   - Ask: `"List my open pull requests"`

✅ **Success!** If Copilot lists your actual PRs, the MCP server is working!

## 📋 What's Included

### GitHub MCP Server Configuration
- [.vscode/settings.json](.vscode/settings.json) - MCP server configuration
- [setup.ps1](setup.ps1) - Automated setup script

### .NET 8 Demo API
- [src/GitHubDemo.Api/](src/GitHubDemo.Api/) - Complete Web API project
  - **Controllers**: GitHub API endpoints
  - **Services**: GitHub operations using Octokit
  - **Models**: Request/response DTOs

### Demo Scenarios & Testing
- [examples/demo-scenarios.md](examples/demo-scenarios.md) - 10 commands to try
- [examples/testing-guide.md](examples/testing-guide.md) - Verification guide

## 🎮 Try These Commands

Open Copilot Chat in **Agent Mode** and try:

### 1️⃣ List Pull Requests
```
List my open pull requests
```
**MCP Tool Used:** `mcp_github_list_pull_requests`

### 2️⃣ Create an Issue
```
Create an issue in copilot-mcp-github-integration titled "Test Issue" 
with description "Testing MCP integration"
```
**MCP Tool Used:** `mcp_github_create_issue`

### 3️⃣ Search Repositories
```
Show me all my .NET repositories
```
**MCP Tool Used:** `mcp_github_search_repositories`

[See all 10 demo scenarios →](examples/demo-scenarios.md)

## 🔍 Verify It's Working

### Method 1: Check Developer Console
1. Open Developer Tools: `Help → Toggle Developer Tools`
2. Go to **Console** tab
3. Run a command in Copilot
4. Look for:
   ```
   [MCP] Invoking tool: mcp_github_list_pull_requests
   [MCP] Tool result: {...}
   ```

### Method 2: Check Response
- ✅ **Working**: Real data from your GitHub account
- ❌ **Not Working**: "I don't have access to GitHub"

[Complete testing guide →](examples/testing-guide.md)

## 🏗️ .NET API Demo

The included .NET API shows traditional GitHub integration for comparison:

### Run the API
```powershell
dotnet run --project src\GitHubDemo.Api
```

### Try the Endpoints
Visit: http://localhost:5000/swagger

Endpoints:
- `GET /api/github/repositories` - List your repos
- `GET /api/github/pullrequests/{owner}/{repo}` - Get PRs
- `POST /api/github/issues/{owner}/{repo}` - Create issue
- `GET /api/github/issues/{owner}/{repo}` - List issues

### Compare: MCP vs API

| Feature | MCP (Copilot) | Traditional API |
|---------|---------------|-----------------|
| **Interface** | Natural language | REST endpoints |
| **Auth** | Token in env | Token in code |
| **Code Required** | None | Controllers + Services |
| **Learning Curve** | Minimal | Medium |
| **Use Case** | Ad-hoc tasks | Production apps |

## 📂 Project Structure

```
copilot-mcp-github-integration/
├── .vscode/
│   └── settings.json              # MCP server config
├── .github/
│   ├── hooks/
│   │   ├── security.json         # Security & monitoring hooks
│   │   └── README.md             # Hooks documentation
│   └── logs/                      # Agent activity logs (auto-created)
├── src/
│   └── GitHubDemo.Api/
│       ├── Controllers/
│       │   └── GitHubController.cs
│       ├── Services/
│       │   ├── IGitHubService.cs
│       │   └── GitHubService.cs
│       ├── Models/
│       │   ├── CreateIssueRequest.cs
│       │   └── CreatePullRequestRequest.cs
│       └── Program.cs
├── examples/
│   ├── demo-scenarios.md         # Commands to try
│   └── testing-guide.md          # Verification guide
├── setup.ps1                     # Automated setup
├── GitHubDemo.sln               # .NET solution
└── README.md
```

## 🔧 Manual Configuration

If you prefer manual setup:

### 1. Create GitHub Token
1. Go to https://github.com/settings/tokens/new
2. Name: "MCP Server Demo"
3. Scopes: `repo`, `read:org`, `read:user`
4. Generate and copy token

### 2. Set Environment Variable
**PowerShell:**
```powershell
# Replace ghp_xxxxxxxxxxxx with your actual token
[System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'ghp_xxxxxxxxxxxx', 'User')
```

**Command Prompt:**
```cmd
:: Replace ghp_xxxxxxxxxxxx with your actual token
setx GITHUB_TOKEN "ghp_xxxxxxxxxxxx"
```

### 3. Verify Configuration
The [.vscode/settings.json](.vscode/settings.json) should contain:
```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    }
  }
}
```

### 4. Restart VS Code
Close all windows and reopen.

## 🐛 Troubleshooting

### "I don't have access to GitHub"
- ✅ Check `GITHUB_TOKEN` is set: `$env:GITHUB_TOKEN` (PowerShell)
- ✅ Restart VS Code completely
- ✅ Verify [.vscode/settings.json](.vscode/settings.json)

### "mcp_github_* tools not found"
- ✅ Ensure MCP is enabled in settings
- ✅ Check Developer Console for errors
- ✅ Verify Node.js is installed: `node --version`

### "Permission denied"
- ✅ Token needs `repo`, `read:org`, `read:user` scopes
- ✅ Check token at https://github.com/settings/tokens

### MCP Server won't start
- ✅ Test manually: `npx -y @modelcontextprotocol/server-github`
- ✅ Check npm/npx is working
- ✅ Look for errors in Output panel (View → Output → GitHub Copilot)

[Complete troubleshooting guide →](examples/testing-guide.md)

## � Security & Monitoring Hooks

This project includes a **security hooks system** that logs Copilot agent activity for audit and monitoring purposes.

### Features
- 📝 **Session Tracking** - Log when agent sessions start/end
- 🛠️ **Tool Execution Logs** - Track all tools used by the agent
- 📁 **File Edit Audit** - Monitor file modifications
- 🔍 **Security Audit Trail** - Complete activity history

### Quick Start
```powershell
# View hooks configuration
Get-Content .github\hooks\security.json

# View activity logs
Get-Content .github\logs\agent-sessions.log
Get-Content .github\logs\tool-executions.log

# Monitor in real-time
Get-Content .github\logs\tool-executions.log -Wait
```

### Documentation
- **Configuration**: [.github/hooks/security.json](.github/hooks/security.json)
- **Full Documentation**: [.github/hooks/README.md](.github/hooks/README.md)
- **Verification Guide**: [.github/VERIFICATION.md](.github/VERIFICATION.md)

**Note**: Hooks are pre-configured and ready to use. Log files are auto-created when Copilot agent executes actions.

## �📚 Available MCP Tools

The GitHub MCP Server provides these tools (automatically used by Copilot):

| Tool | Description |
|------|-------------|
| `create_or_update_file` | Create or update repository files |
| `search_repositories` | Search for repositories |
| `create_repository` | Create new repositories |
| `get_file_contents` | Read file contents |
| `push_files` | Push multiple files |
| `create_issue` | Create issues |
| `create_pull_request` | Create pull requests |
| `fork_repository` | Fork repositories |
| `create_branch` | Create branches |
| `list_commits` | List commits |
| `list_issues` | List issues |
| `update_issue` | Update issues |
| `add_issue_comment` | Comment on issues |
| `search_code` | Search code |
| `search_issues` | Search issues/PRs |
| `list_pull_requests` | List pull requests |
| `get_pull_request` | Get PR details |

## 🎓 Learning Paths

### Path 1: MCP Integration (This Demo)
1. Configure MCP server
2. Use Copilot with natural language
3. Verify tools are being used
4. Understand the MCP protocol

### Path 2: Traditional .NET API
1. Create GitHub token
2. Use Octokit library
3. Build REST API
4. Handle auth and errors

### Path 3: Combined Approach
- Use MCP for **ad-hoc tasks** and exploration
- Use API for **production workflows** and automation

## 🔗 Resources

- [Model Context Protocol](https://modelcontextprotocol.io) - MCP documentation
- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/github) - Source code
- [Octokit.NET](https://github.com/octokit/octokit.net) - GitHub API library
- [VS Code Copilot](https://code.visualstudio.com/docs/copilot/overview) - Copilot docs

## 📝 License

MIT License - Feel free to use this demo for learning and demonstration purposes.

## 🤝 Contributing

Found an issue or have suggestions? Feel free to open an issue or PR!

---

**Ready to get started?** Run `.\setup.ps1` and try your first command!