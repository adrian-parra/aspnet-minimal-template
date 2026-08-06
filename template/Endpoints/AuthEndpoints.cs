using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using MinimalApi.Common;
using MinimalApi.Dtos;
using MinimalApi.Middleware;
using MinimalApi.Services;

namespace MinimalApi.Endpoints;

public static class AuthEndpoints
{
    public static void MapAuthEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/auth");

        group.MapPost("/register", RegisterUserAsync)
            .WithName("RegisterUser")
            .Produces<UserResponseDto>(StatusCodes.Status200OK)
            .Produces<string>(StatusCodes.Status400BadRequest)
            .AddEndpointFilter<ValidationFilter<UserRegisterDto>>();

        group.MapPost("/login", LoginUserAsync)
            .WithName("LoginUser")
            .Produces<AuthResponseDto>(StatusCodes.Status200OK)
            .Produces<string>(StatusCodes.Status400BadRequest)
            .AddEndpointFilter<ValidationFilter<UserLoginDto>>();
    }

    private static async Task<IResult> RegisterUserAsync(UserRegisterDto userRegisterDto, IAuthServices authServices)
    {
        var result = await authServices.RegisterUserAsync(userRegisterDto);
        return result.ToHttpResult();
    }

    private static async Task<IResult> LoginUserAsync(UserLoginDto userLoginDto, IAuthServices authServices)
    {
        var result = await authServices.LoginUserAsync(userLoginDto);
        return result.ToHttpResult();
    }
}
