# Video Demo Script

Use this script to record a demonstration of the GitHub MCP Server integration.

## 🎬 Introduction (30 seconds)

**[Screen: VS Code with README open]**

> "Hi! Today I'm going to show you how to integrate the GitHub MCP Server with VS Code Copilot. This lets you interact with GitHub using natural language instead of writing code."

**[Highlight key points on screen]**

> "By the end of this demo, you'll see Copilot listing your pull requests, creating issues, and performing other GitHub operations—all through simple conversation."

## 🛠️ Setup Overview (1 minute)

**[Screen: Terminal with setup.ps1]**

> "First, let's run the setup script. I've already created a GitHub Personal Access Token with the right permissions."

```powershell
.\setup.ps1
```

**[Enter token when prompted]**

> "The script validates prerequisites, sets up the environment variable, and restores dependencies."

**[Show success message]**

> "Now I need to restart VS Code for the changes to take effect."

**[Close and reopen VS Code]**

## 📁 Project Tour (1 minute)

**[Screen: Explorer view of project]**

> "Here's what we have:
> - The .vscode folder contains our MCP server configuration
> - The src folder has a complete .NET 8 Web API for comparison
> - And the examples folder has demo scenarios we can try"

**[Open .vscode/settings.json]**

> "The MCP configuration is simple: we enable MCP, specify the GitHub server via npx, and pass our token from the environment variable."

## 🎮 Demo 1: List Pull Requests (1 minute)

**[Screen: Open Copilot Chat - Ctrl+Alt+I]**

> "Let's open Copilot Chat and switch to Agent mode."

**[Click mode selector, choose Agent]**

> "Now I'll ask a simple question:"

**[Type:]**
```
List my open pull requests
```

**[Show Developer Tools - Help → Toggle Developer Tools]**

> "Watch the Console here—you'll see the MCP tool being invoked."

**[Point to mcp_github_list_pull_requests in console]**

> "There it is! The mcp_github_list_pull_requests tool. And here's the response with my actual PRs."

## 🎮 Demo 2: Create an Issue (1.5 minutes)

**[Screen: Still in Copilot Chat]**

> "Let's try something more interesting—creating a GitHub issue:"

**[Type:]**
```
Create an issue in copilot-mcp-github-integration titled "Demo Issue from MCP" 
with description "This issue was created using Copilot and the GitHub MCP Server"
```

**[Wait for response]**

> "Copilot is using the create_issue tool... and done! Here's the issue number and URL."

**[Open the GitHub URL in browser]**

> "And here it is on GitHub—a real issue created through natural language!"

## 🎮 Demo 3: Search Repositories (45 seconds)

**[Screen: Back to Copilot Chat]**

> "One more quick example:"

**[Type:]**
```
Show me all my C# and .NET repositories
```

**[Show response]**

> "Copilot searched my repositories and filtered them by language. No code required!"

## 🔍 Verification (1 minute)

**[Screen: Developer Console still open]**

> "Let's verify the MCP tools are actually being used. In the console, we can see:
> - Tool invocations with mcp_github prefix
> - The parameters being passed
> - And the responses from GitHub's API"

**[Scroll through console output]**

> "This proves we're using the MCP protocol, not just making regular API calls."

## 🏗️ Compare with Traditional API (1.5 minutes)

**[Screen: Terminal]**

> "Now let's compare this with the traditional approach. I'll run the .NET API:"

```powershell
dotnet run --project src\GitHubDemo.Api
```

**[Open browser to localhost:5000/swagger]**

> "Here's a traditional REST API with Swagger documentation. To list pull requests, I need to:
> 1. Know the exact endpoint
> 2. Provide owner and repository
> 3. Make a GET request
> 4. Parse the JSON response"

**[Try the GET /api/github/repositories endpoint]**

> "It works, but requires more setup and knowledge of the API structure."

**[Switch back to Copilot]**

> "With MCP and Copilot, I just ask in natural language. Much simpler for ad-hoc tasks!"

## 💡 Key Takeaways (1 minute)

**[Screen: Show README or summary slide]**

> "So what did we learn?
> 
> 1. **MCP enables natural language integration** - No coding required
> 2. **Copilot becomes your GitHub assistant** - List PRs, create issues, search repos
> 3. **Developer Console shows the tools** - Full transparency
> 4. **Complements, doesn't replace APIs** - Use both for different purposes
>
> The MCP approach is perfect for:
> - ✅ Exploration and discovery
> - ✅ One-off tasks
> - ✅ Quick queries
>
> Traditional APIs are better for:
> - ✅ Production applications
> - ✅ Automated workflows
> - ✅ Complex business logic"

## 🎁 Bonus: Advanced Commands (Optional - 2 minutes)

**[Screen: Copilot Chat]**

> "If we have time, here are some advanced things you can try:"

### Search Code
```
Search for "GitHubService" in my repositories
```

### Update Issue
```
Update issue #1 in copilot-mcp-github-integration and add the label "enhancement"
```

### List Commits
```
Show me the last 10 commits in copilot-mcp-github-integration
```

### Create Pull Request
```
Create a pull request in copilot-mcp-github-integration from feature-docs to main 
with title "Update documentation"
```

## 🎬 Closing (30 seconds)

**[Screen: README or project overview]**

> "That's it! You now know how to:
> - Configure the GitHub MCP Server
> - Use Copilot in Agent Mode
> - Perform GitHub operations with natural language
> - Verify MCP tools are being used
>
> All the code and setup scripts are available in this repository. The README has complete instructions, troubleshooting tips, and more examples to try.
>
> Thanks for watching!"

---

## 📋 Pre-Recording Checklist

Before recording, make sure:

- [ ] GitHub token is set and valid
- [ ] VS Code is restarted
- [ ] Demo repository exists and has some issues/PRs
- [ ] Developer Tools are ready to open (F12)
- [ ] .NET API builds successfully
- [ ] Terminal is in the right directory
- [ ] Browser has no sensitive tabs open
- [ ] Screen resolution is good for recording
- [ ] Audio is working
- [ ] You're in Agent Mode (not Chat Mode)

## 🎨 Recording Tips

1. **Pace yourself** - Speak slowly and clearly
2. **Show, don't just tell** - Highlight things on screen
3. **Zoom in** on important details (console, responses)
4. **Pause** after commands to let viewers see the response
5. **Use annotations** if your recording tool supports them
6. **Have a backup plan** if GitHub API is slow
7. **Keep it short** - 10 minutes max for full demo, 5 min for quick version

## ⚡ Quick 3-Minute Version

If you need a shorter demo:

1. **Intro** (20 sec) - What we're showing
2. **Setup mention** (20 sec) - "Already configured with setup.ps1"
3. **List PRs** (60 sec) - Show MCP tool in console
4. **Create issue** (60 sec) - Show on GitHub
5. **Wrap up** (40 sec) - Key benefits

---

**Ready to record? Good luck! 🎥**
