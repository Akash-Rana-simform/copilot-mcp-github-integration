---
name: api-docs-generator
description: 'Generate comprehensive API documentation from .NET/C# source code. Use when: creating OpenAPI specs, generating Swagger docs, writing API reference, documenting REST endpoints, creating API markdown docs, updating controller documentation.'
argument-hint: 'Specify controllers/services to document (e.g., "WebhookController" or "all controllers")'
user-invocable: true
---

# API Documentation Generator

A specialized skill for generating comprehensive API documentation from .NET/C# source code, including OpenAPI specifications, Swagger documentation, and markdown API references.

## When to Use

Invoke this skill when you need to:
- 📝 Generate OpenAPI/Swagger specifications from controllers
- 📚 Create markdown API reference documentation
- 🔍 Document REST API endpoints with examples
- ✨ Update existing API documentation
- 📋 Generate request/response schemas
- 🎯 Create API usage guides for specific endpoints

**Trigger phrases**: "document API", "generate swagger", "create OpenAPI spec", "API reference", "REST documentation"

---

## Capabilities

This skill can:
1. **Analyze** controller classes to extract endpoint information
2. **Generate** OpenAPI 3.0 specifications
3. **Create** markdown API reference documentation
4. **Document** request/response models with examples
5. **Add** XML documentation comments to source code
6. **Generate** Postman collection templates
7. **Create** usage examples with curl and C# code

---

## Procedure

### Step 1: Analyze Source Code

Scan and identify:
- All controller classes (`*Controller.cs`)
- HTTP methods and routes
- Request/response models
- Data annotations and attributes
- XML documentation (if present)

**Action**: Read controller files in `src/**/Controllers/`

### Step 2: Extract Endpoint Metadata

For each endpoint, collect:
- HTTP verb (GET, POST, PUT, DELETE, etc.)
- Route path with parameters
- Request body schema
- Response status codes
- Authentication requirements
- Model validation rules

### Step 3: Generate Documentation

Use the [OpenAPI template](./templates/openapi-template.json) to create:
- `openapi.json` - OpenAPI 3.0 specification
- `API-REFERENCE.md` - Human-readable API documentation
- `POSTMAN-COLLECTION.json` - Postman import file (if requested)

### Step 4: Add Code Examples

For each endpoint, generate:
- **curl** examples with headers and body
- **C#** client code using HttpClient
- **Request/Response** examples with realistic data
- **Error scenarios** with status codes

### Step 5: Validate and Format

- Validate OpenAPI spec against schema
- Format JSON with proper indentation
- Check markdown formatting
- Verify all links work
- Test example requests (if possible)

---

## Templates & Assets

### Available Templates

1. **[OpenAPI Template](./templates/openapi-template.json)** - Base OpenAPI 3.0 structure
2. **[API Reference Template](./templates/api-reference-template.md)** - Markdown format
3. **[Endpoint Template](./templates/endpoint-template.md)** - Single endpoint doc
4. **[Model Schema Template](./templates/model-schema-template.json)** - JSON schema for models

### Helper Scripts

1. **[Extract Metadata](./scripts/extract-metadata.ps1)** - Parse C# attributes
2. **[Validate OpenAPI](./scripts/validate-openapi.ps1)** - Validate spec
3. **[Generate Examples](./scripts/generate-examples.ps1)** - Create realistic examples

---

## Output Structure

Generated files will be placed in:

```
docs/api/
├── openapi.json              # OpenAPI 3.0 specification
├── API-REFERENCE.md          # Complete API documentation
├── endpoints/                # Individual endpoint docs
│   ├── webhooks-post.md
│   ├── webhooks-get.md
│   └── webhooks-id-get.md
└── examples/                 # Code examples
    ├── curl-examples.sh
    ├── csharp-examples.cs
    └── postman-collection.json
```

---

## Usage Examples

### Example 1: Document All Controllers

```
/api-docs-generator all controllers
```

**Output**: Complete OpenAPI spec + markdown docs for all controllers

### Example 2: Document Specific Controller

