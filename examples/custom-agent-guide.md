# Custom Agent Guide: Using Documentation Writer

Learn how to create and use custom agents in VS Code for specialized tasks.

## What are Custom Agents?

Custom agents are specialized AI assistants with:
- **Specific roles** (e.g., documentation writer, code reviewer, tester)
- **Restricted tools** (only what they need for their job)
- **Custom instructions** (how they should behave)
- **Focused expertise** (deep knowledge in one area)

Think of them as **team members with specialized skills**.

---

## The Documentation Writer Agent

### Profile

**Name**: Documentation Writer  
**Location**: [.github/agents/docs-writer.md](.github/agents/docs-writer.md)  
**Tools**: `read`, `search`, `edit` (no terminal access for safety)  
**Expertise**: Technical writing, API documentation, README files, code comments

### When to Use

Invoke the Documentation Writer when you need:
- ✍️ Write or update documentation
- 📝 Create README files
- 📚 Document APIs with examples
- 💬 Add code comments
- 📖 Write user guides or tutorials
- 🔍 Improve existing documentation

---

## How to Use Custom Agents

### Method 1: Direct Invocation in Chat

Open Copilot Chat (`Ctrl+Alt+I`) and use the `@` mention:

```
@docs-writer Document the WebhookService class with XML comments and usage examples
```

```
@docs-writer Create a README for the examples folder explaining all the demo files
```

```
@docs-writer Write a quick start guide for new developers joining this project
```

### Method 2: From the Agent Picker

1. Open Copilot Chat
2. Click the agent selector (or press `Ctrl+/`)
3. Choose **"Documentation Writer"**
4. Type your request

### Method 3: Programmatic (from another agent)

Other agents can delegate to the Documentation Writer:

```markdown
I need comprehensive documentation for this API. Let me delegate this to the documentation specialist.

@docs-writer Please create complete API documentation for the WebhookService including:
- XML comments for all methods
- Usage guide with examples
- Troubleshooting section
```

---

## Example Workflow: From Issue to Completion

### 1. Create a Task

Create an issue or task file:

```markdown
# DOC-001: Document Webhook Service

Need documentation for the WebhookService class.

Requirements:
- API reference
- Usage guide
- Security best practices
- Code examples

@docs-writer Please complete this task.
```

### 2. Agent Processes Task

The Documentation Writer:
1. **Reads** relevant source files
2. **Understands** the implementation
3. **Creates** structured documentation
4. **Adds** code examples
5. **Updates** README if needed

### 3. Review Output

Check the created files:
- Documentation files in `examples/`
- Updated README
- Code comments in source files

### 4. Iterate if Needed

Request improvements:

```
@docs-writer Add troubleshooting section to the webhook guide covering common signature validation errors
```

---

## Real Example: DOC-001 Task

See the actual workflow in this repository:

1. **Task Created**: [.github/issues/DOC-001-webhook-documentation.md](../issues/DOC-001-webhook-documentation.md)
   - Clear requirements
   - List of files to document
   - Success criteria

2. **Documentation Created**: [examples/webhook-service-guide.md](../examples/webhook-service-guide.md)
   - 680 lines of comprehensive documentation
   - 15+ code examples
   - Security best practices
   - Troubleshooting guide

3. **README Updated**: [README.md](../README.md)
   - Added webhook feature section
   - Updated project structure
   - Linked to new documentation

4. **Completion Report**: [.github/issues/DOC-001-COMPLETED.md](../issues/DOC-001-COMPLETED.md)
   - Summary of work done
   - Quality metrics
   - Before/after comparison

**Result**: Production-quality documentation in ~45 minutes of agent work!

---

## Creating Your Own Custom Agent

### 1. Choose the Right Location

```
.github/agents/your-agent.md        # Team-shared (workspace)
~/.vscode/agents/your-agent.md      # Personal (user profile)
```

### 2. Create the Agent File

```markdown
---
description: "What this agent does. Use when: keywords for discovery"
name: "Agent Display Name"
tools: [read, edit, search]  # Minimal set needed
user-invocable: true
argument-hint: "What should the user provide?"
---

You are **[Agent Name]**, a specialist in [domain].

## Your Role
- What you do
- What you're good at

## Constraints
- DO NOT [things to avoid]
- ONLY [what to focus on]

## Workflow
1. Step one
2. Step two
3. Step three

## Output Format
What you should return
```

