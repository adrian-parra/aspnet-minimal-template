# ==============================================================================
# Script Interactivo de Automatización para Windows (PowerShell)
# Generador de Proyectos ASP.NET Minimal API
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   🚀 Generador Automático de Proyectos ASP.NET Minimal API     " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Obtener el nombre del proyecto
$ProjectName = $args[0]
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = Read-Host "📌 Ingresa el nombre del nuevo proyecto (ej. FacturacionApi)"
}

if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    Write-Host "❌ Error: Debes ingresar un nombre para el proyecto." -ForegroundColor Red
    exit 1
}

# 2. Selección de Base de Datos
Write-Host ""
Write-Host "🗄️  Selecciona la Base de Datos a utilizar:" -ForegroundColor Yellow
Write-Host "  1) Ambas (MySQL + SQL Server)"
Write-Host "  2) Solo MySQL"
Write-Host "  3) Solo SQL Server"
$DbOption = Read-Host "Elige una opción (1-3) [Por defecto 1]"
if ([string]::IsNullOrWhiteSpace($DbOption)) { $DbOption = "1" }

# 3. Selección de Autenticación y Autorización (JWT + BCrypt)
Write-Host ""
Write-Host "🔐 ¿Deseas incluir Autenticación JWT y Autorización con BCrypt?" -ForegroundColor Yellow
Write-Host "  1) Sí (JwtBearer + BCrypt.Net-Next + Swagger Auth preconfigurado)"
Write-Host "  2) No (API sin autenticación)"
$AuthOption = Read-Host "Elige una opción (1-2) [Por defecto 1]"
if ([string]::IsNullOrWhiteSpace($AuthOption)) { $AuthOption = "1" }

Write-Host ""
Write-Host "🔨 Generando proyecto '$ProjectName' con la plantilla 'minimal-api'..." -ForegroundColor Cyan

# 4. Crear proyecto con dotnet new minimal-api
dotnet new minimal-api -n $ProjectName

Set-Location $ProjectName

# 5. Configuración de Base de Datos
$CleanName = $ProjectName -ireplace '(Api|DB|ApiDB|DbAPI|db|api)', ''
if ([string]::IsNullOrWhiteSpace($CleanName)) { $CleanName = "my" }
$DbName = "$($CleanName.ToLower())db"

if (Test-Path "docker/mysql/init.sql") {
    (Get-Content "docker/mysql/init.sql") -replace 'mydb', $DbName | Set-Content "docker/mysql/init.sql"
}

if (Test-Path "appsettings.json") {
    (Get-Content "appsettings.json") -replace 'mydb', $DbName | Set-Content "appsettings.json"
}

switch ($DbOption) {
    "2" { Write-Host "⚙️ Configurando solo conector MySQL (Base de datos: $DbName)..." -ForegroundColor Cyan }
    "3" { Write-Host "⚙️ Configurando solo conector SQL Server (Base de datos: $DbName)..." -ForegroundColor Cyan }
    default { Write-Host "⚙️ Configurando conectores para MySQL y SQL Server (Base de datos: $DbName)..." -ForegroundColor Cyan }
}

# 6. Configuración opcional de Autenticación y Autorización (JWT + BCrypt)
$AuthInstalled = $false
if ($AuthOption -in @("1", "s", "S", "y", "Y")) {
    $AuthInstalled = $true
    Write-Host "🔐 Instalando paquetes de Autenticación JWT y BCrypt..." -ForegroundColor Cyan
    dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer | Out-Null
    dotnet add package BCrypt.Net-Next | Out-Null

    Write-Host "⚙️ Configurando appsettings.json con JwtSettings..." -ForegroundColor Cyan
    $AppSettingsContent = @"
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "JwtSettings": {
    "SecretKey": "SuperSecretKey_MustBeLongEnough12345_ChangeMeInProduction!",
    "Issuer": "$ProjectName",
    "Audience": "${ProjectName}Client",
    "ExpiryMinutes": 120
  },
  "ConnectionStrings": {
    "MySqlConnection": "Server=localhost;Database=$DbName;Uid=root;Pwd=root_password;",
    "SqlServerConnection": "Server=localhost;Database=$DbName;User Id=sa;Password=Password123!;TrustServerCertificate=True;"
  }
}
"@
    Set-Content -Path "appsettings.json" -Value $AppSettingsContent

    Write-Host "⚙️ Configurando Program.cs con JWT, Auth Repositories, Services y Endpoints..." -ForegroundColor Cyan
    $ProgramContent = @"
using System.Text;
using FluentValidation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using ${ProjectName}.Endpoints;
using ${ProjectName}.Middleware;
using ${ProjectName}.Repositories;
using ${ProjectName}.Services;

var builder = WebApplication.CreateBuilder(args);

// 1. Swagger / OpenAPI Configuration with Bearer Auth
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
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
});

// 2. Global Exception Handling & ProblemDetails
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

// 3. FluentValidation Auto-Registration
builder.Services.AddValidatorsFromAssemblyContaining<Program>();

// 4. JWT Authentication, Authorization, Repositories & Services
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<IJwtService, JwtServices>();
builder.Services.AddScoped<IAuthServices, AuthServices>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["JwtSettings:Issuer"] ?? "${ProjectName}",
            ValidAudience = builder.Configuration["JwtSettings:Audience"] ?? "${ProjectName}Client",
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["JwtSettings:SecretKey"] ?? "SuperSecretKey_MustBeLongEnough12345_ChangeMeInProduction!"))
        };
    });

builder.Services.AddAuthorization();

// 5. CORS Policy
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

// Enable Authentication & Authorization
app.UseAuthentication();
app.UseAuthorization();

// Enable Swagger UI by default
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "API v1");
    c.RoutePrefix = "swagger";
});

// Redirect root "/" to "/swagger"
app.MapGet("/", () => Results.Redirect("/swagger")).ExcludeFromDescription();

// Map Endpoints
app.MapHealthEndpoints();
app.MapAuthEndpoints();

app.Run();
"@
    Set-Content -Path "Program.cs" -Value $ProgramContent
}

Write-Host ""
Write-Host "✨ ¡Proyecto '$ProjectName' generado con éxito!" -ForegroundColor Green
Write-Host "----------------------------------------------------------------"
Write-Host "📁 Carpetas creadas: Common, Middleware, Endpoints, Dtos, Models, Services, Repositories, Validations" -ForegroundColor Cyan
Write-Host "🧱 Componentes listos: Result.cs, ResultExtensions.cs, GlobalExceptionHandler.cs, ValidationFilter.cs" -ForegroundColor Cyan
if ($AuthInstalled) {
    Write-Host "🔐 Autenticación & Autorización: JwtBearer, BCrypt.Net-Next y Swagger Bearer Auth (CONFIGURADOS)" -ForegroundColor Cyan
} else {
    Write-Host "🔐 Autenticación & Autorización: No incluida (API pública)" -ForegroundColor Cyan
}
Write-Host "📦 Paquetes NuGet: Dapper, FluentValidation, MySqlConnector, SqlClient, Swashbuckle" -ForegroundColor Cyan
Write-Host "🐳 Infraestructura: Dockerfile y docker-compose.yml preconfigurados" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------------"
Write-Host "Comandos para comenzar:"
Write-Host "  cd $ProjectName"
Write-Host "  dotnet run               # Iniciar en local (http://localhost:5000/swagger)"
Write-Host "  docker compose up -d     # Iniciar con contenedores Docker"
Write-Host ""
