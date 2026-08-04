using Microsoft.AspNetCore.Http;

namespace MinimalApi.Common;

public static class ResultExtensions
{
    public static IResult ToHttpResult(this Result result)
    {
        if (result.IsSuccess) return Results.Ok();
        return Results.Problem(detail: result.ErrorMessage, statusCode: result.StatusCode);
    }

    public static IResult ToHttpResult<T>(this Result<T> result)
    {
        if (result.IsSuccess) return Results.Ok(result.Value);
        return Results.Problem(detail: result.ErrorMessage, statusCode: result.StatusCode);
    }
}
