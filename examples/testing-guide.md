# Testing the GitHub MCP Integration

This guide shows you how to verify the GitHub MCP Server is working correctly with VS Code Copilot.

## Quick Test Commands

### Test 1: List Pull Requests
In Copilot Chat (Agent Mode), ask:
```
List my open pull requests
```

**What to look for:**
- Copilot should use the `mcp_github_list_pull_requests` tool
- You should see a list of your actual GitHub PRs
- Check Developer Console for MCP tool invocations

### Test 2: Search Repositories
```
Show me all my GitHub repositories
```

**What to look for:**
- Copilot should use `mcp_github_search_repositories`
- You should see your repositories listed

### Test 3: Create an Issue (Non-destructive)
First, create a test repository or use an existing one:
```
Create an issue in [your-username]/[test-repo] titled "MCP Test" with description "Testing the MCP integration"
```

**What to look for:**
- Copilot should use `mcp_github_create_issue`
- Issue should be created in your repository
- You'll get a link to the newly created issue

## Verification Checklist

### ✅ Pre-flight Checks
- [ ] `GITHUB_TOKEN` environment variable is set
- [ ] VS Code has been restarted after setting the token
- [ ] `.vscode/settings.json` contains MCP configuration
- [ ] Node.js is installed (`node --version`)

### ✅ During Test
- [ ] Copilot is in "Agent" mode (not "Chat" mode)
- [ ] Commands are natural language (not API calls)
- [ ] Response comes from Copilot, not an error

### ✅ MCP Tool Usage
Open Developer Tools (Help → Toggle Developer Tools):

1. Go to **Console** tab
2. Run a test command in Copilot
3. Look for these messages:
   ```
   [MCP] Invoking tool: mcp_github_list_pull_requests
   [MCP] Tool result: {...}
   ```

### ✅ Expected Behavior

**SUCCESS:**
- Copilot mentions using GitHub tools/API
- Real data from your GitHub account is returned
- MCP tool names appear in Developer Console

**FAILURE (MCP not working):**
- Copilot says "I cannot access GitHub"
- No MCP tool invocations in console
- Generic/placeholder responses

## Troubleshooting

### Issue: "I don't have access to GitHub"

**Solution:**
1. Check `GITHUB_TOKEN` is set:
   ```powershell
   $env:GITHUB_TOKEN
   ```
2. Restart VS Code completely
3. Verify `.vscode/settings.json` has MCP config

### Issue: "mcp_github_* tools not found"

**Solution:**
1. Check MCP is enabled in settings:
   ```json
   "github.copilot.chat.mcp.enabled": true
   ```
2. Verify GitHub MCP server in settings.json
3. Check Developer Console for MCP initialization errors

### Issue: "Permission denied"

**Solution:**
1. Verify GitHub token has correct scopes:
   - `repo`
   - `read:org`
   - `read:user`
2. Go to https://github.com/settings/tokens to check

### Issue: Node.js errors

**Solution:**
1. Ensure Node.js v18+ is installed
2. Try manually running:
   ```bash
   npx -y @modelcontextprotocol/server-github
   ```
3. Check for npm/npx errors

## Advanced Testing

### Test the .NET API
Run the demo API to see programmatic GitHub integration:

```powershell
dotnet run --project src\GitHubDemo.Api
```

Then visit: http://localhost:5000/swagger

Try these endpoints:
- `GET /api/github/repositories` - List your repos
- `GET /api/github/pullrequests/{owner}/{repo}` - Get PRs
- `POST /api/github/issues/{owner}/{repo}` - Create an issue

### Compare MCP vs Direct API

1. **With MCP (Copilot Agent):**
   - Natural language commands
   - Copilot interprets and calls tools
   - No code required

2. **Without MCP (.NET API):**
   - REST API calls
   - Code required
   - Manual authentication

The MCP approach shows how Copilot can interact with GitHub on your behalf using natural language.

## Success Criteria

You've successfully configured the GitHub MCP Server when:

✅ Copilot can list your pull requests  
✅ Copilot can create issues in your repositories  
✅ Developer Console shows `mcp_github_*` tool invocations  
✅ Real data from your GitHub account is returned  
✅ No authentication or permission errors  

## Demo Recording Tips

When demonstrating this to others:

1. **Open Developer Tools first** to show MCP tools being called
2. **Use a clean test repository** to avoid exposing sensitive data
3. **Show the before/after** in GitHub UI (e.g., issue created)
4. **Compare with manual GitHub UI** to show the automation
5. **Highlight natural language** vs coding API calls
