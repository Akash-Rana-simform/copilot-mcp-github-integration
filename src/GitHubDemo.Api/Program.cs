using GitHubDemo.Api.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure GitHub service
builder.Services.AddSingleton<IGitHubService>(sp => 
{
    var token = Environment.GetEnvironmentVariable("GITHUB_TOKEN") 
        ?? throw new InvalidOperationException("GITHUB_TOKEN environment variable not set");
    return new GitHubService(token);
});

// Configure Webhook service (for prompt engineering demo)
builder.Services.AddSingleton<IWebhookService, WebhookService>();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
