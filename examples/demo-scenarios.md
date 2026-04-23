# GitHub MCP Server Demo Scenarios

## Try these commands in Copilot Agent Mode:

### 1. List Open Pull Requests
```
List my open pull requests
```
**Expected MCP Tools Used:** `mcp_github_list_pull_requests`

### 2. Create an Issue
```
Create an issue in copilot-mcp-github-integration titled "Demo Issue" with description "Testing MCP integration with GitHub"
```
**Expected MCP Tools Used:** `mcp_github_create_issue`

### 3. Search Repositories
```
Show me all my repositories that use C# or .NET
```
**Expected MCP Tools Used:** `mcp_github_search_repositories`

### 4. Get Repository Details
```
Show me the details of the copilot-mcp-github-integration repository
```
**Expected MCP Tools Used:** `mcp_github_get_file_contents`, `mcp_github_search_repositories`

### 5. Create a Pull Request
```
Create a pull request in copilot-mcp-github-integration from feature-branch to main with title "Add new feature"
```
**Expected MCP Tools Used:** `mcp_github_create_pull_request`

### 6. List Issues
```
Show me all open issues in copilot-mcp-github-integration
```
**Expected MCP Tools Used:** `mcp_github_list_issues`

### 7. Search Code
```
Search for "GitHubService" in my repositories
```
**Expected MCP Tools Used:** `mcp_github_search_code`

### 8. Update an Issue
```
Update issue #1 in copilot-mcp-github-integration to add the label "bug"
```
**Expected MCP Tools Used:** `mcp_github_update_issue`

### 9. Fork Repository
```
Fork the repository microsoft/vscode
```
**Expected MCP Tools Used:** `mcp_github_fork_repository`

### 10. List Commits
```
Show me the recent commits in copilot-mcp-github-integration
```
**Expected MCP Tools Used:** `mcp_github_list_commits`

## Verification

To verify MCP tools are being used:

1. Open VS Code Developer Tools (Help → Toggle Developer Tools)
2. Go to Console tab
3. Watch for MCP tool invocations like:
   - `Invoking MCP tool: mcp_github_list_pull_requests`
   - `MCP tool result: ...`

You should see the actual GitHub MCP server tools being called instead of generic API calls.
