## {HTTP_METHOD} {ENDPOINT_PATH}

{ENDPOINT_DESCRIPTION}

### Request

```http
{HTTP_METHOD} {ENDPOINT_PATH} HTTP/1.1
Host: {API_HOST}
Authorization: Bearer YOUR_TOKEN
Content-Type: application/json
```

### Path Parameters

{PATH_PARAMETERS_TABLE}

### Query Parameters

{QUERY_PARAMETERS_TABLE}

### Request Body

{REQUEST_BODY_SCHEMA}

**Example**:
```json
{REQUEST_BODY_EXAMPLE}
```

### Response

**Status**: `{SUCCESS_STATUS_CODE}`

```json
{RESPONSE_BODY_EXAMPLE}
```

### Error Responses

| Status | Description |
|--------|-------------|
| 400 | Bad Request - {ERROR_400_DESCRIPTION} |
| 401 | Unauthorized - {ERROR_401_DESCRIPTION} |
| 404 | Not Found - {ERROR_404_DESCRIPTION} |
| 500 | Internal Server Error - {ERROR_500_DESCRIPTION} |

**Error Example** (`400 Bad Request`):
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "Bad Request",
  "status": 400,
  "detail": "{ERROR_DETAIL}",
  "errors": {
    "{FIELD_NAME}": ["{ERROR_MESSAGE}"]
  }
}
```

### Code Examples

**cURL**:
```bash
curl -X {HTTP_METHOD} "{API_HOST}{ENDPOINT_PATH}" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{REQUEST_BODY_EXAMPLE}'
```

**C#**:
```csharp
var client = new HttpClient();
client.DefaultRequestHeaders.Add("Authorization", "Bearer YOUR_TOKEN");

var request = new {REQUEST_MODEL_TYPE}
{
    {REQUEST_MODEL_PROPERTIES}
};

var response = await client.{HTTP_METHOD_CAPITALIZED}AsJsonAsync(
    "{ENDPOINT_PATH}", 
    request
);

var result = await response.Content.ReadFromJsonAsync<{RESPONSE_MODEL_TYPE}>();
```

### Notes

{ADDITIONAL_NOTES}

---

**Tags**: {TAGS}  
**Authentication**: Required  
**Rate Limit**: Applies
