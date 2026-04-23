# Copilot Agent Security Hooks

This directory contains security and monitoring hooks for GitHub Copilot Agent activity.

## Overview

The `security.json` file configures hooks that log various agent activities for security monitoring and audit purposes.

## Configured Hooks

### 1. **sessionStart**
- Logs when a Copilot agent session begins
- Records: timestamp, username, workspace path
- Log file: `.github/logs/agent-sessions.log`

### 2. **sessionEnd**
- Logs when a Copilot agent session ends
- Records: timestamp, session duration
- Log file: `.github/logs/agent-sessions.log`

### 3. **preToolUse**
- Logs before any tool is executed by the agent
- Records: timestamp, tool name, tool arguments
- Log file: `.github/logs/tool-executions.log`

### 4. **postToolUse**
- Logs after a tool completes execution
- Records: timestamp, tool name, execution status
- Log file: `.github/logs/tool-executions.log`

### 5. **preFileEdit**
- Logs before any file is modified by the agent
- Records: timestamp, file path, username
- Log file: `.github/logs/file-edits.log`

## Log Files

All logs are stored in `.github/logs/`:
- `agent-sessions.log` - Session start/end events
- `tool-executions.log` - Tool usage tracking
- `file-edits.log` - File modification audit trail

**Note:** Log files are automatically created when hooks execute.

## Testing the Hooks

### 1. Verify Hook Configuration
```powershell
# Check if hooks file exists
Test-Path .github/hooks/security.json

# View the configuration
Get-Content .github/hooks/security.json | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### 2. Test with Copilot Agent
Open Copilot Chat (`Ctrl+Alt+I`) and try these commands:

```
Read the README.md file
```

```
List all files in the src directory
```

```
Create a test file in examples/test-hook.md with some content
```

### 3. Review the Logs
```powershell
# View session logs
Get-Content .github/logs/agent-sessions.log

# View tool execution logs
Get-Content .github/logs/tool-executions.log

# View file edit logs
Get-Content .github/logs/file-edits.log

# Watch logs in real-time (in separate terminal)
Get-Content .github/logs/tool-executions.log -Wait
```

### 4. Analyze Logs
```powershell
# Count tool executions
(Get-Content .github/logs/tool-executions.log | Select-String "PRE_TOOL").Count

# Find specific tool usage
Get-Content .github/logs/tool-executions.log | Select-String "read_file"

# Get today's sessions
Get-Content .github/logs/agent-sessions.log | Select-String (Get-Date -Format "yyyy-MM-dd")
```

## Security Considerations

- **Log Retention:** Logs are retained for 30 days (configurable in `settings.logRetentionDays`)
- **Sensitive Data:** Tool arguments may contain sensitive information - restrict log file access
- **Performance:** Hooks run asynchronously with a 5-second timeout to avoid blocking agent operations
- **Access Control:** Ensure `.github/logs/` directory has appropriate permissions

## Customization

Edit `security.json` to:
- Enable/disable specific hooks (`"enabled": true/false`)
- Change log file paths
- Modify log format in PowerShell commands
- Add custom hooks for other events
- Adjust timeout values

## Available Hook Events

| Event | Triggered When |
|-------|---------------|
| `sessionStart` | Agent session begins |
| `sessionEnd` | Agent session ends |
| `preToolUse` | Before any tool executes |
| `postToolUse` | After tool completes |
| `preFileEdit` | Before file modification |
| `postFileEdit` | After file modification |
| `preTerminalCommand` | Before terminal command runs |
| `postTerminalCommand` | After terminal command completes |

## Troubleshooting

### Hooks Not Executing
1. Verify PowerShell is available: `Get-Command powershell`
2. Check hook syntax in `security.json`
3. Ensure VS Code has permission to execute hooks
4. Check VS Code Developer Console for errors: `Help → Toggle Developer Tools`

### Logs Not Created
1. Verify directory permissions
2. Check if PowerShell commands run manually:
   ```powershell
   $logFile = '.github/logs/test.log'
   New-Item -ItemType Directory -Force -Path (Split-Path $logFile) | Out-Null
   Add-Content -Path $logFile -Value "Test entry"
   ```

### Performance Issues
- Increase timeout values in `security.json`
- Reduce logging detail
- Disable non-critical hooks

## Compliance & Audit

These hooks help with:
- ✅ Security audit trails
- ✅ Activity monitoring
- ✅ Debugging agent behavior
- ✅ Compliance requirements
- ✅ Usage analytics

## Log Format Examples

**Session Start:**
```
[2026-04-23 14:30:15] SESSION_START - User: akash.r, Workspace: c:\copilot-mcp-github-integration
```

**Tool Execution:**
```
[2026-04-23 14:30:20] PRE_TOOL - Tool: read_file, Args: {"filePath":"README.md"}
[2026-04-23 14:30:21] POST_TOOL - Tool: read_file, Status: success
```

**File Edit:**
```
[2026-04-23 14:30:25] PRE_FILE_EDIT - File: examples/test.md, User: akash.r
```
