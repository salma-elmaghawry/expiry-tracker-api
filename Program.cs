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

builder.Services.ConfigureHttpJsonOptions(options =>
{
    // Enums travel as text in JSON too: "Dairy" instead of 0
    options.SerializerOptions.Converters.Add(new JsonStringEnumConverter());
    // Reject JSON that is missing a required field or sends null for a non-nullable one
    options.SerializerOptions.RespectRequiredConstructorParameters = true;
    options.SerializerOptions.RespectNullableAnnotations = true;
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference(); // test UI at /scalar
}

app.MapBatchEndpoints();

app.Run();