```
/api-docs-generator WebhookController
```

**Output**: Documentation for WebhookController endpoints only

### Example 3: Update Existing Docs

```
/api-docs-generator update docs/api/API-REFERENCE.md
```

**Output**: Refreshed documentation with latest changes

### Example 4: Generate with Postman Collection

```
/api-docs-generator all controllers with postman
```

**Output**: API docs + Postman collection for testing

---

## Configuration

### Custom Settings

You can customize the generation in [config.json](./config.json):

```json
{
  "outputPath": "docs/api",
  "includeExamples": true,
  "includeSchemas": true,
  "generatePostman": false,
  "apiVersion": "1.0.0",
  "apiTitle": "Your API Name",
  "apiDescription": "API description",
  "serverUrl": "https://localhost:5000"
}
```

---

## Best Practices

### ✅ Do This

1. **Run after controller changes** to keep docs in sync
2. **Review generated docs** for accuracy
3. **Add examples** for complex endpoints
4. **Include error responses** (400, 401, 404, 500)
5. **Document authentication** requirements clearly
6. **Use realistic example data** (not foo/bar)

### ❌ Avoid This

1. Don't skip XML documentation in source code
2. Don't forget to update when adding new endpoints
3. Don't use production secrets in examples
4. Don't leave TODO comments in generated docs
5. Don't generate docs for internal/debug endpoints

---

## Integration with Project

### Prerequisites

1. Controllers have `[ApiController]` attribute
2. Routes are defined with `[HttpGet]`, `[HttpPost]`, etc.
3. Models have data annotations (`[Required]`, `[MaxLength]`, etc.)
4. XML documentation is enabled in project file:
   ```xml
   <GenerateDocumentationFile>true</GenerateDocumentationFile>
   ```

### After Generation

1. **Review** the generated `openapi.json`
2. **Test** endpoints using generated examples
3. **Commit** docs to version control
4. **Update** README with link to API-REFERENCE.md
5. **Configure** Swagger UI (if not already done)

---

## Troubleshooting

### Issue: Missing endpoint descriptions

**Cause**: No XML documentation comments in controller

**Solution**: Add XML comments:
```csharp
/// <summary>
/// Creates a new webhook
/// </summary>
/// <param name="request">Webhook data</param>
/// <returns>Created webhook</returns>
[HttpPost]
public async Task<IActionResult> Create([FromBody] WebhookRequest request)
```

### Issue: Invalid OpenAPI spec

**Cause**: Malformed JSON or missing required fields

**Solution**: Run [validation script](./scripts/validate-openapi.ps1):
```powershell
.\scripts\validate-openapi.ps1 -SpecPath docs/api/openapi.json
```

### Issue: Examples don't match schema

**Cause**: Schema changed but examples weren't updated

**Solution**: Regenerate examples:
```
/api-docs-generator regenerate examples for WebhookController
```

---

## Advanced Features

### Custom Response Types

Document custom response types in [reference docs](./references/custom-responses.md).

### Authentication Schemes

Document auth schemes in [reference docs](./references/authentication.md).

### Versioning Strategy

Document API versioning in [reference docs](./references/versioning.md).

---

## Quality Checklist

Before considering documentation complete:

- [ ] All endpoints have descriptions
- [ ] Request/response schemas are accurate
- [ ] Examples include realistic data
- [ ] Error responses are documented
- [ ] Authentication is explained
- [ ] Rate limiting is documented (if applicable)
- [ ] OpenAPI spec validates successfully
- [ ] Links to models work correctly
- [ ] Code examples are tested
- [ ] Postman collection imports successfully

---

## See Also

- [OpenAPI Specification](https://swagger.io/specification/)
- [Swagger Editor](https://editor.swagger.io/) - Validate your spec
- [Postman](https://www.postman.com/) - Test your API
- [Project README](../../README.md) - Main documentation

---

**Last Updated**: April 24, 2026  
**Skill Version**: 1.0  
**Compatibility**: .NET 8, ASP.NET Core