### 3. Test the Agent

```
@your-agent Test task to verify it works
```

---

## Best Practices

### ✅ Do This

1. **Be Specific in Description**
   ```yaml
   description: "Code review specialist for security, performance, and maintainability. Use when: reviewing code, security audit, performance check, code quality"
   ```

2. **Limit Tools**
   ```yaml
   tools: [read, search]  # Read-only for reviewers
   tools: [read, edit]    # Edit-only, no terminal
   tools: []              # Conversational only
   ```

3. **Clear Constraints**
   ```markdown
   ## Constraints
   - DO NOT make code changes (review only)
   - DO NOT run commands
   - ONLY provide written feedback
   ```

4. **Structured Output**
   ```markdown
   ## Output Format
   Provide feedback as:
   1. Summary
   2. Issues found (severity, location, fix)
   3. Recommendations
   ```

### ❌ Avoid This

1. **Vague Descriptions**
   ```yaml
   description: "A helpful agent"  # Too vague!
   ```

2. **Too Many Tools**
   ```yaml
   tools: [read, edit, search, execute, web, todo]  # Unfocused!
   ```

3. **Unclear Purpose**
   ```markdown
   You can do anything the user asks.  # No specialization!
   ```

---

## Common Custom Agent Types

### 1. Documentation Writer ✍️
- **Tools**: read, search, edit
- **Focus**: Writing docs
- **Example**: This repo!

### 2. Code Reviewer 🔍
- **Tools**: read, search
- **Focus**: Code quality, security
- **Output**: Review comments

### 3. Test Generator 🧪
- **Tools**: read, edit
- **Focus**: Unit/integration tests
- **Output**: Test files

### 4. Refactoring Specialist ♻️
- **Tools**: read, edit, search
- **Focus**: Code improvement
- **Output**: Refactored code

### 5. Security Auditor 🔒
- **Tools**: read, search
- **Focus**: Security vulnerabilities
- **Output**: Security report

---

## Tips for Success

### 1. Start Small
Begin with simple agents before creating complex workflows.

### 2. Test Iteratively
```
@your-agent Simple task first
# If works well...
@your-agent More complex task
```

### 3. Share with Team
Put agents in `.github/agents/` so your team can use them.

### 4. Document Your Agents
Add README in `.github/agents/README.md` explaining available agents.

### 5. Combine Agents
Use agents together:
```
@architect Design the new feature
@coder Implement the design
@tester Write tests for the implementation
@docs-writer Document the new feature
```

---

## Agent Discovery

How does Copilot find the right agent?

1. **Description keywords** match the user's request
2. **Agent name** if explicitly mentioned (`@docs-writer`)
3. **Context** from conversation history

**Pro tip**: Include trigger keywords in the `description`:
```yaml
description: "Use when: writing docs, creating README, documenting code, API reference, user guide, tutorial"
```

---

## Debugging

### Agent Not Found?

1. Check file location: `.github/agents/name.agent.md`
2. Verify frontmatter YAML is valid
3. Ensure `user-invocable: true`
4. Check description has relevant keywords

### Agent Not Behaving?

1. Review the instructions in the agent file
2. Add more specific constraints
3. Provide clearer output format requirements
4. Test with simpler tasks first

---

## Examples in This Repo

| Agent | File | Purpose |
|-------|------|---------|
| Documentation Writer | [docs-writer.md](../agents/docs-writer.md) | Write technical documentation |

**More to come!** Contributions welcome.

---

## Further Reading

- **[Agent Customization Skill](../../../AppData/Local/Programs/Microsoft%20VS%20Code/10c8e557c8/resources/app/extensions/copilot/assets/prompts/skills/agent-customization/SKILL.md)** - Official guide
- **[VS Code Copilot Docs](https://code.visualstudio.com/docs/copilot/customization/custom-agents)** - Microsoft documentation
- **[This Project's Agents](../agents/)** - See real examples

---

## Summary

Custom agents help you:
- ✅ **Specialize** AI for specific tasks
- ✅ **Constrain** tools for safety
- ✅ **Standardize** workflows
- ✅ **Accelerate** repetitive tasks
- ✅ **Delegate** work to specialized assistants

**Try it now**: `@docs-writer Help me document my code`

---

**Last Updated**: April 23, 2026  
**See Also**: [DOC-001 Task Example](../issues/DOC-001-webhook-documentation.md)
