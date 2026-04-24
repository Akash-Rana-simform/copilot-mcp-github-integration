# API Documentation Generator Skill

A comprehensive skill for generating API documentation from .NET/C# source code.

## Overview

This skill automates the creation of:
- OpenAPI 3.0 specifications
- Markdown API reference documentation
- Request/response examples
- Postman collections
- Code samples in multiple languages

## Files Structure

```
api-docs-generator/
├── SKILL.md                       # Main skill file
├── config.json                    # Configuration settings
├── templates/                     # Documentation templates
│   ├── openapi-template.json
│   ├── api-reference-template.md
│   ├── endpoint-template.md
│   └── model-schema-template.json
├── scripts/                       # Helper PowerShell scripts
│   ├── extract-metadata.ps1      # Extract API metadata from C#
│   ├── validate-openapi.ps1      # Validate OpenAPI spec
│   └── generate-examples.ps1     # Generate realistic examples
└── references/                    # Reference documentation
    ├── authentication.md          # Auth schemes documentation
    ├── custom-responses.md        # Response types reference
    └── versioning.md              # API versioning strategy

```

## Usage

### Invoke as Slash Command

In Copilot Chat, type `/api-docs-generator` followed by your request:

```
/api-docs-generator all controllers
```

```
/api-docs-generator WebhookController
```

```
/api-docs-generator update docs with examples
```

### Automatic Invocation

The skill activates automatically when you ask about API documentation:

```
Generate OpenAPI spec for my controllers
```

```
Document the REST API endpoints
```

```
Create API reference documentation
```

## What It Generates

### 1. OpenAPI Specification

Complete OpenAPI 3.0 JSON file with:
- All endpoints documented
- Request/response schemas
- Authentication schemes
- Error responses
- Examples

**Output**: `docs/api/openapi.json`

### 2. Markdown API Reference

Human-readable documentation with:
- Table of contents
- Authentication guide
- Endpoint descriptions with examples
- Error handling guide
- Model schemas

**Output**: `docs/api/API-REFERENCE.md`

### 3. Code Examples

Examples in multiple languages:
- cURL commands
- C# HttpClient code
- Request/response JSON

**Output**: `docs/api/examples/`

### 4. Postman Collection (Optional)

Importable Postman collection for testing.

**Output**: `docs/api/postman-collection.json`

## Configuration

Edit [config.json](config.json) to customize:

```json
{
  "apiTitle": "Your API Name",
  "apiVersion": "1.0.0",
  "serverUrl": "https://your-api.com",
  "includeExamples": true,
  "generatePostman": false
}
```

## Helper Scripts

### Extract Metadata

Parse C# controllers to extract endpoint information:

```powershell
.\scripts\extract-metadata.ps1 -ControllerPath "src/Controllers/WebhookController.cs"
```

### Validate OpenAPI

Validate generated OpenAPI specification:

```powershell
.\scripts\validate-openapi.ps1 -SpecPath "docs/api/openapi.json"
```

### Generate Examples

Create realistic request/response examples:

```powershell
.\scripts\generate-examples.ps1 -ModelType "Webhook" -OutputPath "docs/api/examples"
```

## Reference Documentation

Detailed guides for advanced topics:

- **[Authentication](references/authentication.md)** - Auth schemes and security
- **[Custom Responses](references/custom-responses.md)** - Response types and formats
- **[Versioning](references/versioning.md)** - API versioning strategy

## Example Workflow

1. **Develop your API** with proper attributes:
   ```csharp
   [ApiController]
   [Route("api/[controller]")]
   public class WebhookController : ControllerBase
   {
       /// <summary>
       /// Creates a new webhook
       /// </summary>
       [HttpPost]
       [ProducesResponseType(typeof(WebhookResponse), 200)]
       public async Task<IActionResult> Create([FromBody] WebhookRequest request)
       {
           // Implementation
       }
   }
   ```

2. **Invoke the skill**:
   ```
   /api-docs-generator WebhookController
   ```

3. **Review generated files**:
   - `docs/api/openapi.json`
   - `docs/api/API-REFERENCE.md`
   - `docs/api/examples/`

4. **Validate and deploy**:
   ```powershell
   .\scripts\validate-openapi.ps1 -SpecPath "docs/api/openapi.json"
   ```

## Prerequisites

For best results:

1. **XML Documentation**: Enable in `.csproj`:
   ```xml
   <GenerateDocumentationFile>true</GenerateDocumentationFile>
   ```

2. **Attributes**: Use proper ASP.NET Core attributes:
   - `[ApiController]`
   - `[Route]`
   - `[HttpGet]`, `[HttpPost]`, etc.
   - `[ProducesResponseType]`

3. **Data Annotations**: Add validation attributes to models:
   - `[Required]`
   - `[MaxLength]`
   - `[Range]`

## Troubleshooting

### Skill not found

Make sure the folder structure is correct:
```
.github/skills/api-docs-generator/SKILL.md
```

### Missing endpoint descriptions

Add XML documentation comments to controller methods:
```csharp
/// <summary>
/// Method description here
/// </summary>
```

### Invalid OpenAPI spec

Run validation script to find issues:
```powershell
.\scripts\validate-openapi.ps1 -SpecPath "docs/api/openapi.json"
```

## Benefits

- ✅ **Saves time**: Automated documentation generation
- ✅ **Consistency**: Standardized format across all endpoints
- ✅ **Accuracy**: Generated directly from source code
- ✅ **Up-to-date**: Easy to regenerate when code changes
- ✅ **Complete**: Includes examples, errors, and authentication
- ✅ **Developer-friendly**: Multiple output formats

## See Also

- [OpenAPI Specification](https://swagger.io/specification/)
- [Swagger UI](https://swagger.io/tools/swagger-ui/)
- [Postman](https://www.postman.com/)
- [Main Project Documentation](../../README.md)

---

**Skill Version**: 1.0  
**Created**: April 24, 2026  
**Compatibility**: .NET 8, ASP.NET Core, OpenAPI 3.0
