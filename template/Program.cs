using FluentValidation;
using MinimalApi.Endpoints;
using MinimalApi.Middleware;
using MinimalApi.Services;
// Descomentar para JWT:
// using System.Text;
// using Microsoft.AspNetCore.Authentication.JwtBearer;
// using Microsoft.IdentityModel.Tokens;
// using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// 1. Swagger / OpenAPI Configuration
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    // Descomentar si usas JWT Bearer Token en Swagger:
    /*
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Ingrese únicamente el Token JWT devuelto por el /api/auth/login"
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
    */
});

// 2. Global Exception Handling & ProblemDetails
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

// 3. FluentValidation Auto-Registration
builder.Services.AddValidatorsFromAssemblyContaining<Program>();

// 4. JWT Authentication, Authorization & Services (Descomentar para habilitar)
/*
builder.Services.AddScoped<IJwtService, JwtServices>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["JwtSettings:Issuer"] ?? "MinimalApi",
            ValidAudience = builder.Configuration["JwtSettings:Audience"] ?? "MinimalApiClient",
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["JwtSettings:SecretKey"] ?? "SuperSecretKey_MustBeLongEnough12345!"))
        };
    });

builder.Services.AddAuthorization();
*/

// 5. CORS Policy (Permissive for React/Angular/Docker Frontend)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.SetIsOriginAllowed(_ => true)
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

app.UseCors("AllowAll");
app.UseExceptionHandler();

// Descomentar si usas Autenticación y Autorización:
// app.UseAuthentication();
// app.UseAuthorization();

// Enable Swagger UI by default
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "API v1");
    c.RoutePrefix = "swagger";
});

// Redirect root "/" to "/swagger" (Oculto de la documentación Swagger con ExcludeFromDescription)
app.MapGet("/", () => Results.Redirect("/swagger")).ExcludeFromDescription();

// Map Endpoints
app.MapHealthEndpoints();

app.Run();
