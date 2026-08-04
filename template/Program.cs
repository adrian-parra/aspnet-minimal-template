using FluentValidation;
using MinimalApi.Endpoints;
using MinimalApi.Middleware;

var builder = WebApplication.CreateBuilder(args);

// 1. Swagger / OpenAPI Configuration
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// 2. Global Exception Handling & ProblemDetails
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

// 3. FluentValidation Auto-Registration
builder.Services.AddValidatorsFromAssemblyContaining<Program>();

// 4. CORS Policy (Permissive for React/Angular/Docker Frontend)
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
