# Quick Start Guide

Get up and running with the GitHub MCP Server demo in 5 minutes!

## Step 1: Prerequisites (2 min)

Check you have everything installed:

```powershell
# Check Node.js
node --version  # Should be v18 or higher

# Check .NET SDK
dotnet --version  # Should be 8.0 or higher

# Check Git
git --version
```

❌ **Missing something?**
- Node.js: https://nodejs.org/
- .NET SDK: https://dotnet.microsoft.com/download
- Git: https://git-scm.com/

## Step 2: Create GitHub Token (1 min)

1. Go to: https://github.com/settings/tokens/new
2. **Note**: "MCP Server Demo"
3. **Scopes**: Check these boxes:
   - ✅ `repo` (all)
   - ✅ `read:org`
   - ✅ `read:user`
4. Click **Generate token**
5. **Copy the token** (you won't see it again!)

## Step 3: Run Setup (1 min)

```powershell
# Run the setup script
.\setup.ps1
```

When prompted, paste your GitHub token from Step 2.

The script will:
- ✅ Validate prerequisites
- ✅ Set environment variable
- ✅ Restore .NET packages
- ✅ Show next steps

## Step 4: Restart VS Code (30 sec)

**Important:** Close ALL VS Code windows and reopen the workspace.

This is necessary for the `GITHUB_TOKEN` environment variable to be loaded.

## Step 5: Test It! (30 sec)

1. **Open Copilot Chat**
   - Windows/Linux: `Ctrl+Alt+I`
   - Mac: `Cmd+Alt+I`

2. **Switch to Agent Mode**
   - Look for mode selector at top of chat
   - Click and select "Agent"

3. **Ask Copilot:**
   ```
   List my open pull requests
   ```

4. **See the magic! ✨**
   - Copilot should list your actual GitHub PRs
   - Check Developer Console (Help → Toggle Developer Tools)
   - You'll see `mcp_github_list_pull_requests` tool being called

## ✅ Success Criteria

You've successfully set up the GitHub MCP Server if:

- ✅ Copilot responds with real data from your GitHub account
- ✅ No "I don't have access to GitHub" errors
- ✅ Developer Console shows `mcp_github_*` tool invocations
- ✅ Commands complete in a few seconds

## 🎮 What to Try Next

### Easy Commands
```
Show me my repositories
```

```
What issues are open in copilot-mcp-github-integration?
```

### Intermediate Commands
```
Create an issue in copilot-mcp-github-integration titled "Test MCP" 
with description "Testing the integration"
```

```
Show me the recent commits in copilot-mcp-github-integration
```

### Advanced Commands
```
Search my repositories for the term "GitHubService"
```

```
Create a pull request in my test repository from feature-branch to main
```

[See all 10 demo scenarios →](examples/demo-scenarios.md)

## 🏃 Run the .NET API

Want to see the traditional approach?

```powershell
# Start the API
dotnet run --project src\GitHubDemo.Api

# Then visit:
# http://localhost:5000/swagger
```

Try the Swagger UI to make direct GitHub API calls.

## 🐛 Something Not Working?

### Issue: "GITHUB_TOKEN not set"
```powershell
# Check if set
$env:GITHUB_TOKEN

# If empty, run setup again
.\setup.ps1
```

### Issue: "I don't have access to GitHub"
1. Verify token: `$env:GITHUB_TOKEN`
2. Close ALL VS Code windows
3. Reopen and try again

### Issue: "mcp_github tools not found"
1. Check [.vscode/settings.json](.vscode/settings.json) exists
2. Verify `"github.copilot.chat.mcp.enabled": true`
3. Restart VS Code

### Issue: Node.js errors
```powershell
# Test MCP server manually
npx -y @modelcontextprotocol/server-github
```

[Complete troubleshooting guide →](examples/testing-guide.md#troubleshooting)

## 📚 Next Steps

- 📖 Read the [complete README](README.md)
- 🧪 Try all [demo scenarios](examples/demo-scenarios.md)
- ✅ Follow the [testing guide](examples/testing-guide.md)
- ❓ Check the [FAQ](examples/FAQ.md)

## 🎯 Pro Tips

1. **Always use Agent Mode** - Chat mode won't use MCP tools
2. **Watch the Developer Console** - See tools being called in real-time
3. **Be specific** - "List PRs in owner/repo" works better than "show PRs"
4. **Compare approaches** - Try same task with MCP vs the .NET API
5. **Experiment** - Natural language is forgiving, try different phrasings!

---

**Ready? Run `.\setup.ps1` and let's get started! 🚀**
