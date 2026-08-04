using MinimalApi.Common;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace MinimalApi.Endpoints;

public static class HealthEndpoints
{
    public static void MapHealthEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/health");

        group.MapGet("/", () =>
        {
            var result = Result<object>.Success(new
            {
                Status = "Healthy",
                Timestamp = DateTime.UtcNow,
                Message = "API ejecutándose correctamente con Minimal API Architecture"
            });

            return result.ToHttpResult();
        })
        .Produces<object>(StatusCodes.Status200OK)
        .WithName("GetHealthStatus");
    }
}
