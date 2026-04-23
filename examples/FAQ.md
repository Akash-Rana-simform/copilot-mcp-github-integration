# Frequently Asked Questions

## General Questions

### Q: What is MCP?
**A:** MCP (Model Context Protocol) is a protocol that allows AI assistants like Copilot to interact with external tools and services. In this case, it enables Copilot to perform GitHub operations through natural language.

### Q: Why use MCP instead of the GitHub API directly?
**A:** 
- **Natural Language**: Ask questions in plain English instead of writing code
- **No Coding Required**: Copilot handles the API calls for you
- **Exploratory Work**: Great for quick tasks and exploration
- **Learning**: Understand GitHub operations without reading API docs

For production applications, you'd still use the API directly (like the .NET demo shows).

### Q: Does this replace the GitHub API?
**A:** No! MCP is complementary:
- Use **MCP** for: Ad-hoc tasks, exploration, quick queries
- Use **API** for: Production code, automation, complex workflows

## Setup Questions

### Q: Do I need a GitHub account?
**A:** Yes, you need a GitHub account and a Personal Access Token.

### Q: What permissions does my token need?
**A:** Your token needs these scopes:
- `repo` - Full control of repositories
- `read:org` - Read organization data
- `read:user` - Read user profile data

### Q: Can I use this with GitHub Enterprise?
**A:** The GitHub MCP server is designed for github.com. For GitHub Enterprise, you may need to configure a custom MCP server.

### Q: Do I need to install anything globally?
**A:** No! The MCP server uses `npx` which downloads and runs the server on-demand. You just need Node.js installed.

## Usage Questions

### Q: How do I know if MCP is working?
**A:** Check these indicators:
1. Copilot returns real data from your GitHub account
2. Developer Console shows `mcp_github_*` tool invocations
3. No "I don't have access" errors

### Q: What's the difference between Chat and Agent mode?
**A:** 
- **Chat Mode**: General coding assistant, limited tool access
- **Agent Mode**: Can use MCP tools, external services, more autonomous

Always use **Agent Mode** to access MCP tools.

### Q: Can I use MCP with other services?
**A:** Yes! MCP is extensible. You can configure multiple MCP servers:
- GitHub (this demo)
- File system operations
- Database queries
- Custom tools you build

### Q: Will this work in VS Code Web / github.dev?
**A:** MCP servers require local execution, so they work in VS Code Desktop. Support for web versions may vary.

## Technical Questions

### Q: Where is my GitHub token stored?
**A:** In a Windows environment variable (`GITHUB_TOKEN`), stored at the user level. It's not in any file or repository.

### Q: Is my token secure?
**A:** 
- ✅ Stored in environment variables (not in code)
- ✅ Not committed to Git
- ✅ Only accessible to your user account
- ⚠️ Visible in VS Code's running process
- ⚠️ Anyone with access to your machine can read it

Treat it like a password and never share it.

### Q: How does the MCP server connect?
**A:** When you start Copilot in Agent Mode:
1. VS Code reads `.vscode/settings.json`
2. Runs `npx @modelcontextprotocol/server-github`
3. Passes your `GITHUB_TOKEN` via environment
4. Server registers available tools with Copilot
5. Copilot can now invoke those tools

### Q: Does this make API calls on my behalf?
**A:** Yes! When Copilot invokes MCP tools, the GitHub MCP server makes authenticated API calls to GitHub using your token.

### Q: Will this count against my API rate limits?
**A:** Yes, each MCP tool invocation makes real GitHub API calls. Authenticated users get 5,000 requests per hour.

## Troubleshooting Questions

### Q: Why does Copilot say "I don't have access to GitHub"?
**A:** Common causes:
1. MCP not enabled in settings
2. `GITHUB_TOKEN` not set or incorrect
3. VS Code not restarted after setting token
4. Not in Agent Mode (using Chat Mode instead)

### Q: I set the token but it's still not working
**A:** Try:
1. Verify token in PowerShell: `$env:GITHUB_TOKEN`
2. **Close ALL VS Code windows** and reopen
3. Check token scopes at https://github.com/settings/tokens
4. Look for errors in Developer Console

### Q: The MCP server won't start
**A:** Check:
1. Node.js is installed: `node --version`
2. npx is working: `npx --version`
3. Manually test: `npx -y @modelcontextprotocol/server-github`
4. Check Output panel: View → Output → GitHub Copilot

### Q: Can I see the actual API calls being made?
**A:** Yes! Open Developer Tools (Help → Toggle Developer Tools) and watch the Console tab. You'll see MCP tool invocations and results.

## Demo Questions

### Q: Can I use this in production?
**A:** The demo is for learning purposes. For production:
- Use the .NET API approach (included in demo)
- Implement proper error handling
- Use secure token storage (Azure Key Vault, etc.)
- Add logging and monitoring

### Q: What does the .NET API do?
**A:** The .NET API demonstrates traditional GitHub integration:
- REST API with Swagger documentation
- Octokit library for GitHub operations
- Shows the "code-based" approach vs MCP's "natural language" approach

### Q: Can I extend this demo?
**A:** Absolutely! Try:
- Add more GitHub operations
- Create workflows combining multiple operations
- Build a UI that uses Copilot's MCP features
- Integrate other MCP servers (file system, databases, etc.)

### Q: Is this officially supported by GitHub/Microsoft?
**A:** This demo uses:
- Official MCP protocol (open standard)
- Official GitHub MCP server
- Official VS Code Copilot features

It's all supported technology, assembled for demonstration.

## Performance Questions

### Q: Is MCP slow?
**A:** MCP adds minimal overhead:
- Tool invocation: ~100-200ms
- GitHub API call: depends on operation (usually <1s)
- Total: Comparable to direct API calls

### Q: Can I use MCP for bulk operations?
**A:** MCP is best for:
- ✅ Single operations (create issue, list PRs)
- ✅ Exploratory queries
- ❌ Bulk operations (use API directly)
- ❌ High-frequency calls (use API directly)

## Integration Questions

### Q: Can I use this with GitHub Actions?
**A:** MCP is designed for interactive use. For automation:
- Use GitHub Actions' built-in GitHub integration
- Or use the .NET API approach from the demo

### Q: Can I combine MCP with my own code?
**A:** Yes! Use:
- MCP for: Quick queries, exploration, one-off tasks
- Your code for: Business logic, data processing, persistence

### Q: Does this work with private repositories?
**A:** Yes, if your token has `repo` scope (which includes private repositories).

## Cost Questions

### Q: Is this free?
**A:** 
- GitHub API: Free tier has 5,000 requests/hour
- GitHub Copilot: Requires paid subscription
- MCP Protocol: Free and open source
- This demo: Free

### Q: Will this use my Copilot quota?
**A:** Copilot interactions count against your usage, but there's typically no hard quota—just fair use policies.

---

**Still have questions?** 
- Check the [README](../README.md)
- Review the [Testing Guide](testing-guide.md)
- Try the [Demo Scenarios](demo-scenarios.md)
