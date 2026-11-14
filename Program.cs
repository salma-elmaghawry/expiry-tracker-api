using System.Text.Json.Serialization;
using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Endpoints;
using ExpiryTracker.Api.Services;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("Default")));

builder.Services.AddScoped<BatchService>();
builder.Services.AddScoped<DashboardService>();
builder.Services.AddScoped<ReportService>();
builder.Services.AddScoped<DemoSeedService>();
builder.Services.AddScoped<CartonService>();
builder.Services.AddScoped<LabelService>();
// One instance for the whole app: it only holds the signing key (like a get_it lazy singleton).
builder.Services.AddSingleton<LabelSigner>();

// Flutter Web runs in the browser on another port (http://localhost:xxxxx),
// so the browser asks the API first: "may this page call you?". CORS is the answer.
// Only pages served from this same computer are allowed.
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy => policy
        .SetIsOriginAllowed(origin => Uri.TryCreate(origin, UriKind.Absolute, out var uri) && uri.IsLoopback)
        .AllowAnyHeader()
        .AllowAnyMethod());
});

builder.Services.ConfigureHttpJsonOptions(options =>
{
    // Enums travel as text in JSON too: "Dairy" instead of 0
    options.SerializerOptions.Converters.Add(new JsonStringEnumConverter());
    // Reject JSON that is missing a required field or sends null for a non-nullable one
    options.SerializerOptions.RespectRequiredConstructorParameters = true;
    options.SerializerOptions.RespectNullableAnnotations = true;
});

var app = builder.Build();

app.UseCors();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference(); // test UI at /scalar

    // Deletes all data, so it only exists in Development. In the real supermarket this URL is a 404.
    app.MapDemoEndpoints();
}

app.MapBatchEndpoints();
app.MapDashboardEndpoints();
app.MapReportEndpoints();
app.MapCartonEndpoints();
app.MapLabelEndpoints();

app.Run();
