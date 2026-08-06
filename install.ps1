# ==============================================================================
# Script de Instalación Automática para Windows - ASP.NET Minimal API Starter Template
# ==============================================================================

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  ⚙️ Instalando Plantilla ASP.NET Core Minimal API Starter (Windows)" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Instalar la plantilla nativa de dotnet
Write-Host "📦 Instalando la plantilla en el SDK de .NET..." -ForegroundColor Yellow
dotnet new install "$ScriptDir\template" --force

# 2. Configurar directorio bin en el usuario
$BinDir = Join-Path $env:USERPROFILE ".bin"
if (-not (Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir | Out-Null
}

Write-Host "🚀 Copiando scripts CLI a $BinDir..." -ForegroundColor Yellow
Copy-Item "$ScriptDir\bin\create-aspnet-api.ps1" -Destination "$BinDir\create-aspnet-api.ps1" -Force
Copy-Item "$ScriptDir\bin\create-aspnet-api.cmd" -Destination "$BinDir\create-aspnet-api.cmd" -Force

# 3. Agregar ~/.bin al PATH del Usuario en Windows si no existe
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($UserPath -notlike "*$BinDir*") {
    Write-Host "🔧 Agregando $BinDir al PATH del Usuario..." -ForegroundColor Yellow
    [Environment]::SetEnvironmentVariable("PATH", "$UserPath;$BinDir", "User")
}

Write-Host ""
Write-Host "✨ ¡Instalación completada con éxito!" -ForegroundColor Green
Write-Host "----------------------------------------------------------------"
Write-Host "Puedes usar la plantilla en Windows de 2 formas:"
Write-Host ""
Write-Host "1) Nativo de .NET (CMD o PowerShell):" -ForegroundColor Cyan
Write-Host "   dotnet new minimal-api -n MiNuevaApi"
Write-Host ""
Write-Host "2) Script CLI Interactivo (CMD o PowerShell):" -ForegroundColor Cyan
Write-Host "   create-aspnet-api MiNuevaApi"
Write-Host "----------------------------------------------------------------"
