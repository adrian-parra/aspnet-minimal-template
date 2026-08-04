# 🚀 ASP.NET Core 9 Minimal API Starter & Automation Template

Generador de proyectos y plantilla nativa para **ASP.NET Core 9 Minimal API (C#)**. Permite crear en segundos APIs REST listas para producción con arquitectura limpia desacoplada, patrón `Result`, manejo de errores global, validaciones automáticas con FluentValidation, paquetes NuGet pre-instalados e infraestructura **Docker + Docker Compose** para MySQL y SQL Server.

---

## 🏛️ Arquitectura del Proyecto Generado

Cada proyecto generado con esta plantilla incluye la siguiente estructura desacoplada:

```text
MiNuevaApi/
├── Common/
│   ├── Result.cs                 # Patrón Result y Result<T> genérico
│   └── ResultExtensions.cs       # Mapeo a HttpResult (ToHttpResult) desacoplado
├── Middleware/
│   ├── GlobalExceptionHandler.cs # Manejador global de excepciones IExceptionHandler
│   └── ValidationFilter.cs       # Filtro genérico IEndpointFilter para FluentValidation
├── Endpoints/
│   └── HealthEndpoints.cs        # Endpoint inicial /api/health listo para usar
├── Dtos/                         # Objetos de Transferencia de Datos
├── Models/                       # Entidades de dominio
├── Repositories/                 # Capa de datos (Dapper / SQL / MySQL)
├── Services/                     # Capa de Lógica de Negocio
├── Validations/                  # Validadores FluentValidation
├── Program.cs                    # Configuración de Swagger, CORS, Handlers y Validators
├── appsettings.json              # ConnectionStrings para MySQL y SQL Server
├── Dockerfile                    # Multi-stage build para .NET 9
└── docker-compose.yml            # Orquestación con MySQL 8 y SQL Server 2022
```

---

## 📦 Paquetes NuGet Pre-instalados

- **`Dapper`**: Micro-ORM ultrarrápido para consultas SQL.
- **`FluentValidation.DependencyInjectionExtensions`**: Validaciones fluidas inyectables.
- **`MySqlConnector`**: Driver de alto rendimiento para MySQL.
- **`Microsoft.Data.SqlClient`**: Driver oficial para SQL Server.
- **`Swashbuckle.AspNetCore`**: Documentación interactiva con Swagger UI.

---

## ⚡ Instalación Rápida (1 Solo Paso)

Clona este repositorio y ejecuta el instalador automático:

```bash
git clone https://github.com/TU_USUARIO/aspnet-minimal-template.git
cd aspnet-minimal-template
./install.sh
```

---

## 💡 Formas de Uso

### Opción 1: Comando Nativo `dotnet new`
```bash
dotnet new minimal-api -n FacturacionApi
cd FacturacionApi
dotnet run
```

### Opción 2: Script Interactivo CLI (`create-aspnet-api`)
```bash
create-aspnet-api FacturacionApi
```
*(El script te guiará interactivamente para elegir la base de datos a utilizar: MySQL, SQL Server o ambas).*

---

## 🐳 Despliegue con Docker

Cualquier proyecto generado incluye un `docker-compose.yml` que puedes levantar en 1 comando:

```bash
docker compose up -d
```
- API REST: [http://localhost:5000](http://localhost:5000)
- Swagger UI: [http://localhost:5000/swagger](http://localhost:5000/swagger)

---

## 📜 Licencia
MIT License - Desarrollado para agilizar el desarrollo de APIs en C# .NET 9.
