# Etapa 1: Compilación (Build Stage)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["MinimalApi.csproj", "./"]
RUN dotnet restore "MinimalApi.csproj"

COPY . .
RUN dotnet publish "MinimalApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa 2: Ejecución en Producción (Runtime Stage)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "MinimalApi.dll"]
